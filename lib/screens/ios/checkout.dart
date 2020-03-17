
import 'dart:async';
import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../ext/smartalert.dart';
import '../../ext/dialogman.dart';
import 'package:provider/provider.dart';
import 'package:NSCE/services/auth.dart';
// Notification screen
class CheckoutPage extends StatefulWidget {
  @override
  CheckoutPageState createState() => CheckoutPageState();
}
class CheckoutPageState extends State<CheckoutPage>{
  String warning;
  bool _loading;
  final _formKey = GlobalKey<FormState>();
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  Map<String, dynamic> _billingData;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _loading=false;
  }
  _loadCustomer()async{
    var user = await Provider.of<AuthService>(context).getUser();
    var act = checkAuth();
    act.then((res){
      if(res is Map && res.containsKey('data')){
        setState(() {
          _billingData.addAll(res['data']);
          _billingData.addAll(user);
          print(_billingData);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_billingData==null) {
      _billingData={};
      _loadCustomer();
      return Loading();
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: liteColor,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: liteColor,
    )) ;
    dialogMan.buildContext(context);
    Widget _checkout=Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                onPressed: (){
                  if(warning!='' && warning!=null){
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return  SmartAlert(title:"Warning",description:warning);
                      },
                    );
                  }
                  return Navigator.pushNamed(context, '/confirm_order');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0,15.0),
                        bottom: Radius.elliptical(15.0,15.0)
                    ),
                    side: BorderSide(color: primarySwatch,)
                ),
                padding: EdgeInsets.symmetric(vertical:12.0,horizontal: 45.0),
                child: Text('Continue',style: TextStyle(color: primaryTextColor),),
              )
            ]
        )
    );
    Widget _buildForm = Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListBody(
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        initialValue:_billingData['firstName'] ,
                        onSaved: (value)=> _billingData['firstName']  = value,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                            labelText: 'First name',
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
                        onChanged: (v) => _billingData['firstName'] = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue:_billingData['lastName'] ,
                        onSaved: (value)=> _billingData['lastName']  = value,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                            labelText: 'Last name',
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
                        onChanged: (v) => _billingData['lastName'] = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ]
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child:TextFormField(
                      initialValue:_billingData['phone'] ,
                      onSaved: (value)=> _billingData['phone']  = value,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          hintText: '9433313465',
                          hintStyle: TextStyle(
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
                      onChanged: (v) => _billingData['phone'] = v,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ) ,
                  ),

                ],
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                initialValue:_billingData['companyname'] ,
                onSaved: (value)=> _billingData['companyname']  = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                    labelText: 'Company name',
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
                onChanged: (v) => _billingData['companyname'] = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your company name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                initialValue:_billingData['address'] ,
                onSaved: (value)=> _billingData['address']  = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                    labelText: 'Address',
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
                onChanged: (v) => _billingData['address'] = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                children: <Widget>[
                  Text(''),
                  Expanded(
                    child: InkWell(
                        onTap: (){
                          final form = _formKey.currentState;
                          form.save();


                          if (form.validate()) {

                            if (_loading) {

                              return;
                            }
                            setState(() {
                              _loading = true;
                            });
                            if(_loading){
                              dialogMan.show();
                            }
                            Future.delayed(Duration(seconds: 3), () =>
                                setState(() {
                                  _loading = false;
                                  dialogMan.hide();
                                }));
                          }
                        },
                        child:Text('Change', style: TextStyle(color: primaryColor,fontSize: 16.0),textAlign: TextAlign.right,)
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
    Widget _buildBody() {
      return ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Billing Address Information',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
            ),
            _buildForm
          ]
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation:3.0 ,
        title: Text("Checkout",style: TextStyle(color: liteTextColor),),
        iconTheme: IconThemeData(color: liteTextColor),
        backgroundColor: liteColor,
      ),
      body:_buildBody(),
      bottomNavigationBar: _checkout,
    );
  }
}