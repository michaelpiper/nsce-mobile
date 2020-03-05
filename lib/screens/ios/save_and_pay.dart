
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
class SaveAndPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      elevation:2,
      backgroundColor: liteColor,
      title: Text("Payment",style: TextStyle(color: liteTextColor),),
      iconTheme: IconThemeData(color: liteTextColor),
      leading: IconButton(
        icon: Icon(Icons.home),
        onPressed: (){
          Navigator.popAndPushNamed(context, '/home');
        },
      ),
    ),
    body:Container(
      padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 20.0),
      child: ListView(
          children: <Widget>[
            SizedBox(
              height: 21.0,
            ),
            Text('Select Payment method'),
            SizedBox(
              height: 21.0,
            ),
            Card(
              elevation: 4.0,
              child:ListTile(
                onTap: (){
                  print('ddd');
                },
                leading: Image.asset('images/wallet.png'),
                title: Text('pay with Wallet',),
              ),
            ),
            Card(
              elevation: 4.0,
              child:ListTile(
                onTap: (){
                  print('ddd');
                },
                leading: Image.asset('images/cheque.png'),
                title: Text('pay with Cheque',),
              ),
            ),
            Card(
              elevation: 4.0,
              child:ListTile(
                onTap: (){
                  print('ddd');
                },
                leading: Image.asset('images/bank.png'),
                title: Text('pay with Bank transfer',)
              ),
            )
          ]
        ),
      )
    );
  }
}