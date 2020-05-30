import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/utils/month.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/services/driver_request.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/ext/dialogman.dart';
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
  final DialogMan dialogMan = DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.index = widget.index;
    _dispatch = storage.getItem(STORAGE_DRIVER_DISPATCH_KEY);
  }

  _fillHead(e){
    DateTime _datee = DateTime.parse(e['dateScheduled']??'');
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
              Text(isNull(e['OrderDetail']['Order']['contactPerson'],replace: 'Not provided'),style: TextStyle(color: noteColor),),
              Text('Address',style: TextStyle(color: secondaryTextColor),),
              SizedBox(height: 7,),
              Text(isNull(e['OrderDetail']['Order']['shippingAddress'],replace: 'Not provided'),style: TextStyle(color: noteColor),),
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
                  Text(e['Vehicle']==null?'Vehicle not assigned':isNull(e['Vehicle']['uniqueIdentifier'],replace:'Not available'),style: TextStyle(color:  noteColor),),
                  SizedBox(width: 7,),
                  Text("${_datee.day}-${short_month[_datee.month]}-${_datee.year} ${e['timeScheduled']}",style: TextStyle(color:  noteColor),),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
  _fillButton(){
    switch(_dispatch['status']){
      case 'Completed':
        return Center(
          child: Container(
            child: Text('Dispatch completed'),
          ),
        );
      case 'On-Transit':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: MaterialButton(
                    onPressed: (){
                      dialogMan.show();
                      fn(res){
                        dialogMan.hide();
                        setState((){
                          _dispatch['status']='Failed';
                        });
                        storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch).then((v){

                        });
                      }
                      updateDispatch(_dispatch['id'],{'status':'Failed'}).then(fn);
                    },
                    color: primaryColor,
                    child: Text('Failed', style: TextStyle(color: primaryTextColor),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(15.0,15.0),
                            bottom: Radius.elliptical(15.0,15.0)
                        )
                    ),
                  ),),
                  Expanded(child: MaterialButton(
                    onPressed: (){
                      dialogMan.show();
                      fn(res){
                        dialogMan.hide();
                        setState((){
                          _dispatch['status']='Cancel';
                        });
                        storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch).then((v){

                        });
                      }
                      updateDispatch(_dispatch['id'],{'status':'Cancel'}).then(fn);
                    },
                    color: primaryColor,
                    child: Text('Cancel', style: TextStyle(color: primaryTextColor),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(15.0,15.0),
                            bottom: Radius.elliptical(15.0,15.0)
                        )
                    ),
                  ),),
                ],
              ),
              MaterialButton(
                onPressed: (){
                  dialogMan.show();
                  fn(res){
                    dialogMan.hide();

                    setState(() {
                      _dispatch['status']='Completed';
                    });
                    storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch).then((v){
                    });
                  }
                  updateDispatch(_dispatch['id'],{'status':'Completed'}).then(fn);
                },
                color: primaryColor,
                child: Text('Completed', style: TextStyle(color: primaryTextColor),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0,15.0),
                        bottom: Radius.elliptical(15.0,15.0)
                    )
                ),
              ),
            ],
          )
        );
      case 'Pending':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
          child: MaterialButton(
            onPressed: (){
              dialogMan.show();
              fn(res){
                // print(res);
                dialogMan.hide();

                setState(() {
                  _dispatch['status']='On-Transit';
                });
                storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch).then((v){

                });
              }
              updateDispatch(_dispatch['id'],{'status':'On-Transit'}).then(fn);
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
      default:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 2.0),
          child: MaterialButton(
            onPressed: (){
              dialogMan.show();
              fn(res){
                // print(res);
                dialogMan.hide();
                setState(() {
                  _dispatch['status']='Completed';
                });
                storage.setItem(STORAGE_DRIVER_DISPATCH_KEY, _dispatch).then((v){
                  Navigator.of(context).setState((){});
                });
              }
              updateDispatch(_dispatch['id'],{'status':'Completed'}).then(fn);
            },
            color: primaryColor,
            child: Text('Completed', style: TextStyle(color: primaryTextColor),),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(15.0,15.0),
                    bottom: Radius.elliptical(15.0,15.0)
                )
            ),
          ),
        );
    }
  }
  _buildBody(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:<Widget>[
          _fillHead(_dispatch),
          Card(
            child: ListTile(
              title: Text('Contact Details'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_dispatch['OrderDetail']['Order']['contactPhone']??'nil'),
                  Text(_dispatch['OrderDetail']['Order']['shippingAddress']??'nil')
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Dispatch Status'),
              subtitle: Text(_dispatch['status']??'Pending'),
            ),
          ),
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
    dialogMan.buildContext(context);
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