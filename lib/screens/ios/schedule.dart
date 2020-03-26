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
  Map _eventSchedule={};
  List _selectedEvents=[];
  bool _loadingScheduleIndicator;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  _SchedulePageState();
  @override
  void initState(){
    super.initState();
    _loadingScheduleIndicator=true;
    final _selectedDay = DateTime.now();

    // print(_selectedDay.millisecond);
    _schedule=localStorage.getItem(STORAGE_SCHEDULE_KEY);
    _events={
      _selectedDay.subtract(Duration(days: 1)):[{'time':'12:00 - 12:30','title':'Event 90'}],
      _selectedDay:[{'time':'12:00 - 12:30','title':'Event 90'}],
      _selectedDay.add(Duration(days: 1)):[
        {'time':'12:00 - 12:30','title':'Event 90'},
        {'time':'13:00 - 13:30','title':'Event 12'},
        {'time':'14:00 - 14:30','title':'Event 20'},
        {'time':'15:00 - 15:30','title':'Event 34'},
        {'time':'16:00 - 16:30','title':'Event 37'}],
      _selectedDay.add(Duration(days: 2)):[
        {'time':'11:00 - 12:30','title':'Event 10'},
        {'time':'13:00 - 14:30','title':'Event 17'}],
    };
    _loadSchedule(_selectedDay);
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );
    _animationController.forward();
//    _calendarController.setSelectedDay(_selectedDay.subtract(Duration(days: 2)));
  }
  @override
  void dispose(){
    _calendarController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  void _onDaySelected(DateTime day, List events){
    debugPrint('Callback: _onDaySelected');
    DateTime now = DateTime.now();
    if(day == now){
      return;
    }
    _loadSchedule(day);
    debugPrint(events.toString());
  }
  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format){
    debugPrint('Callback: _onVisibleDaysChanged');
  }
  Widget _buildEventList(){
    return ListView(
      children: _selectedEvents.map<Widget>((event)=> Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            )
          ),
          child:ListTile(
            selected: false,
            trailing: Icon(Icons.schedule),
            title: Text(event['time'].toString()),
            subtitle: Text(event['title'].toString()),
            onTap: (){
              _schedule['post']['schedule'] = event['schedule'];
              _schedule['schedule'] = event;
              _schedule['diff'] = _eventSchedule['diff'];
              _schedule['timePerProduct'] = _eventSchedule['timePerProduct'];
              return localStorage.setItem(STORAGE_SCHEDULE_KEY, _schedule).then<void>((value){
            Navigator.popAndPushNamed(context, '/confirm_schedule');
            });
          },
          ),
        ),
      )
      ).toList(),
    );
  }
  void _loadSchedule(DateTime day){
    _scheduleLoaded(state: false);
    DateTime _now = day.toUtc();
    _schedule['post']['schedule']=_now.toIso8601String();
    scheduleOrder(_schedule['post']).then((schedules){
      if(schedules==false || schedules==null)
        return;
      if(schedules['data'] is Map) {
        Map data = schedules['data'];
        _eventSchedule=data;
        setState(() {
          _selectedEvents = data['schedule'].map<Map>((e)
          {
            DateTime start =DateTime.parse(e['start']).toLocal();
            DateTime end = DateTime.parse(e['end']).toLocal();
           return {
             'schedule': start.toString(),
             'time': (start.hour>9?start.hour.toString():'0'+start.hour.toString())+':'+(start.minute>9?start.minute.toString():'0'+start.minute.toString())+' - '+( end.hour>9?end.hour.toString():'0'+end.hour.toString())+':'+(end.minute>9?end.minute.toString():'0'+end.minute.toString()),
            'title': 'Production will take '+e['timeTaken']
           };
          }).toList();
          _scheduleLoaded();
        });
      }else{
        setState(() {
          _selectedEvents = [{'time':'Alert!','title':schedules['message']}];
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
   Widget _buildHead=Card(
     child: Row(
       children: <Widget>[
         _schedule['product']['image']==null?Container(height: 100,width: 100):Image.network(baseURL(_schedule['product']['image']),height: 100,width: 100,fit: BoxFit.fill),
         Expanded(
             child:Container(
               padding: EdgeInsets.symmetric(horizontal: 20.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   Text('Product name: '+_schedule['product']['name']),
                   Text('Qty: ${_schedule['product']['quantity'].toString()} ${_schedule['product']['unit']}'),
                   Text('Total Qty: ${oCcy.format(_schedule['product']['quantity']*int.tryParse(_schedule['post']['quantity']))} '),
                   Text('Price: '+CURRENCY['sign']+ oCcy.format(_schedule['product']['price']-_schedule['product']['discount'])),
                   Text('Total Price '+CURRENCY['sign']+ oCcy.format((_schedule['product']['price']-_schedule['product']['discount']) * int.tryParse(_schedule['post']['quantity'])))
                 ],
               ),
             )
         )
       ],
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
        child:Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildHead,
            SizedBox(
              width: 320,
              height: 305,
              child:TableCalendar(
                events: _events,
                headerStyle: _headerStyle,
                calendarStyle: _calendarStyle,
                onDaySelected: _onDaySelected,
                onVisibleDaysChanged: _onVisibleDaysChanged,
                calendarController: _calendarController,
              ),
            ),
            const SizedBox(height: 8.0,),
            Expanded(child:_loadingScheduleIndicator?Center(child:CircularProgressIndicator()):_buildEventList())
          ],
        ),
      )
    );
  }
}
