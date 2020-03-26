import 'package:NSCE/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NSCE/services/request.dart';
import 'package:provider/provider.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:intl/intl.dart';
// third screen

class DriverProfilePage extends StatefulWidget {
  DriverProfilePage({Key key}) : super(key: key);
  @override
  _DriverProfilePage createState() => new _DriverProfilePage();
}

class _DriverProfilePage extends State<DriverProfilePage>  with TickerProviderStateMixin  {
  String _title='Profile';
  Map _userDetails;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onValue(v){
      setState(() {
        _userDetails=v;
        _title=_userDetails['firstName']+' '+_userDetails['lastName'];
      });
    }
    AuthService.getUserDetails().then(onValue);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _builRow(String title, String subtitle){
      return Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              title: Text(title ),
              subtitle: Text(subtitle),
            ),
          ),
        ),
      );
    }
    _buildBody(){
      return _userDetails==null?Container():ListView(
        children: <Widget>[
          _builRow('First Name', _userDetails['firstName']??''),
          _builRow('Last Name', _userDetails['lastName']??''),

          _builRow('Balance', CURRENCY['sign']+ oCcy.format(_userDetails['balance']??0)),
          _builRow('Company', _userDetails['company']??''),
          _builRow('Country', _userDetails['country']??''),
          _builRow('Address', _userDetails['address']??''),
          _builRow('Email', _userDetails['email']??''),
          _builRow('Phone', _userDetails['phone']??''),


        ],
      );
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
              Provider.of<AuthService>(context).logout();
              if(Navigator.canPop(context))
                Navigator.pop(context);
            },
            child:Icon(Icons.exit_to_app),
          ),
        ),
        SizedBox(
          width: 25.0,
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