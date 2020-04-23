import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/request.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
// Notification screen
class ConfirmOrderPage extends StatelessWidget {
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  List _cart;
  Map _userDetails={};
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final DialogMan dialogMan = DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  ConfirmOrderPage(){
    _cart=localStorage.getItem(STORAGE_CART_KEY);
    _userDetails=localStorage.getItem(STORAGE_USER_DETAILS_KEY);
  }
  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    Widget _confrimOrder=Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                onPressed: (){
                  dialogMan.show();
                  f(res){
                    dialogMan.hide();
                    if(res is bool || res['error']==true){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                        return  SmartAlert(title:"Warning",description:"Please retry");
                        },
                      );
                    }else {

                      localStorage.setItem(STORAGE_CART_CHECKOUT_KEY, res['data']).then((value){
                        return Navigator.popAndPushNamed(context, '/save_and_pay');
                      });

                    }
                  }
                  fetchCart(id:'checkout').then(f);

                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0,15.0),
                        bottom: Radius.elliptical(15.0,15.0)
                    ),
                    side: BorderSide(color: primarySwatch,)
                ),
                padding: EdgeInsets.symmetric(vertical:12.0,horizontal: 45.0),
                child: Text('Confirm Order',style: TextStyle(color: primaryTextColor),),
              )
            ]
        )
    );
    Widget billingSection =  Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      Expanded(child: Text('Billing Info',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),),),
                      InkWell(onTap:(){Navigator.pushNamed(context, '/checkout');},child: Text('Edit',style:TextStyle(color:primaryColor)))
                    ]
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:1.0),),
                    SizedBox(width: 100,child: Text('Name',style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),),
                    Padding(padding: EdgeInsets.only(right:3.0),),
                    Expanded(child:Text('Phone number',style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:1.0),),
                    SizedBox(width: 100,child: Text(_userDetails['firstName']+' '+_userDetails['lastName'],style:TextStyle(color:textColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),),
                    Padding(padding: EdgeInsets.only(right:3.0),),
                    Expanded(child:Text(_userDetails['phone'],style:TextStyle(color:textColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:1.0),),
                    Icon(Icons.location_on,color:Colors.blue),
                    Padding(padding: EdgeInsets.only(right:3.0),),
                    Expanded(child:Text(_userDetails['address'],style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))

                  ]
                ),
                SizedBox(
                  height: 20,
                ),
              ]
          ),
        ),
      ),
    );
    Widget shippingSection =  Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Shipping Info',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),),),
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:7.0),),
                    Icon(Icons.local_shipping,color:noteColor),
                    Padding(padding: EdgeInsets.only(right:5.0),),
                    Expanded(child:Text('Site Delivery',style:TextStyle(color:textColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:7.0),),
                    SizedBox(width: 20,),
                    Padding(padding: EdgeInsets.only(right:5.0),),
                    Expanded(child:Text('from Yard',style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                  ],
                )
              ]
          ),
        ),
      ),
    );
    List orderTitle = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Order Details',style: TextStyle(color: noteColor),),
          Text(' '),
        ],
      ),
      SizedBox(
        height: 5,
      )
    ];
    int total=0;
    int  shippingFee=0;
    updateOrder(e){
      int price=e['quantity']*(e['Product']['price']-e['Product']['discount']);
      total+=price;
      shippingFee+=e['shippingFee'];
      orderTitle.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(e['Product']['name'],style: TextStyle(color: noteColor),),
              Text(CURRENCY['sign']+' '+oCcy.format(price)),
            ],
          ),
      );
      orderTitle.add(
        SizedBox(
          height: 2,
        )
      );
    }
    orderTitle.add(
        SizedBox(
          height: 10,
        )
    );
    _cart.forEach(updateOrder);
    orderTitle.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Sub Total',style: TextStyle(color: textColor),),
            Text(CURRENCY['sign']+' '+oCcy.format(total)),
          ],
        )
    );
    if(shippingFee>0){
      orderTitle.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Shipping Fee',style: TextStyle(color: textColor),),
              Text(CURRENCY['sign']+' '+oCcy.format(shippingFee)),
            ],
          )
      );
    }
    orderTitle.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Total',style: TextStyle(color: textColor),),
            Text(CURRENCY['sign']+' '+ oCcy.format(total+shippingFee)),
          ],
        )
    );
//    .addAll(
//    _cart.map<Widget>((e)=>
//    Row(
//    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//    children: <Widget>[
//    Text(e['Product']['name'],style: TextStyle(color: noteColor),),
//    Text(CURRENCY['sign']+e['price']),
//    ]
//    )
//    ).toList(),
//    <Widget>[
//    Row(
//    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//    children: <Widget>[
//    Text('Total'),
//    Text(CURRENCY['sign']+' 18,000'),
//    ]
//    )
//    ]
//    )
    Widget ordersSection =  Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
              children: orderTitle,
          ),
        ),
      ),
    );
    Widget _buildBody(){
      return ListView(
        children: <Widget>[
          billingSection,
          shippingSection,
          ordersSection
        ]
      );
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: liteColor,
          title: Text("Order Summary",style: TextStyle(color: liteTextColor),),
          iconTheme: IconThemeData(color: liteTextColor),
        ),
        body: _buildBody(),
      bottomNavigationBar: _confrimOrder,
    );
  }
}