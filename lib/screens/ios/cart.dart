import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:localstorage/localstorage.dart';
class CartPage extends StatefulWidget {
  @override
  CartPageState createState() =>CartPageState();
}
class CartPageState extends State<CartPage>{
  bool _loadingCartIndicator =true;
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  List <Map<String,dynamic>> _cartList=[];
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void _loadCart(){
    fetchCart().then((cart){
      if(cart==false || cart==null){
        return;
      }
      if( cart['data'] is List) {
        List _data = cart['data'];
        setState(() {
          _cartList = _data.map<Map<String,dynamic>>((e)=>e).toList();
          _cartLoaded();
        });
      }
    });
  }
  void _cartLoaded({state:true}){
    setState(() {
      _loadingCartIndicator=!state;
    });
  }
  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    if (_loadingCartIndicator) {
      _loadCart();
    }
    int _total=0;
    _cartList.forEach((e) {_total +=(e['Product']['price'] - e['Product']['discount']) * e['quantity'];});
    List _buildBody=_cartList.map<Widget>((e)=>Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(224, 224, 224 , 0.81),
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 2.0, // extend the shadow
            offset: Offset(12.0, 1.0),
          )
        ],
      ),
      child:Card(
          elevation: 4.0,
          margin: EdgeInsets.only(left: 5.0,right: 5.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(10.0,10.0),
                right: Radius.elliptical(10.0,10.0),
              ),
              side: BorderSide(color: Colors.black12)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 10.0,),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      e['Product']['image']==null?Container(width: 120,height: 120):Image(image:NetworkImage(baseURL(e['Product']['image'])),width: 120,height: 120,fit: BoxFit.fill,),
                      SizedBox(width: 15.0,),
                      Expanded(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(e['Product']['name'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                            Text('Qty: '+(e['quantity']*e['Product']['quantity']).toString()+' '+e['Product']['unit'],style: TextStyle(fontSize: 15,color: noteColor)),
                            Text('${CURRENCY['sign']} '+((e['Product']['price']-e['Product']['discount'])*e['quantity']).toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),),
                            SizedBox(height: 10.0,),
                            Row(
                                children: <Widget>[
                                  Icon(Icons.schedule,color:primaryColor),
                                  SizedBox(width: 10.0,),
                                  Expanded(child:Text( DateTime.parse(e['scheduleStart']).toLocal().toString(),style: TextStyle(color:primaryColor,),)),
                                ]
                            ),
                          ],
                        ),
                      )
                    ]
                ),

                SizedBox(height: 5.0,),
                Row(
                  children: <Widget>[
                    Container(
                      child:InkWell(
                        onTap: (){
                          dialogMan.show();
                          f(res) {
                            dialogMan.hide();
                            showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                // user must tap button!
                                builder: (BuildContext context) {
                                  if (res is bool || res == null) {
                                    return SmartAlert(title: "Error",
                                        description: "Couldn't proccess request at this time please try again");
                                  }
                                  else if (res['error'] is bool &&
                                      res['error'] == true) {
                                    String message = res['message'] != null
                                        ? res['message']
                                        : 'Item couldn\'t be added to favorite';
                                    return SmartAlert(
                                        title: "Error", description: message);
                                  } else {
                                    String message = res['message'] != null
                                        ? res['message']
                                        : 'Item removed from cart';
                                    return SmartAlert(
                                        title: "Alert", description: message);
                                  }
                                }
                            );
                          }
                          addToFavoriteItems(e['productId'].toString()).then(f);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.favorite_border,color:primaryColor),
                           Text("Add to save items",style: TextStyle(color:primaryColor,),),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child:  Container(child: InkWell(
                      onTap: (){
                        void callback(res,cartId){
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              if(res is bool || res == null){
                                return SmartAlert(title:"Error",description:"Couldn't proccess request at this time please try again");
                              }
                              else if(res['error'] is bool && res['error']==true){
                                String message=res['message']!=null?res['message']:'Item couldn\'t be remove from cart';
                                return SmartAlert(title:"Error",description:message);
                              }else{
                                String message=res['message']!=null?res['message']:'Item removed from cart';
                                return SmartAlert(title:"Alert",description:message,onOk: (){
                                  for(var i =0; i < _cartList.length;i++){
                                    if(_cartList[i]['id']==cartId){
                                      setState(() {
                                        _cartList.removeAt(i);
                                      });
                                    }
                                    break;
                                  }
                                },
                                );
                              }
                            },
                          );
                        }
                        return showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              Function f=(){
                                dialogMan.show();
                                destroyCart(e['id']).then((res){
                                  dialogMan.hide();
                                  callback(res,e['id']);
                                });
                              };
                              return SmartAlert(title:'Confirm',description:'Are you sure you want to remove item from cart',onOk:f,canCancel: true);
                            });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete,color:secondaryTextColor),
                          Text("Remove",style: TextStyle(color: secondaryTextColor),)
                        ],
                      ),
                    ),),)
                  ],
                )
              ],
            ),
          )
      ),
    )).toList();
    if(_total>0){
      _buildBody.add(Card(child:ListTile(
        title:Text('Total'),
        trailing: Text(CURRENCY['sign']+' '+_total.toString()),
      )));
      _buildBody.add(SizedBox(height: 10.0,));
    }
    Widget checkoutButton = Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceAround,
        children: <Widget>[
          MaterialButton(
            onPressed: (){
              Navigator.of(context).popUntil((route) => route.isFirst);
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
              if(_cartList.length==0){
                return;
              }
              localStorage.setItem(STORAGE_CART_KEY, _cartList).then<void>((value){
                Navigator.pushNamed(context, '/checkout');
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
            child: Text('Checkout',style: TextStyle(color: primaryTextColor),),
          )
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: liteColor,
        iconTheme: IconThemeData(color: liteTextColor),
//        textTheme: TextTheme(display1:),
        title: Text("Cart", style:TextStyle(color:liteTextColor)),
      ),
      body: Center(
        child: _loadingCartIndicator?Loading():_cartList.length==0? Center(child: Text('Empty cart'),):ListView(
          children: _buildBody,
        ),
      ),
      bottomNavigationBar:checkoutButton,
    );
  }
}