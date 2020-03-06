import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../ext/selectionlist.dart';
import '../../ext/smartalert.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert' as convert;
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/ext/dialogman.dart';
// Notification screen
class ConfirmSchedulePage extends StatefulWidget {
  ConfirmSchedulePageState createState() => ConfirmSchedulePageState();
}
class ConfirmSchedulePageState extends State<ConfirmSchedulePage>{
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  String selectedMethod='';
  Map _schedule={};
  List<Map<String,dynamic>> _dispatch=[];
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _schedule=convert.jsonDecode(localStorage.getItem(STORAGE_SCHEDULE_KEY));
    if(_schedule['post']['schedule']!=null && _schedule['post']['quantity']!=null && _schedule['timePerProduct']!=null){
      _dispatch=[];
      int qty = int.tryParse(_schedule['post']['quantity']);
      num dit= _schedule['timePerProduct'];
      DateTime _time = DateTime.parse(_schedule['post']['schedule']).toLocal();
      for (var i =0; i< qty;i++){
        _dispatch.add({'title':'Dispatch '+(i+1).toString(),'time':_time.toString()});
        _time = _time.add(Duration(minutes:dit.toInt()));
      }
    }
  }
  void changeMethod(e){
    setState(() {
      selectedMethod=e;
    });
  }
  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    Widget _buildHead=Card(

      child: Row(
        children: <Widget>[
          _schedule['product']['image']==null?Container(height: 100,width: 100):Image.network(baseURL(_schedule['product']['image']),height: 100,width: 100,fit: BoxFit.fill),
          Expanded(
            child:Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Product name: '+_schedule['product']['name']),
                  Text('Qty: ${_schedule['product']['quantity'].toString()} ${_schedule['product']['measuredIn']}'),
                  Text('Total Qty: ${(_schedule['product']['quantity']*int.tryParse(_schedule['post']['quantity'])).toString()} ${_schedule['product']['measuredIn']}'),
                  Text('Price: '+CURRENCY['sign']+(_schedule['product']['price']-_schedule['product']['discount']).toString()+'/'+_schedule['product']['measuredIn']),
                  Text('Total Price '+CURRENCY['sign']+((_schedule['product']['price']-_schedule['product']['discount']) * int.tryParse(_schedule['post']['quantity'])).toString()+'/'+_schedule['product']['measuredIn'])
                ],
              ),
            )
          )
        ],
      ),
    );
    Widget _buildContent=Container(
      child:  Column(
        children:
        _dispatch.map<Widget>((dispatch)=> Card(
          child: ListTile(
            title: Text(dispatch['title']),
            subtitle: Text(dispatch['time']),
          )
        )).toList()
      ),
    );
    Widget _addTocart=Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                onPressed: (){
                  if(selectedMethod==''){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return  SmartAlert(title:"Warning",description:"Please select one of the shipping method");
                      },
                    );
                  }
                  dialogMan.show();
                  if(selectedMethod=='Pick up at Quarry'){
                    _schedule['post']['pickup']='1';
                  }else{
                    _schedule['post']['pickup']='0';
                  }
                  addToCart(_schedule['post']).then<void>((res)async{
                    dialogMan.hide();
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        String message="Time not available";
                        bool link=false;
                        if(res is bool || res == null){
                          message="Couldn't proccess request at this time please try again";
                        }
                        else if(res['error'] is bool && res['error']==true){
                          message=res['message']!=null?res['message']:'Time not available';
                        }
                        else{
                          message=res['message']!=null?res['message']:'Item added to cart';
                          link=true;
                        }
                        return SmartAlert(title:"Alert",description:message,onOk: (){ if(link) Navigator.popAndPushNamed(context, '/cart');},);
                      },
                    );
                  });
                  return null;
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0,15.0),
                        bottom: Radius.elliptical(15.0,15.0)
                    ),
                    side: BorderSide(color: primarySwatch,)
                ),
                padding: EdgeInsets.symmetric(vertical:12.0,horizontal: 45.0),
                child: Text('Add to Cart',style: TextStyle(color: primaryTextColor),),
              )
            ]
        )
    );
    Widget _shippingMethods =SelectionList(
        ['Site Delivery','Pick up at Quarry'],
      title:Text('Shipping Methods'),
      onChange: (e)=>changeMethod(e),
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Confirm Schedule",style: TextStyle(color: primaryTextColor),),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: 
        ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 10,
            ),
            _buildHead,
            _shippingMethods,
            Center(
              child: Text((_dispatch.length>0?_dispatch.length.toString():'')+' Dispach '+(selectedMethod!=''?'for '+selectedMethod:'')),
            ),
            _buildContent
          ]
        ),
      bottomNavigationBar: _addTocart,
    );
  }
}

