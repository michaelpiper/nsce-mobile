import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:localstorage/localstorage.dart';
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
  Map _dispatch;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.index = widget.index;
    _dispatch = storage.getItem(STORAGE_DRIVER_DISPATCH_KEY);
  }

  _fillHead(e){
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
      child:Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Dispatch#'+e['id'].toString(),style: TextStyle(color: primaryColor),),
              SizedBox(height: 7,),
              Text('Customer name',style: TextStyle(color: secondaryTextColor),),
              SizedBox(height: 7,),
              Text(e['contactPerson'],style: TextStyle(color: noteColor),),
              Text('Address',style: TextStyle(color: secondaryTextColor),),
              SizedBox(height: 7,),
              Text(e['shippingAddress'],style: TextStyle(color: noteColor),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Vehicle',style: TextStyle(color: secondaryTextColor),),
                  SizedBox(width: 7,),
                  Text('Delivery Date',style: TextStyle(color: secondaryTextColor),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(e['vehicleId'],style: TextStyle(color:  noteColor),),
                  SizedBox(width: 7,),
                  Text(e['schedule'],style: TextStyle(color:  noteColor),),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
  _fillButton(){
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
      child: MaterialButton(
        onPressed: (){
          print(1);
        },
        color: primaryColor,
        child: Text('Start', style: TextStyle(color: primaryTextColor),),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(15.0,15.0),
                bottom: Radius.elliptical(15.0,15.0)
            )
        ),
      ),
    );
  }
  _buildBody(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:<Widget>[
          _fillHead(_dispatch),
          _fillButton()
      ]
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
            Navigator.pushNamed(context, '/driver-profile');
          },
          child: Icon(Icons.drive_eta),
        ),
      ),
      SizedBox(
        width: 25.0,
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