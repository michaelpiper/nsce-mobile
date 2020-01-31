import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
// third screen
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",style:TextStyle(color:Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
           Provider.of<AuthService>(context).logout();
           if(Navigator.canPop(context))
           Navigator.pop(context);
          },
          child: Text('Logout!'),
        ),
      ),
    );
  }
}