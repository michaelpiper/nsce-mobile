import 'package:NSCE/services/request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
// Notification screen
class OrdersPage extends StatefulWidget {

  OrdersPageState createState() =>OrdersPageState();
}

class OrdersPageState extends State<OrdersPage>{
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  bool _loading;
  String _name="All";
  List<Map<String, dynamic>> _orders = [
  ];
  List<Map<String, dynamic>> _cacheOrder = [

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading=true;
  }
  void _loadOrder(){
    f(res){
      if(res is Map && res['data'] is List){
        // print(res['data']);
        setState(() {
          _cacheOrder=res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
          _orders = res['data'].map<Map<String,dynamic>>((e)=>new Map<String, dynamic>.from(e)).toList();
          _loading=false;
        });
      } else{
        setState((){
          _loading=false;
        });
      }
    }
    fetchOrders().then(f);
  }
  void _sort(n){
    List<Map<String, dynamic>> orders=[];

    f(order){
      if (order['status']==n){
        orders.add(order);
      }
    }
    if(n=="All"){
      orders=_cacheOrder;
    }else{
      _cacheOrder.forEach(f);
    }
    setState((){
      _name=n;
      _orders=orders;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_loading){
      _loadOrder();
    }
    Widget _builList(){
      Widget f(e){
        DateTime _date = DateTime.parse(e['createdAt']).toLocal();
        return Card(
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child:InkWell(
            onTap: (){
              storage.setItem(STORAGE_ORDER_KEY,e).then((re)=>Navigator.pushNamed(context,'/order/'+e['id'].toString()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal:15.0 ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Order#"+e['id'].toString(),style:TextStyle(color:noteColor,fontSize: 20,fontWeight: FontWeight.w800,textBaseline: TextBaseline.alphabetic)),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(right:1.0),),
                                    SizedBox(width: 100,child: Text('Placed on: ',style:TextStyle(color:noteColor,fontSize: 15,textBaseline: TextBaseline.alphabetic)),),
                                    Padding(padding: EdgeInsets.only(right:3.0),),
                                    Expanded(child:Text(("${_date.day}-${_date.month}-${_date.year} ${_date.hour>12?_date.hour-12:_date.hour}:${_date.minute} "+(_date.hour>12?'p':'a')+"m"),style:TextStyle(color:noteColor,fontSize: 20,textBaseline: TextBaseline.alphabetic)))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(right:1.0),),
                                    SizedBox(width: 100,child: Text('Total',style:TextStyle(color:textColor,fontSize: 20,fontWeight: FontWeight.w900,textBaseline: TextBaseline.alphabetic)),),
                                    Padding(padding: EdgeInsets.only(right:3.0),),
                                    Expanded(child:Text(CURRENCY['sign']+' '+ oCcy.format(e['totalPrice']+e['shippingFee']),style:TextStyle(color:textColor,fontSize: 20,fontWeight: FontWeight.w900,textBaseline: TextBaseline.alphabetic)))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(child: Container(),),
                                Icon(Icons.check_circle,size: 19,color: primaryColor),
                                Text(e['status'],style:TextStyle(color:primaryColor,fontSize: 19,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        )
                    ),
                  )
                ],
              ) ,
            )
          ),
        );
      }
      return _loading?
        Center(child:CircularProgressIndicator()):_orders.length==0?
          Center(child: Text('Empty list'),):
      ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return f(_orders[index]);
          }
      );
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("My Orders",style: TextStyle(color: liteTextColor),),
          iconTheme: IconThemeData(color: liteTextColor),
          backgroundColor: liteColor,
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.99),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color:liteColor,
              child: Center(
                child:
                  ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (){
                            _sort("All");
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          color: _name=='All'?primaryColor:liteColor,
                          child: Text('All',style: TextStyle(color: _name=='All'?primaryTextColor:liteTextColor),),
                        ),
                        FlatButton(
                          onPressed: (){
                            _sort("Pending");
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          color: _name=='Pending'?primaryColor:liteColor,
                          child: Text('Pending',style: TextStyle(color: _name=='Pending'?primaryTextColor:liteTextColor),),
                        ),
//                        FlatButton(
//                          onPressed: (){
//                            _sort("Processing");
//                          },
//                          shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.all(Radius.circular(5))
//                          ),
//                          color: _name=='Processing'?primaryColor:liteColor,
//                          child: Text('Processing',style: TextStyle(color: _name=='Processing'?primaryTextColor:liteTextColor),),
//                        ),
                        FlatButton(
                          onPressed: (){
                            _sort("Completed");
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                          color: _name=='Completed'?primaryColor:liteColor,
                          child: Text('Completed',style: TextStyle(color:_name=='Completed'?primaryTextColor:liteTextColor),),
                        )
                      ],
                    )
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal:10.0 ),
                child:_builList(),
              ),
            )
          ],
        )
    );
  }
}