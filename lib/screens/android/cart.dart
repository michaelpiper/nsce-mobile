import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nsce/utils/colors.dart';
import 'package:nsce/utils/constants.dart';
class CartPage extends StatelessWidget {
  Widget checkoutButton = Container(
    color: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment:MainAxisAlignment.spaceAround,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
//        textTheme: TextTheme(display1:),
        title: Text("Cart", style:TextStyle(color:Colors.white)),
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
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
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 10.0,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Image(image: AssetImage('images/icon.png'),width: 120,fit: BoxFit.fill,),
                              SizedBox(width: 15.0,),
                              Expanded(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Chippings',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)),
                                    Text('Qty: 20 units',style: TextStyle(fontSize: 15,color: noteColor)),
                                    Text('${CURRENCY['sign']} 180,000.00',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)
                                  ],
                                ),
                              )
                            ]
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            children: <Widget>[
                              Icon(Icons.favorite_border,color:primaryColor),
                              Expanded(child:Text("Add to save items",style: TextStyle(color:primaryColor,),)),
                              InkWell(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.delete,color:secondaryTextColor),
                                   Text("Remove",style: TextStyle(color: secondaryTextColor),)
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ),
              )
            ],
          )
      ),
      bottomNavigationBar:checkoutButton,
    );
  }
}