import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../ext/smartalert.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert' as convert;
// Notification screen
class ConfirmOrderPage extends StatelessWidget {
  final String selectedMethod='';
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  List _cart;
  ConfirmOrderPage(){
    _cart=convert.jsonDecode(localStorage.getItem(STORAGE_CART_KEY));
  }
  @override
  Widget build(BuildContext context) {
    Widget _confrimOrder=Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                onPressed: (){
                  if(selectedMethod==''){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return  SmartAlert(title:"Warning",description:"Please select one of the shipping method");
                      },
                    );
                  }
                  return Navigator.pushNamed(context, '/save_and_pay');
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
                      InkWell(child: Text('Edit',style:TextStyle(color:primaryColor)))
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
                    SizedBox(width: 100,child: Text('Joy Essien',style:TextStyle(color:textColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)),),
                    Padding(padding: EdgeInsets.only(right:3.0),),
                    Expanded(child:Text('+2348178808865',style:TextStyle(color:textColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
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
                    Expanded(child:Text('Madilas House, Marina Lagos',style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))

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
                    InkWell(child: Text('Edit',style:TextStyle(color:primaryColor)))
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
                    Expanded(child:Text('20 Mn. GSB(Granule Sub Base) Wetmix Coarse Aggregates. from Quarry in Abekuta',style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
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
          Text('Chipping - 20min',style: TextStyle(color: noteColor),),
          Text(CURRENCY['sign']+' 180,000'),
        ],
      ),
      SizedBox(
        height: 5,
      )
    ];

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