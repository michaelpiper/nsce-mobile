import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/utils/colors.dart';
// third screen

class DriverProfilePage extends StatefulWidget {
  DriverProfilePage({Key key}) : super(key: key);
  @override
  _DriverProfilePage createState() => new _DriverProfilePage();
}

class _DriverProfilePage extends State<DriverProfilePage> {
  String _title='Task';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _buildBody(){
      return Container();
    }
    _buildActions(){
      return <Widget>[
        SizedBox(
          height: 25.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/driver-profile');
            },
            child: SizedBox(
              width:60.0,
              height: 60.0,
              child: CircleAvatar(backgroundImage:AssetImage('images/sample1.png'),),
            ),
          ),
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title,style: TextStyle(color: primaryTextColor,)),
        iconTheme: IconThemeData(color:primaryTextColor),
        actions: _buildActions(),
      ),
      body: _buildBody(),
    );
  }

}