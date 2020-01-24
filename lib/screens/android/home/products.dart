import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../services/request.dart';
import 'package:intl/intl.dart';

//final formatCurrency = new NumberFormat("#,##0.00", "en_US");


class ProductsScreen extends StatelessWidget{
  final String title="Tail Coin";
  Map<String, dynamic> currentUser={'phone':''};
  Map<String, dynamic> userDetails={'balance':0};
  int counter;
  Function incrementCounter;
  Function reload;
  ProductsScreen(this.incrementCounter,{this.currentUser=const {'phone':''} ,this.userDetails=const {'balance':0},this.counter=1,this.reload});
  void _returnState(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your purchase was succesful.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _returnError(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your purchase was unsuccesful.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _BuyItem(amount,context)async{
    buyItem({'amount':amount.toString()}).then((result){
        if(result['error']==false){
          _returnState(context);
        }
    }).catchError((e){
      print(e);
      _returnError(context);
    });

  }
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
          body:ListView(
            shrinkWrap: false,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Card(
                elevation: 8.0,
                child:  Container(
                  padding: EdgeInsets.all(15.0),
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.stretch ,
                    children: <Widget>[
                      Row (
                        children: <Widget>[
                          Expanded(child:  Text('Your Account Balance is:'),),
                          InkWell(
                            onTap: ()=>reload(),
                            child: Text("reload",
                              style: TextStyle(color:Colors.green),
                            ),

                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(userDetails['balance'].toString()+' NGN'),

                      SizedBox(
                        height: 15.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        //elevation: 5.0,
                        child: MaterialButton(
                          onPressed: ()async{
                              Navigator.pushNamed(context, '/addfunds');
                            },
                          minWidth: 150.0,
                          height: 50.0,
                          color: Colors.orange,
                          child: Text(
                            "Add Fund",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,

              ),
              Column(
                children: <Widget>[
                  Text(
                    'You phone number is: ${currentUser['phone']}',
                  ),
                  Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$counter',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ]
              ),
              Column(
                crossAxisAlignment:CrossAxisAlignment.stretch ,
                children: <Widget>[
                    Container(
                      color: Colors.white70,

                      child:Column(
                        children: <Widget>[
                          Text(
                            'This item cost 50 NGN:',
                          ),
                          RaisedButton(
                            child: Text('Buy now',style: TextStyle(color: Colors.white),),
                            color: Colors.green,
                            onPressed: () {
                              _BuyItem("50",context);
                            },
                          ),
                        ]
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      color: Colors.white70,

                      child:Column(
                          children: <Widget>[
                            Text(
                              'This item cost 250 NGN:',
                            ),
                            RaisedButton(
                              child: Text('Buy now',style: TextStyle(color: Colors.white),),
                              color: Colors.green,
                              onPressed: () {
                                _BuyItem("250",context);
                              },
                            ),
                          ]
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      color: Colors.white70,

                      child:Column(
                          children: <Widget>[
                            Text(
                              'This item cost 150 NGN:',
                            ),
                            RaisedButton(
                              child: Text('Buy now',style: TextStyle(color: Colors.white),),
                              color: Colors.green,
                              onPressed: () {
                                _BuyItem("150",context);
                              },
                            ),
                          ]
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      color: Colors.white70,

                      child:Column(
                          children: <Widget>[
                            Text(
                              'This item cost 650 NGN:',
                            ),
                            RaisedButton(
                              child: Text('Buy now',style: TextStyle(color: Colors.white),),
                              color: Colors.green,
                              onPressed: () {
                                _BuyItem("650",context);
                              },
                            ),
                          ]
                      ),
                    ),
                  ]
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          )
      );
  }
}