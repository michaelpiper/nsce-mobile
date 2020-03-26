import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../ext/selectionlist.dart';
import '../../ext/smartalert.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:intl/intl.dart';
// Notification screen
class ConfirmSchedulePage extends StatefulWidget {
  ConfirmSchedulePageState createState() => ConfirmSchedulePageState();
}
class ConfirmSchedulePageState extends State<ConfirmSchedulePage>{
  final LocalStorage localStorage = new LocalStorage(STORAGE_KEY);
  final _formKey = GlobalKey<FormState>();
  String selectedMethod='';
  Map _schedule={};
  List<Map<String,dynamic>> _dispatch=[];
  final oCcy = new NumberFormat("#,##0.00", "en_US");
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
    _schedule=localStorage.getItem(STORAGE_SCHEDULE_KEY);
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
    selectedMethod = _schedule['post']['pickup']=="0"?'Site Delivery':'Pick up at Quarry';
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
                  Text('Qty: ${_schedule['product']['quantity'].toString()} ${_schedule['product']['unit']}'),
                  Text('Total Qty: ${oCcy.format(_schedule['product']['quantity']*int.tryParse(_schedule['post']['quantity']))}'),
                  Text('Price: '+CURRENCY['sign']+oCcy.format(_schedule['product']['price']-_schedule['product']['discount'])),
                  Text('Total Price '+CURRENCY['sign']+oCcy.format((_schedule['product']['price']-_schedule['product']['discount']) * int.tryParse(_schedule['post']['quantity'])))
                ],
              ),
            )
          )
        ],
      ),
    );
    Widget _buildContent= Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListBody(
            children: <Widget>[
              _schedule['post']['pickup']=='1'? ListTile(title:Text('Pickup at Quarry'),subtitle: Text(_schedule['product']['Category']['Quarry']['address']),): ListTile(
                title: Text('Shipping Address'),
                subtitle:Text(_schedule['post']['address']),),
              TextFormField(
                initialValue:_schedule['post']['contactPerson'],
                onSaved: (value)=> _schedule['post']['contactPerson']  = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                    labelText: 'Contact Person',
                    labelStyle: TextStyle(
                      color:  secondaryTextColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:BorderSide(color: Colors.black12,width:2)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:BorderSide(color: Colors.grey,width:2)
                    )
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onChanged: (v) => _schedule['post']['contactPerson'] = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter contact person name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 4,
              ),
             TextFormField(
                initialValue:_schedule['post']['contactPhone'] ,
                onSaved: (value)=> _schedule['post']['contactPhone']   = value,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    hintText: '+2349433313465',
                    hintStyle: TextStyle(
                      color:  secondaryTextColor,
                    ),
                    labelText: 'Contact Phone',
                    labelStyle: TextStyle(
                      color:  secondaryTextColor,
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:BorderSide(color: Colors.black12,width:2)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide:BorderSide(color: Colors.grey,width:2)
                    )

                ),
                onChanged: (v) => _schedule['post']['contactPhone']  = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        )
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

                  final form = _formKey.currentState;
                  form.save();


                  if (form.validate()) {
                    return addToCart(_schedule['post']).then<void>((res)async{
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
                  }
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
      disabled: true,
      value:_schedule['post']['pickup']=="0"?'Site Delivery':'Pick up at Quarry',
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
              child: Text(' Contact Form '),
            ),
            _buildContent
          ]
        ),
      bottomNavigationBar: _addTocart,
    );
  }
}