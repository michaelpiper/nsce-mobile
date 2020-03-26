import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/ext/spinner.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:localstorage/localstorage.dart';
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
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  _buildDispatch(){
    f(e){
      return InkWell(
        onTap: (){
          storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, e).then((val){
            Navigator.pushNamed(context, '/driver-dispatch/'+e['id'].toString());
          });
        },
        child: Padding(
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
        ),
      );
    }
    return _dispatchList.map<Widget>(f).toList();
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
          child: Icon(Icons.drive_eta),
        ),
      ),
      SizedBox(
        width: 25.0,
      ),
    ];
  }
  void _loadDispatch(){
    _dispatchList=[];
    for(var i=0; i<10;i++){
      _dispatchList.add({"id":77777+i,"shippingAddress":"MadilasHouse Marina lagos","contactPerson":"Chidima gold","schedule":"23-01-2019 09:30 pm",'vehicleId':"DFSEQ12"});
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