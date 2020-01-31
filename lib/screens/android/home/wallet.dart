import 'package:flutter/material.dart';

// Notification screen
class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: RaisedButton(
        onPressed: () {
//          Navigator.pop(context);
        },
        child: Text('logout'),
      ),
    );
  }
}