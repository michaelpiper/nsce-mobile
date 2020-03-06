
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../ext/smartalert.dart';
import '../../ext/dialogman.dart';
// Notification screen
class CheckoutPage extends StatefulWidget {
  @override
  CheckoutPageState createState() => CheckoutPageState();
}
class CheckoutPageState extends State<CheckoutPage>{
  String warning;
  bool _loading;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  String _activeScreen="Billing";
  Map<String, dynamic> _billingData={'fullname':null,'country':null,'company':null,'email':null,'phone':null,'password':null,'confirm_password':null};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading=false;

  }
  void _setScreen(s){
   setState(() {
     _activeScreen=s;
   });
  }
  @override
  Widget build(BuildContext context) {
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
                child: Text('Save and Continue',style: TextStyle(color: primaryTextColor),),
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
            TextFormField(
              initialValue:_billingData['fullname'] ,
              onSaved: (value)=> _billingData['fullname']  = value,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                labelText: 'Full name',
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
              onChanged: (v) => _billingData['fullname'] = v,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child:TextFormField(
                    initialValue:_billingData['countrycode'] ,
                    onSaved: (value)=> _billingData['countrycode']  = value,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) => _billingData['countrycode'] = v,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      hintText: '+234',
                      hintStyle: TextStyle(
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Country code';
                      }
                      return null;
                    },
                  ),
                ),
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
    Widget _buildForm2 = Form(
        key: _formKey2,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListBody(
            children: <Widget>[
              TextFormField(
                initialValue:_billingData['fullname'] ,
                onSaved: (value)=> _billingData['fullname']  = value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                    labelText: 'Full name',
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
                onChanged: (v) => _billingData['fullname'] = v,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child:TextFormField(
                      initialValue:_billingData['countrycode'] ,
                      onSaved: (value)=> _billingData['countrycode']  = value,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChanged: (v) => _billingData['countrycode'] = v,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText: '+234',
                          hintStyle: TextStyle(
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Country code';
                        }
                        return null;
                      },
                    ),
                  ),
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
                          final form = _formKey2.currentState;
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
      if(_activeScreen=='shipping') {
        return ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Shipping Address Information',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
              ),
              _buildForm2
            ]
        );
      }
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
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: AppBar(
          elevation:3.0 ,
          title: Text("Checkout",style: TextStyle(color: liteTextColor),),
          iconTheme: IconThemeData(color: liteTextColor),
          backgroundColor: liteColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                    children: <Widget>[
                      IconButton(

                        icon: Icon(Icons.check_circle,color: primaryColor,size: 50,),
                        onPressed: (){
                          _setScreen('billing');
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      SizedBox(height: 12,),
                      Text('Billing',style:TextStyle(color: liteTextColor,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                      SizedBox(height: 2,),
                    ]
                ),
                SizedBox(width: 17,),
                Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check_circle,color:_activeScreen=='shipping'?primaryColor : noteColor,size: 50,),
                      onPressed: (){
                        _setScreen('shipping');
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    SizedBox(height: 12,),
                    Text('Shipping',style:TextStyle(color: _activeScreen=='shipping'?liteTextColor:noteColor,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    SizedBox(height: 2,),
                  ]
                ),
              ],
            ),
          ),
        ),
      ) ,
      body:_buildBody(),
      bottomNavigationBar: _checkout,
    );
  }
}