import 'package:NSCE/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/services/request.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  String _rating;
  String _comment;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map<String,dynamic> _order= {'name':'stone','quantity':'2000','amount':'180,000.00','measurement':'Tonnes','id':'12343232','image':'images/sample2.png','createdAt':'2012 12:00pm','shippingMethod':'Pick up at Yard'};
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
    // print(_order);
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
              Text("Order ID # "+index.toString(),style:TextStyle(color:primaryTextColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Placed On ',style:TextStyle(color: primaryTextColor,fontSize: 15.0),textAlign: TextAlign.left,),
                  Text(("${_date.day}-${_date.month}-${_date.year} ${_date.hour>12?_date.hour-12:_date.hour}:${_date.minute} "+(_date.hour>12?'p':'a')+"m"),style:TextStyle(color: primaryTextColor,fontSize: 15.0),textAlign: TextAlign.left,),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('trnRef',style:TextStyle(color:primaryTextColor,fontSize: 15,textBaseline: TextBaseline.alphabetic))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child:Text(_order['trnRef'],overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color:primaryTextColor,fontSize: 15,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),)
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
                      Text('Shipping method',style:TextStyle(color:primaryTextColor,fontSize: 14,textBaseline: TextBaseline.alphabetic)),
                      Text(_order['type']=='pickup'?"Pick up at Yard":"Site Delivery",style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Status',style:TextStyle(color:primaryTextColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),
                      Text(_order['status'],style:TextStyle(color:primaryTextColor,fontSize: 18,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
                    ],
                  )
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Total    ....',style:TextStyle(color:primaryTextColor,fontSize: 15,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w700)),
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
        elevation: 5,
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
              Expanded(
                child: description(),
              )
            ],
          ),
        ),
      );
    }
    Widget status(){

      switch(_order['status']){
        case 'Completed':
          return Expanded(
            child:ButtonBar(
              children: <Widget>[
                MaterialButton(
                  onPressed: (){

                  },
                  padding: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(15.0,15.0),
                          bottom: Radius.elliptical(15.0,15.0)
                      ),
                      side: BorderSide(color: primarySwatch,)
                  ),
                  child: Text('Continue Shopping',style: TextStyle(color: primaryColor)),
                ),
                MaterialButton(
                  color: primaryColor,
                  onPressed: (){
                    showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
                      f()async {
                        await likeOrders(index.toString(),
                            {'rating': _rating.toString(), 'comment': _comment.toString()})
                            .then((res) {
                          String message=res['message']!=null?res['message']:'Raview submited';
                          showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
                            completed(){
                              if(Navigator.of(context).canPop())Navigator.of(context).pop();
                            }
                            return SmartAlert(title:"Alert",description:message,onOk: completed,);
                          }
                          );
                        });
                      }
                      return AlertDialog(
                        title: Text('Rate this Order'),
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.elliptical(10.0,10.0),
                              bottom: Radius.elliptical(10.0,10.0)
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                              children: <Widget>[
                                RatingBar(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _rating=rating.toString();
                                    });
                                  },
                                ),
                                TextField(
                                    decoration: InputDecoration(
                                        labelText:'Comments'
                                    ),
                                    onChanged: (e){
                                      setState(() {
                                        _comment=e;
                                      });
                                    }
                                )
                              ]
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('CANCEL',style: TextStyle(color: Colors.red),),
                            onPressed: () {
                              if(Navigator.of(context).canPop())Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              f();
                            },
                          )
                        ],
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(15.0,15.0),
                          bottom: Radius.elliptical(15.0,15.0)
                      ),
                      side: BorderSide(color: primarySwatch,)
                  ),
                  padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 45.0),
                  child: Text('Rate Order',style: TextStyle(color: primaryTextColor),),
                )
              ],
            )
          );
        default:
          return Expanded(
            child: OrderDetails(index),
          );
      }

    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Order # $index ",style: TextStyle(color: primaryTextColor),),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:<Widget> [
          head(),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Schedule list",
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

class OrderDetails extends StatefulWidget{
  final int orderId;
  OrderDetails(this.orderId);
  @override
  _OrderDetails createState() => _OrderDetails();
}
class _OrderDetails extends State<OrderDetails>{
  bool loading;
  List <Map<String, dynamic>> _orderDetails=[];
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    _loadOrderDetails();
  }
  void _loadOrderDetails(){
    void f(res){
      _loading(false);
      print(res);
      if(res is Map && res['data'] is List){
        setState(() {
          _orderDetails = res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
        });
      }
    }
    _loading(true);
    fetchOrderDetails('${widget.orderId}').then(f);
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
    f(Map schedule){
     
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: ListTile(
          onTap: (){
            storage.setItem(STORAGE_SCHEDULE_LIST_KEY, schedule).then((_){
              Navigator.of(context).pushNamed('/schedule-list');
            });
          },
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          title: Text(' ${isNull(schedule['Product']['name'],replace: 'Product')}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Qty: ${schedule['quantity']} ${isNull(schedule['Product']['unit'],replace: 'unit')}'),
              SizedBox(height: 6,),
              Text('schedule Date',style:TextStyle(color: textColor)),
              Text(("${schedule['dateScheduled']} ( ${schedule['PlantTime']['timeSlot']} )"),overflow: TextOverflow.ellipsis,maxLines: 5,style:TextStyle(color: textColor,fontSize: 15.0,fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container(),),
                  Icon(Icons.check_circle,size: 19,color: primaryColor),
                  Text(isNull( schedule['status'],replace: 'Status'),style:TextStyle(color:primaryColor,fontSize: 19,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      );
    }
    return _orderDetails.length==0?Center(child: Text('Empty'),): ListView.builder(itemCount: _orderDetails.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return f(_orderDetails[index]);
    });
  }
}