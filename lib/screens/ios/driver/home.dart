import 'package:NSCE/ext/loading.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/services/driver_request.dart';
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
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _loadingDispatchIndicator=true;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  @override
  void initState() {
    super.initState();
    _loadDispatch();
  }
  _buildDispatch(){
    f(e){
      DateTime _datee = DateTime.parse(e['dateScheduled']??'');
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
                    Text(e['Order']['contactPerson'],style: TextStyle(color: noteColor),),
                    Text('Address',style: TextStyle(color: secondaryTextColor),),
                    SizedBox(height: 7,),
                    Text(e['Order']['address'],style: TextStyle(color: noteColor),),
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
                        Text(e['Vehicle']['uniqueIdentifier'],style: TextStyle(color:  noteColor),),
                        SizedBox(width: 7,),
                        Text("${_datee.day}-${_datee.month}-${_datee.year} ${_datee.hour>12?_datee.hour-12:_datee.hour}:${_datee.minute} "+(_datee.hour>12?'p':'a')+"m",style: TextStyle(color:  noteColor),),
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
  Future<Null> _loadDispatch()async{
    refreshKey.currentState?.show(atTop: false);
    _dispatchList=[];
    fn(res){
      _dispatchLoaded();
      if(res is Map && res['data'] is List){
        setState(() {
          _dispatchList = res['data'].map<Map<String, dynamic>>((e)=>Map<String, dynamic>.from(e)).toList();
        });
      }
    }
    _dispatchLoaded(state: false);
    fetchDispatch().then(fn).catchError((e){
      // print(e);
    });
    return null;
  }
  void _dispatchLoaded({bool state:true}){
    setState(() {
      _loadingDispatchIndicator=!state;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(_title,style: TextStyle(color: primaryTextColor,)),
        iconTheme: IconThemeData(color:primaryTextColor),
        actions: _buildActions(),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child:  _loadingDispatchIndicator?Center(child:Loading()):_buildBody(),
        onRefresh: _loadDispatch,
      ),
    );
  }
}