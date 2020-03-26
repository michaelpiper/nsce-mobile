import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';
// Notification screen
class OrderPage extends StatefulWidget {
  final int index;
  OrderPage({this.index});
  @override
  _OrderPageState createState()=>_OrderPageState(index:this.index);
}

class _OrderPageState extends State<OrderPage>{
  final int index;
  int currentStep;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map<String,dynamic> _order= {'name':'stone','quantity':'2000','amount':'180,000.00','measurement':'Tonnes','id':'12343232','image':'images/sample2.png','createdAt':'2012 12:00pm','shippingMethod':'Pick up at Quarry'};
  DateTime _date;
  _OrderPageState({this.index});
  goTo(step){
    setState(() {
      currentStep=step;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStep=2;
    _order = storage.getItem(STORAGE_ORDER_KEY);
    _date = DateTime.parse(_order['createdAt']).toLocal();
    print(_order);
  }
  @override
  Widget build(BuildContext context) {
    Widget description(){
      return InkWell(
        onTap: (){
          Navigator.pushNamed(context,'/order/'+index.toString());
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal:5.0 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("OrderID: "+index.toString(),style:TextStyle(color:primaryTextColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('trnRef',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic)),
                      Text('Quantity',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child:Text(_order['trnRef'],overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),),
                      Text(_order['quantity'].toString()+' ',style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700))
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
                      Text('Shipping method',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic)),
                      Text(_order['pickup']==1?"Pick up at Quarry":"Site Delivery",style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Status',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic)),
                      Text(_order['status'],style:TextStyle(color:primaryTextColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                    ],
                  )
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total    ....',style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                  Expanded(child: Text(CURRENCY['sign']+''+ oCcy.format(_order['totalPrice']+_order['shippingFee']),style:TextStyle(color:primaryTextColor,fontSize: 18,fontWeight: FontWeight.w700),textAlign: TextAlign.right,),)
                ],
              ),
            ],
          ),
        ),
      );
    }
    Widget head(){
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0)
        ),
        color: primaryColor,
        child: Container(
          height: 300.0,
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 7.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Created at',style:TextStyle(color: primaryTextColor,fontSize: 20.0),textAlign: TextAlign.left,),
                  Text(("${_date.day}-${_date.month}-${_date.year} ${_date.hour>12?_date.hour-12:_date.hour}:${_date.minute} "+(_date.hour>12?'p':'a')+"m"),style:TextStyle(color: primaryTextColor,fontSize: 20.0),textAlign: TextAlign.left,),
                ],
              ),
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
        child:Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: Dispatch(index),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Order # "+index.toString(),style: TextStyle(color: primaryTextColor),),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: Column(
        children:<Widget> [
          head(),
          SizedBox(height: 10,),
          Text("Dispatch list",style: TextStyle(color:noteColor, fontSize: 19,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
          SizedBox(height: 10,),
          status(),
        ]
      )
    );
  }
}

class Dispatch extends StatefulWidget{
  int orderId;
  Dispatch(this.orderId);
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
  }
  void _loadDispatch(){
    void f(res){
      _loading(false);
      if(res is Map && res['data'] is List){
        setState(() {
          _dispatches = res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
        });
      }
    }
    _loading(true);
    fetchOrderDispatch(id:'orderId=${widget.orderId}').then(f);
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
      _loadDispatch();
      return Center(child: CircularProgressIndicator(),);
    }
    f(Map dispatch){
      DateTime _datee = DateTime.parse(dispatch['dateScheduled']).toLocal();
      return Card(
        child: ListTile(
          title: Text('Qty: '+dispatch['quantity'].toString()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('scheduled',style:TextStyle(color: textColor,fontSize: 12.0)),
              Text(("${_datee.day}-${_datee.month}-${_datee.year} ( ${_datee.hour>12?_datee.hour-12:_datee.hour}:${_datee.minute} "+(_datee.hour>12?'p':'a')+"m )"),overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color: textColor,fontSize: 15.0),textAlign: TextAlign.left,),
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