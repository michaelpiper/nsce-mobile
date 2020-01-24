import 'package:flutter/material.dart';
// third screen
class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return 
  Center(
      child: RaisedButton(
        onPressed: () {
          if(Navigator.canPop(context))
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),

    );
  }
}