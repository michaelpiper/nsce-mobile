import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/utils/colors.dart';
// third screen

class DriverDispatchPage extends StatefulWidget {
  final int index;
  DriverDispatchPage({Key key,this.index:0}) : super(key: key);
  @override
  _DriverDispatchPage createState() => new _DriverDispatchPage();
}

class _DriverDispatchPage extends State<DriverDispatchPage> {
  int index;
  String _title='Task';
  _DriverDispatchPage(){
    this.index = widget.index;
  }
  _buildBody(){
    if(this.index==1){

    }
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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