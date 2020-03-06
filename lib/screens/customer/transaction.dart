import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nsce/services/auth.dart';
// third screen
class TransactionPage extends StatelessWidget {
  final int trnId;
  TransactionPage({this.trnId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction "+trnId.toString(), style:TextStyle(color:Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            if(Navigator.canPop(context))
              Navigator.pop(context);
          },
          child: Text('Go Back!'),
        ),
      ),
    );
  }
}