import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/colors.dart';
import 'package:localstorage/localstorage.dart';

import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:intl/intl.dart';
// Notification screen
class SchedulePage extends StatefulWidget {
  SchedulePage();
  @override
  _SchedulePageState createState() => _SchedulePageState();
}
class _SchedulePageState extends State<SchedulePage> with TickerProviderStateMixin {
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  AnimationController _animationController;
  Map _schedule={};
  List _selectedEvents=[];
  bool _loadingScheduleIndicator;
  String _message;
  int unit;
  int totalUnit;
  bool _continue;
  TextEditingController _txtController = TextEditingController();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  _SchedulePageState();
  @override
  void initState(){
    super.initState();
    _continue=false;
    _loadingScheduleIndicator=true;
    final _selectedDay = DateTime.now();

    // print(_selectedDay.millisecond);
    _schedule=localStorage.getItem(STORAGE_SCHEDULE_KEY);
    _events={};
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );
    _animationController.forward();
    unit=int.tryParse(_schedule['post']['quantity']);
    totalUnit=0;
    _loadSchedule(_selectedDay);
    _clearProductInCart();
  }
  @override
  void dispose(){
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  void increament(){
    if(unit>=9999)return;
    setState(() {
      unit++;
    });
  }
  void decreament(){
    setState(() {
      if(unit>1)unit--;
      else unit=1;
    });
  }
  void _clearProductInCart(){
    fetchCart(id:'clear-product-${_schedule['product']['id']}');
  }
  void _onDaySelected(DateTime day, List events){
    debugPrint('Callback: _onDaySelected');
    _loadSchedule(day);
    debugPrint(events.toString());
  }
  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format){
    debugPrint('Callback: _onVisibleDaysChanged');
  }
 
  void _warning(msg){
   setState(() {
     _message= msg ;
   });
  }
  void _unitInput(){
  _txtController.text='$unit';
  showDialog(context: context,builder: (BuildContext context){
      return Dialog(
        child: Padding(
        padding:EdgeInsets.symmetric(horizontal: 10),
          child:TextField(
            controller: _txtController,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10)
            ),
            onSubmitted: (e)=>setState(() {
                int qty=int.tryParse(e);
                if(qty>9999){
                unit=9999;
                }
                else{
                unit=qty;
                }
                Navigator.of(context).pop();
              }
            ),
            style: TextStyle(
              textBaseline: TextBaseline.alphabetic,
            ),
          )
        ),
      );
    });
  }
  void _totalUnitInput(){
    showDialog(context: context,builder: (BuildContext context){
      return Dialog(
        child: Padding(
            padding:EdgeInsets.symmetric(horizontal: 10),
            child:TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10)
              ),
              onSubmitted: (e)=>setState(() {
                int qty=int.tryParse(e);
                if(totalUnit>qty){
                  Navigator.of(context).pop();
                  showDialog(context: context,child: SmartAlert(title: 'Alert',description: 'You can\'t choose quantity below it\'s current set unit',));
                  return;
                }
                else if(qty>9999){
                  _schedule['post']['quantity']='9999';
                }
                else{
                  _schedule['post']['quantity']=e;
                }
                Navigator.of(context).pop();
              }),
              style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
              ),
            )
        ),
      );
    });
  }
  Widget _buildEventList(){
    return SizedBox(
        height: 200,
        child:ListView(
          shrinkWrap: true,
          children: _selectedEvents.map<Widget>((event)=> Container(
            child: ListTile(
              selected: false,
              title: Text(isNull(event['timeSlot'],replace: 'Time Slot')),
              subtitle: Text('${event['quantityLeft']} ${isNull(_schedule['product']['unit'],replace: 'unit')} left'),
              leading: Checkbox(
                value: _events[_calendarController.selectedDay]!=null && _events[_calendarController.selectedDay].any((e){
                  return e['id']==event['id'];
                }),
                onChanged: (_){
                  if (_){
                    Map<String,dynamic> item={};
                    item['id']=event['id'];
                    item['title']=event['timeSlot'];
                    item['quantityLeft']=event['quantityLeft'];
                    item['time']=_calendarController.selectedDay;
                   _addSchd(item);
                  }else{
                    Map<String,dynamic> item={};
                    item['id']=event['id'];
                    item['title']=event['timeSlot'];
                    item['quantityLeft']=event['quantityLeft'];
                    item['time']=_calendarController.selectedDay;
                   _removeSchd(item);
                  }
                  return _;
                },
              ),
            ),
          )
          ).toList(),
        )
    );
  }
  void _loadSchedule(DateTime day){
    _scheduleLoaded(state: false);
    _warning(null);
    DateTime  _check  = day.toUtc();
    DateTime _now = DateTime.now().toUtc();
    if(_check.isBefore(_now)){
      _scheduleLoaded();
      _warning("You can't choose previous date");
      return;
    }
    if(_check.day == _now.day && _check.year==_now.year && _check.month ==_now.month){
      _scheduleLoaded();
      _warning("You can't schedule for today");
      return;
    }
    _schedule['post']['schedule']=_check.toIso8601String();
    scheduleOrder(_schedule['post']).then((schedules){
      if(schedules==false || schedules==null)
        return;
      if(schedules['data'] is List) {
        List data = schedules['data'];
        setState(() {
          _selectedEvents = data;
          _scheduleLoaded();
        });
      }else{
        setState(() {
          _selectedEvents = [];
          _scheduleLoaded();
        });
      }
    });
  }
  void _scheduleLoaded({state=true}){
    setState(() {
      _loadingScheduleIndicator=!state;
    });
  }
  void _removeSchd(item){
    setState(() {
      _events[item['time']].removeWhere((e){
        bool test= e['id']==item['id'];
        if(test){
          totalUnit-=e['qty'];
          fn(res){
//            print(res);
            if(isNull(res) || res is bool){
              _addSchd(item);
            }
          }
          if(!isNull(e['cartId'])){
//            print(e['cartId']);
            destroyCart('${e['cartId']}')
                .then(fn);
          }
        }
        return test;
      });
    });
  }
  void _addSchd(item){
    int  qty=int.tryParse(_schedule['post']['quantity']);
    if(totalUnit+unit > qty){
      num _left= qty-totalUnit;
      String _msg;
      if(_left>0){
        _msg="You have only $_left to schedule. you are trying to schedule more than 'Quantity Needed'";
      }else{
        _msg="You have already scheduled all 'Quantity Needed'";
      }
      showDialog(context: context,child: SmartAlert(title: 'Alert',description: _msg,));
      return;
    }
    else if(unit>item['quantityLeft']){
      showDialog(context: context,child: SmartAlert(title: 'Alert',description: 'You can only schedule ${item['quantityLeft']} for this time',));
      return;
    }
    setState(() {
      if(_events[item['time']]==null)_events[item['time']]=[];
      totalUnit+=unit;
      _events[item['time']].add({'id':item['id'],'time':item['time'],'title':item['title'],'qty':unit});
    });
    fn(res){

      if(isNull(res) || res is bool){
        _removeSchd(item);
      }else if (res['data'] is Map){
//        print(res);
        if(isNull(res['data']['id']))return;
       int _eventIdx = _events[item['time']].indexWhere((e)=>e['id']==item['id']);
       if(_eventIdx>-1){
         setState(() {
           _events[item['time']][_eventIdx]['cartId']=res['data']['id'];
         });
       }
      }else{
        print(res);
      }
    }
    addToCart({
      'plantTimeId':'${item['id']}',
      'quantity':'$unit',
      'productId':'${_schedule['product']['id']}',
      'schedule':'${item['time']}',
      'type':'${_schedule['post']['type']}'
    }).then(fn);
  }
  @override
  Widget build(BuildContext context) {
   CalendarStyle _calendarStyle = CalendarStyle(
      selectedColor: primaryColor,
      todayColor: primarySwatch,
      markersColor: secondaryColor,
      outsideDaysVisible: false
    );
    HeaderStyle _headerStyle= HeaderStyle(
      formatButtonTextStyle: TextStyle().copyWith(color: primaryTextColor,fontSize: 15.0),
      formatButtonDecoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
   Widget _addPTime=Container(
      child: Column(
        children: <Widget>[
          Text("Quantity",style: TextStyle(color:noteColor),),
          Row(
            children: <Widget>[
              Card(
                 margin: EdgeInsets.only(right: 20.0),
                 shape:RoundedRectangleBorder(
                     borderRadius: BorderRadius.vertical(
                         top: Radius.elliptical(12.0,12.0),
                         bottom: Radius.elliptical(12.0,12.0)
                     ),
                     side: BorderSide(color: noteColor,)
                 ),
                 child:ButtonBar(
                   buttonPadding: EdgeInsets.only(top:2.0,right: 0,left: 0),
                   alignment: MainAxisAlignment.center,
                   children: <Widget>[
                     IconButton(
                       padding: EdgeInsets.all(0.0),
                       iconSize: 15,
                       icon: Icon(Icons.remove_circle_outline),
                       tooltip: 'Decrease volume by 1',
                       onPressed: decreament,
                     ),
                     InkWell(
                       onTap: _unitInput,
                       child: Text('$unit'),
                     ),
                     IconButton(
                       padding: EdgeInsets.all(0.0),
                       iconSize: 15,
                       icon: Icon(Icons.add_circle_outline),
                       tooltip: 'Increament volume by 1',
                       onPressed: increament,
                     ),
                   ]
                 )
              ),
              Text('$totalUnit')
            ]
          )
        ],
      ),
   );
   Widget _done = InkWell(
     onTap: (){
       if('$totalUnit'==_schedule['post']['quantity']){
         setState(() {
           _continue=true;
         });
       }else{
         showDialog(context: context,child: SmartAlert(title: 'Alert',description: 'Schedule can\'t be made done until Quantity needed is equal to quantity scheduled.'));
       }
     },
     child: Text('done',style:TextStyle(color: primaryColor)),
   );
   Widget _saveButton=Container(
       color: Colors.transparent,
       padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
       child: MaterialButton(
               color: primaryColor,
               onPressed: (){
                 if(_continue){
                   fn(res){
                     if(res is Map && res['error']==false)
                      Navigator.of(context).popAndPushNamed('/cart');
                     else
                       showDialog(context: context,child: SmartAlert(title: 'Alert',description: "Can't add to cart.",));
                   }
                   fetchCart(id:'done-product-${_schedule['product']['id']}').then(fn);
                 }else{
                   showDialog(context: context,child: SmartAlert(title: 'Alert',description: "Scheduled not marked as done.",));
                 }
               },
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.vertical(
                       top: Radius.elliptical(15.0,15.0),
                       bottom: Radius.elliptical(15.0,15.0)
                   ),
                   side: BorderSide(color: primarySwatch,)
               ),
               padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 45.0),
               child: Text('Add to Cart',style: TextStyle(color: primaryTextColor),),
             )
   );
   Widget _buildHead = Padding(
     padding: EdgeInsets.all(5),
     child:Container(
       decoration: BoxDecoration(
         borderRadius:  BorderRadius.circular(10),
       ),
       child: Card(
         elevation: 5,
         shape: RoundedRectangleBorder(
           borderRadius:  BorderRadius.circular(10),
         ),
         child:Padding(
           padding: EdgeInsets.all(10),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Row(
                 children: <Widget>[
                   SizedBox(width: 4,),
                   Expanded(
                       child: Text('Quantity needed',style: TextStyle(fontWeight: FontWeight.w600),)
                   )
                 ],
               ),
               Row(
                 children: <Widget>[
                   SizedBox(width: 20,),
                   Expanded(
                     child: Text('${int.tryParse(_schedule['post']['quantity'])}  ${isNull(_schedule['product']['unit'],replace: 'unit')}',style: TextStyle(color: noteColor))
                   ),
                   InkWell(
                     onTap: _totalUnitInput,
                     child: Text('Change',style: TextStyle(color: primaryColor),),
                   )
                 ],
               ),
               const SizedBox(height: 12.0),
               Row(
                 children: <Widget>[
                     Icon(Icons.location_on,color: noteColor,),
                     SizedBox(width: 4,),
                     Expanded(
                       child: Text('Delivery address',style: TextStyle(fontWeight: FontWeight.w600),)
                   )
                 ],
               ),
               Row(
                 children: <Widget>[
                   SizedBox(width: 20,),
                   Expanded(
                       child: Text(_schedule['post']['type']=='pickup'?'Pickup at yard':_schedule['post']['shippingAddress'],style: TextStyle(color: noteColor),)
                   )
                 ],
               ),
             ],
           ),
         ),
       )
     ),
   );
   Widget _calendar = Padding(
     padding: EdgeInsets.all(5),
     child:Container(
         decoration: BoxDecoration(
           borderRadius:  BorderRadius.circular(10),
         ),
         child: Card(
           elevation: 5,
           shape: RoundedRectangleBorder(
             borderRadius:  BorderRadius.circular(10),
           ),
           child:Padding(
             padding: EdgeInsets.all(10),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Row(
                   children: <Widget>[
                     SizedBox(width: 20,),
                     Expanded(
                         child: Text('Select Date',style: TextStyle(color: noteColor),)
                     )
                   ],
                 ),
                 const SizedBox(height: 12.0),
                 TableCalendar(
                   events: _events,
                   headerStyle: _headerStyle,
                   calendarStyle: _calendarStyle,
                   onDaySelected: _onDaySelected,
                   onVisibleDaysChanged: _onVisibleDaysChanged,
                   calendarController: _calendarController,
                 ),

                 Row(
                   children: <Widget>[
                     SizedBox(width: 20,),
                     Text('Select Production time slot'),
                     SizedBox(width: 20,),
                     Icon(Icons.arrow_drop_down)

                   ],
                 ),
                 (_loadingScheduleIndicator?
                   Center(child:CircularProgressIndicator()):
                     _message==null?_buildEventList():
                     Center(child: Text('Warning\n $_message',textAlign: TextAlign.center,),)),
                 _addPTime,
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: <Widget>[
                     _done
                   ],
                 )
               ],
             ),
           ),
         )
     ),
   );
   Widget _schList(){
     List items=[];
     _events.forEach((k,v){
      v.forEach((item){
        items.add(item);
      });
     });
     Widget f(item){
       DateTime _time =item['time'];
       String time='${_time.day}';
       if(_time.day==3){
         time+="rd";
       }
       else if(_time.day==2){
         time+="nd";
       }
       else if(_time.day==1){
         time+="st";
       }else{
         time+="th";
       }
       time+=' '+short_month[_time.month];
       time+=', ${_time.year}';
       return Container(
         child: Row(
           children: <Widget>[
             Expanded(
               child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('${_schedule['product']['name']}, ${item['qty']} ${isNull(_schedule['product']['unit'],replace: 'unit')} $time (${item['title']})'),
                )
               )
             ),
             IconButton(
               onPressed: ()=>_removeSchd(item),
               iconSize: 15,
               icon: Icon(Icons.clear,size: 15,),
             ),
           ],
         )
       );
     }
     return Column(
      children: items.map(f).toList(),
     );
   }
   Widget _buildSchdList = Padding(
     padding: EdgeInsets.all(5),
     child:Container(
         decoration: BoxDecoration(
           borderRadius:  BorderRadius.circular(10),
         ),
         child:Padding(
           padding: EdgeInsets.all(10),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: <Widget>[
               Text('Schedule list',textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
               const SizedBox(height: 12.0),
               _schList()
             ],
           ),
         ),
     ),
   );
   return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Schedule Delivery", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:ListView(
          children: <Widget>[
            _buildHead,
            _calendar,
            const SizedBox(height: 8.0,),
           _buildSchdList,
            _saveButton
          ],
        ),
      )
    );
  }
}
