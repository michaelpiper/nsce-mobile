import 'package:NSCE/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';
// Notification screen
class ScheduleListPage extends StatefulWidget {
  final int index;
  ScheduleListPage({this.index});
  @override
  _ScheduleListPageState createState()=>_ScheduleListPageState(index:this.index);
}

class _ScheduleListPageState extends State<ScheduleListPage>{
  final int index;

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map<String,dynamic> _schedules= {};
  Map<String,dynamic> _order= {};
  DateTime _date;
  _ScheduleListPageState({this.index});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _schedules = storage.getItem(STORAGE_SCHEDULE_LIST_KEY);
    _order = storage.getItem(STORAGE_ORDER_KEY);
    _date = DateTime.parse(_order['createdAt']).toLocal();
  }
  @override
  Widget build(BuildContext context) {
    Widget description(){
      return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal:5.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Schedule # ${_schedules['id']}",style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('item',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),
                      Text('Quantity',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child:Text('${isNull(_schedules['Product']['name'],replace: '')}',overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),),
                      Text('${_schedules['quantity']} ${isNull(_schedules['Product']['unit'],replace: 'unit')}'.toString()+' ',style:TextStyle(color:noteColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700))
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Shipping method',style:TextStyle(color:noteColor,fontSize: 14,textBaseline: TextBaseline.alphabetic)),
                        Text(_schedules['type']=='pickup'?"Pick up at Yard":"Site Delivery",style:TextStyle(color:noteColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Status',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),
                        Text(_schedules['status'],style:TextStyle(color:noteColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                      ],
                    )
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Schedule Date',style:TextStyle(color: noteColor,fontSize: 15.0),textAlign: TextAlign.left,),
                  Text(("${_schedules['dateScheduled']} ${_schedules['PlantTime']['timeSlot']}"),style:TextStyle(color: noteColor,fontSize: 15.0),textAlign: TextAlign.left,),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total    ....',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                  Expanded(child: Text(CURRENCY['sign']+''+ oCcy.format(_order['totalPrice']+_order['shippingFee']),style:TextStyle(color:noteColor,fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.right,),)
                ],
              ),
            ],
          ),
        ),
      );
    }
    Widget head(){
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        color: liteColor,
        child: Container(
          height: 300.0,
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: description(),
              )
            ],
          ),
        ),
      );
    }
    Widget status(){
          return Expanded(
            child: Dispatch(_schedules['id'],unit: _schedules['Product']['unit'],),
          );
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Order # ${_order['id']}",style: TextStyle(color: primaryTextColor),),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget> [
              SizedBox(height: 10,),
              head(),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Dispatch list",
                  style: TextStyle(color:noteColor, fontSize: 19,fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left
                ),
              ),
              SizedBox(height: 10,),
              status(),
              SizedBox(height: 10,),
            ]
        )
    );
  }
}

class Dispatch extends StatefulWidget{
  final int orderDetailId;
  final String unit;
  Dispatch(this.orderDetailId,{this.unit});
  @override
  _Dispatch createState() => _Dispatch();
}
class _Dispatch extends State<Dispatch>{
  bool loading;
  List <Map<String, dynamic>> _dispatches=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    _loadDispatch();
  }
  void _loadDispatch(){
    void f(res){
      print(res);
      _loading(false);
      if(res is Map && res['data'] is List){
        setState(() {
          _dispatches = res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
        });
      }
    }
    _loading(true);
    fetchOrderDispatch(id:'orderDetailId=${widget.orderDetailId}').then(f);
  }
  void _loading(bool state){
    setState(() {
      loading=state;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(loading){
      return Center(child: CircularProgressIndicator(),);
    }
    f(Map dispatch){
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          title: Text('Qty: ${dispatch['quantity']}  ${isNull(widget.unit,replace: 'unit')}'.toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('scheduled',style:TextStyle(color: textColor,fontSize: 12.0)),
              Text(("${dispatch['dateScheduled']} ( ${dispatch['timeScheduled']} )"),overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color: textColor,fontSize: 15.0),textAlign: TextAlign.left,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container(),),
                  Icon(Icons.check_circle,size: 19,color: primaryColor),
                  Text(isNull( dispatch['status'],replace: 'Status'),style:TextStyle(color:primaryColor,fontSize: 19,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return _dispatches.length==0?Center(child: Text('Empty'),): ListView.builder(itemCount: _dispatches.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return f(_dispatches[index]);
        });
  }
}