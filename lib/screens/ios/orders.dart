import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
// Notification screen
class OrdersPage extends StatelessWidget {
  List<Map<String,dynamic>> _orders=[
      {'name':'stone','quantity':'2000','amount':'180,000.00','measurement':'Tonnes','id':'12343232','image':'images/sample1.png','createdAt':'2012 12:00pm','status':'Processing'},
    {'name':'stone','quantity':'2000','amount':'180,000.00','measurement':'Tonnes','id':'12343232','image':'images/sample2.png','createdAt':'2012 12:00pm','status':'Awaiting Payment'}
    ];
  @override
  Widget build(BuildContext context) {
    Widget _builList(){
      Widget f(e){
        return Card(
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child:InkWell(
            onTap: (){
              Navigator.pushNamed(context,'/order/'+e['id'].toString());
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
                            Text("Order#"+e['id'],style:TextStyle(color:noteColor,fontSize: 26,fontWeight: FontWeight.w800,textBaseline: TextBaseline.alphabetic)),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(right:1.0),),
                                    SizedBox(width: 100,child: Text('Placed on: ',style:TextStyle(color:noteColor,fontSize: 20,textBaseline: TextBaseline.alphabetic)),),
                                    Padding(padding: EdgeInsets.only(right:3.0),),
                                    Expanded(child:Text(e['createdAt'],style:TextStyle(color:noteColor,fontSize: 20,textBaseline: TextBaseline.alphabetic)))
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(right:1.0),),
                                    SizedBox(width: 100,child: Text('Total',style:TextStyle(color:textColor,fontSize: 26,fontWeight: FontWeight.w900,textBaseline: TextBaseline.alphabetic)),),
                                    Padding(padding: EdgeInsets.only(right:3.0),),
                                    Expanded(child:Text(CURRENCY['sign']+' '+e['amount'],style:TextStyle(color:textColor,fontSize: 26,fontWeight: FontWeight.w900,textBaseline: TextBaseline.alphabetic)))
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
                                Icon(Icons.check_circle,size: 22,color: primaryColor),
                                Text(e['status'],style:TextStyle(color:primaryColor,fontSize: 22,textBaseline: TextBaseline.alphabetic,fontWeight: FontWeight.w600)),
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
      return ListView(
          children:_orders.map<Widget>(f).toList()
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
            ButtonBar(
              children: <Widget>[
                MaterialButton(
                  onPressed: (){
                    print('1');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  color: primaryColor,
                  child: Text('All',style: TextStyle(color: primaryTextColor),),
                ),
                FlatButton(
                  onPressed: (){
                    print('1');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  color: liteColor,
                  child: Text('Pending',style: TextStyle(color: liteTextColor),),
                ),
                FlatButton(
                  onPressed: (){
                    print('1');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  color: liteColor,
                  child: Text('Completed',style: TextStyle(color:liteTextColor),),
                )
              ],
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