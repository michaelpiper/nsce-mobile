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
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 6,
          ),
          ListTile(
            onTap: () async {
              Navigator.pushNamed(context, '/help-and-about');
            },
            title: Text('Help and About'),
          ),
          Padding(
              padding: EdgeInsets.only(top:5.0),
              child: Divider(thickness: 2,)
          ),
          ListTile(
            onTap: () async {
              Provider.of<AuthService>(context).logout();
              if(Navigator.canPop(context))
                Navigator.pop(context);
            },
            title: Text('Logout'),
          ),
          Padding(
              padding: EdgeInsets.only(top:5.0),
              child: Divider(thickness: 2,)
          ),
        ],
      ),
    );
  }
}