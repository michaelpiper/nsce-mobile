import 'package:flutter/material.dart';

// Notification screen
class WalletScreen extends StatelessWidget {
  Function reload;
  Map<String, dynamic> userDetails={'balance':0};
  Map<String, dynamic> currentUser={'phone':''};
  WalletScreen({this.currentUser=const {'phone':''} ,this.userDetails=const {'balance':0},this.reload});
  _addFund(context){
    return Card(
      elevation: 6.0,
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
          side: BorderSide(color: Color.fromRGBO(237, 216, 22,1))),
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
                color: Color.fromRGBO(237, 216, 22,0.6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      32.0,
                    ),
                    side: BorderSide(color: Color.fromRGBO(237, 216, 22,1))),
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
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: false,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          _addFund(context),
        ]
      )
    );
  }
}