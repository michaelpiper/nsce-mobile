import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/services/auth.dart';
import 'package:NSCE/ext/spinner.dart';
import 'package:NSCE/utils/colors.dart';
// third screen

class DriverHomePage extends StatefulWidget {
  DriverHomePage({Key key}) : super(key: key);
  @override
  _DriverHomePage createState() => new _DriverHomePage();
}

class _DriverHomePage extends State<DriverHomePage> {
  List<Map<String,dynamic>> _dispatchList=[];
  String _title='Task';
  bool _loadingDispatchIndicator=true;
  _buildDispatch(){
    f(e){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
        child:Card(
          child: Column(
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
        )
      );
    }
    return _dispatchList.map<Widget>(f);
  }
  _buildBody(){
    return Container(
      child:_dispatchList.length==0?Center(child: Text('Disptach list is empty'),): ListView(
        children: _buildDispatch(),
      ),
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
          child: SizedBox(
            width:60.0,
            height: 60.0,
            child: CircleAvatar(backgroundImage:AssetImage('images/sample1.png'),),
          ),
        ),
      ),
    ];
  }
  void _loadDispatch(){
    _dispatchList=[];
    for(var i=0; i<10;i++){
      _dispatchList.add({"id":77777,"shippingAddress":"MadilasHouse Marina lagos","contactPerson":"Chidima gold","schedule":"",'vehicleId':"DFSEQ12"});
    }
    _dispatchLoaded();
  }
  void _dispatchLoaded({bool state:true}){
    setState(() {
      _loadingDispatchIndicator=!state;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(_loadingDispatchIndicator){
      _loadDispatch();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title,style: TextStyle(color: primaryTextColor,)),
        iconTheme: IconThemeData(color:primaryTextColor),
        actions: _buildActions(),
      ),
      body: _loadingDispatchIndicator?Center(child:Spinner(icon: Icons.sync,) ,):_buildBody(),
    );
  }
}