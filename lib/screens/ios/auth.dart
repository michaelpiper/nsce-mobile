// Flutter code sample for

// This example shows a [Form] with one [TextFormField] and a [RaisedButton]. A
// [GlobalKey] is used here to identify the [Form] and validate input.
import 'package:NSCE/services/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_beautiful_popup/main.dart';
// import service here
import '../../services/auth.dart';
// import color
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/country.dart';
import 'package:NSCE/screens/ios/chat.dart';
import 'package:NSCE/ext/dialogman.dart';
/// This Widget is the main application widget.
class AuthPage extends StatelessWidget {
  // static const String _title = 'Welcome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  _MyStatefulWidgetState(){
    f(e){
      return DropdownMenuItem(
        child: Text(e['name'],style:TextStyle(color: textColor),),
        value: e['name'],
      );
    }
    _countryList=simpleCountryCode.map(f).toList();
    _text_controller.text=_username;
    tryRemember();
  }
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _forgetDetails;
  String _password;
  final String _rememberme_key = "@login-remeberme";
  int _screen=1;
  bool _loading=false;
  bool _eye_signup=true;
  bool _eye_signin=true;
  bool _rememberme=false;
  Map<String, String> _sendMailData={};
  List <Widget> _countryList=[];
  TextEditingController _text_controller = TextEditingController();
  Map<String, String> _signUpData={'firstname':'','lastname':'','fullname':'','country':null,'company':'','email':'','phone':'','password':'','confirm_password':'','remeberme':'0'};

  final DialogMan dialogMan = DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  @override
  void initState(){
    super.initState();

  }
  tryRemember()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.get(_rememberme_key);
    if(data!=null){
//      print('$data');
      setState(() {
        _username=data;
        _text_controller.text=data;
        _sendMailData['email']=data;
      });
    }
  }
  updateRememberMe(value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_rememberme_key, value).then((val){
//      print('$val');
    });
  }
  Widget login(){
    double margin=0.0;
    var size=MediaQuery.of(context).size;
    if(size.height>630){
      margin=500;
    }
    else if(size.height>610){
      margin=500;
    }
    else if(size.height>510){
      margin=450;
    }
    else if(size.height>410){
      margin=400;
    }
    else if(size.height>340){
      margin=320;
    }else{
      margin=300;
    }
    return  Container(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(224, 224, 224 , 1),
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 2.0, // extend the shadow
              offset: Offset(
                12.0, // Move to right 10 horizontally
                1.0,   //Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child:Card(
            elevation: 4.0,
            margin: EdgeInsets.only(top:0.0,left: 20.0,right: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(20.0,20.0),
                  right: Radius.elliptical(20.0,20.0)
                ),
                side: BorderSide(color: Colors.black12)),
            child:Form(
              key: _formKey,
              child:Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(padding:EdgeInsets.only(top: 20),),
                      Text(
                        'Login',
                        style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 20),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: _text_controller,
                        onSaved: (value)=> _username = value,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color:  secondaryTextColor,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onChanged: (v) => _username = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your username or email';
                          }
                          return null;
                        },
                      ),
                      Stack(
                          alignment: Alignment(1.0,0.0), // right & center
                          children: <Widget>[
                            TextFormField(

                              obscureText: _eye_signin,
                              initialValue: _password,
                              onSaved: (value)=> _password = value,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock,color: secondaryTextColor),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: secondaryTextColor,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onChanged: (v) => _password = v,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            Positioned(
                                child:IconButton(
                                  icon: Icon(_eye_signin?Icons.visibility_off:Icons.visibility,color: secondaryTextColor),
                                  onPressed: (){
                                    setState(() {
                                      _eye_signin=!_eye_signin;
                                    });
                                  },
                                )
                            )
                          ]
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value:_rememberme,
                            onChanged: (v){
                            setState((){_rememberme=!_rememberme;});
                          },),
                          Expanded(
                            child: InkWell(

                              onTap: (){
                                if(_loading) {
                                  return;
                                }
                                setState((){_rememberme=!_rememberme;});
                              },
                              child: Text("Remember me",
                                style: TextStyle(
                                  color:  actionColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: margin-430.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text("")),
                          InkWell(

                            onTap: (){
                              if(_loading) {
                                return;
                              }
                              setState(() {
                                // Process data.
                                _screen=3;
                              });
                            },
                            child: Text("Forget Password?",
                              style: TextStyle(
                                color:  actionColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      MaterialButton(

                        color: primaryColor,
                        shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.vertical(
                                top: Radius.elliptical(10.0,10.0),
                                bottom: Radius.elliptical(10.0,10.0)
                            ),
                            side: BorderSide(color: primarySwatch)
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid
                          final form = _formKey.currentState;
                          form.save();


                          if (_formKey.currentState.validate()) {
                            if(_loading){
                              return;
                            }
                            setState(() {
                              _loading=true;
                            });
                            if(_rememberme){
                              updateRememberMe(_username);
                            }
                            var wait=Provider.of<AuthService>(context).loginUser(username: _username, password: _password);
                            wait.then((status){
                              setState(() {
                                _loading=false;
                              });

                              if(status == null){
                                return  Scaffold.of(context).showSnackBar(SnackBar(content:Text('Invalid username number')));
                              }
                              else if(status == false){
                                return  Scaffold.of(context).showSnackBar(SnackBar(content:Text("Internet error")));
                              }
                              else if(status != true){
                                return Scaffold.of(context).showSnackBar(SnackBar(content:Text(status)));
                              }
                              return null;
                            });
                          }
                        },
                        child: Text((_loading?'loading...':'Login'),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text("New on NSCE?")),
                          InkWell(
                            onTap: (){
                              if(_loading) {
                                return;
                              }
                              setState(() {
                                // Process data.
                                _screen=2;
                              });
                            },
                            child: Text("Create an Account",
                              style: TextStyle(
                                color:  actionColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
              ),
            )
        )
    );
  }
  Widget signUp(){
    dynamic _country=_signUpData['country'];
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(224, 224, 224 , 1),
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 2.0, // extend the shadow
            offset: Offset(
              12.0, // Move to right 10 horizontally
              1.0,   //Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child:Card(
          elevation: 4.0,
          margin: EdgeInsets.only(top:0.0,left: 20.0,right: 20.0),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(20.0,20.0),
                right: Radius.elliptical(20.0,20.0)
              ),
              side: BorderSide(color: Colors.black12)),
          child: Form(
              key: _formKey,
              child:Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(padding:EdgeInsets.only(top: 20),),
                        Text(
                          'Create Account',
                          style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 20),

                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: TextFormField(

                              initialValue: _signUpData['firstname'] ,
                              onSaved: (value)=> _signUpData['firstname'] = value,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                                labelText: 'Firstame',
                                labelStyle: TextStyle(
                                  color: secondaryTextColor,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              // textInputAction: TextInputAction.continueAction,
                              onChanged: (v) => _signUpData['firstname'] = v,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),),
                            SizedBox(width: 4,),
                            Expanded(
                              child: TextFormField(

                                initialValue: _signUpData['lastname'] ,
                                onSaved: (value)=> _signUpData['lastname'] = value,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                                  labelText: 'Lastname',
                                  labelStyle: TextStyle(
                                    color: secondaryTextColor,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                // textInputAction: TextInputAction.continueAction,
                                onChanged: (v) => _signUpData['lastname'] = v,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your lastname';
                                  }
                                  return null;
                                },
                              ),
                            )

                          ],
                        ),

//                        TextFormField(
//                          initialValue: _signUpData['company'] ,
//                          onSaved: (value)=> _signUpData['company'] = value,
//                          decoration: const InputDecoration(
//                            prefixIcon: Icon(Icons.person,color: secondaryTextColor,),
//                            labelText: 'Company Name',
//                            labelStyle: TextStyle(
//                              color: secondaryTextColor,
//                            ),
//                          ),
//                          keyboardType: TextInputType.text,
//                          // textInputAction: TextInputAction.continueAction,
//                          onChanged: (v) => _signUpData['company'] = v,
//                          validator: (value) {
//                            if (value.isEmpty) {
//                              return 'Please enter your company name';
//                            }
//                            return null;
//                          },
//                        ),
                        TextFormField(
                          initialValue: _signUpData['email'] ,
                          onSaved: (value)=> _signUpData['email'] = value,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email,color: secondaryTextColor),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color:  secondaryTextColor,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          // textInputAction: TextInputAction.continueAction,
                          onChanged: (v) => _signUpData['email'] = v,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        Stack(
                          alignment: Alignment(1.0,0.0), // right & center
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 50.0),
                                child:DropdownButton(
                                  icon:Padding(
                                    padding:EdgeInsets.symmetric(
                                        vertical: 21
                                    ),
                                    child:SizedBox(width:30.0,height: 30.0,),),
                                  iconSize: 30.0,
                                  value: _country,
                                  hint: Text(_signUpData['country']==null?'Country':_signUpData['country']),
                                  isExpanded: true,
                                  style: TextStyle(color: Colors.white70),
                                  onChanged: (v){
                                    for (var i=0;i<simpleCountryCode.length;i++){
                                      Map e = simpleCountryCode[i];
                                      if(e['name']==v){
                                        return setState(() {
                                          _signUpData['country'] = v;
                                          _signUpData['phone'] = e['code'];
                                        });
                                      }
                                    }

                                  },
                                  items:_countryList,
                                )
                            ),
                            Positioned(
                              left: 11,
                              height:30,
                              child:  Icon(Icons.map,color: secondaryTextColor),
                            ),
                          ],
                        ),
                        TextFormField(
                          key: UniqueKey(),
                          initialValue: _signUpData['phone'],
                          onSaved: (value)=> _signUpData['phone'] = value,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.call,color: secondaryTextColor),
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                              color:  secondaryTextColor,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          // textInputAction: TextInputAction.continueAction,
                          onChanged: (v) => _signUpData['phone'] = v,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),

                        Stack(
                            alignment: Alignment(1.0,0.0), // right & center
                            children: <Widget>[
                              TextFormField(

                                obscureText: _eye_signup,
                                initialValue:  _signUpData['password'],
                                onSaved: (value)=> _signUpData['password'] = value,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock,color: secondaryTextColor),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color:  secondaryTextColor,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                // textInputAction: TextInputAction.continueAction,
                                onChanged: (v) => _signUpData['password'] = v,
                                validator: (value) {
                                  if (value.isEmpty ) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              Positioned(
                                  child:IconButton(
                                    icon: Icon(_eye_signup?Icons.visibility_off:Icons.visibility,color: secondaryTextColor),
                                    onPressed: (){
                                      setState(() {
                                        _eye_signup=!_eye_signup;
                                      });
                                    },
                                  )
                              )
                            ]
                        ),
                        Stack(
                            alignment: Alignment(1.0,0.0), // right & center
                            children: <Widget>[
                              TextFormField(

                                obscureText: _eye_signup,
                                initialValue:_signUpData['confirm_password'],
                                onSaved: (value)=> _signUpData['confirm_password'] = value,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock,color:secondaryTextColor),
                                  labelText: 'Confirm Password',
                                  labelStyle: TextStyle(
                                    color:  secondaryTextColor,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                // textInputAction: TextInputAction.continueAction,
                                onChanged: (v) => _signUpData['confirm_password'] = v,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  else if (value != _signUpData['password']) {
                                    return 'Password not the same with confirm password';
                                  }
                                  return null;
                                },
                              ),
                              Positioned(
                                  child:IconButton(
                                    icon: Icon(_eye_signup?Icons.visibility_off:Icons.visibility,color: secondaryTextColor),
                                    onPressed: (){
                                      setState(() {
                                        _eye_signup=!_eye_signup;
                                      });
                                    },
                                  )
                              )
                            ]
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value:_signUpData['remeberme']=='1'?true:false,
                              onChanged: (v)=>setState((){
                                _signUpData['remeberme']=v?'1':'0';
                              }),
                            ),
                            Expanded(
                              child: Text("i have read & agreed to the terms and condition",style: TextStyle(
                                  color:  secondaryTextColor,
                                ),
                              )
                            ),
                            InkWell(
                              onTap: (){
                                if(_loading) {
                                  return;
                                }
                                //                                  setState(() {
                                //                                    // Process data.
                                //                                    _screen=3;
                                //                                  });
                              },
                              child: Text("Terms of Service",
                                style: TextStyle(
                                  color:  actionColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        MaterialButton(
                          color: primaryColor,
                          shape: RoundedRectangleBorder(

                              borderRadius: BorderRadius.vertical(
                                  top: Radius.elliptical(10.0,10.0),
                                  bottom: Radius.elliptical(10.0,10.0)
                              ),
                              side: BorderSide(color: primarySwatch)
                          ),
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            final form = _formKey.currentState;
                            form.save();

                            if (_formKey.currentState.validate()) {
                              if(_loading) {
                                return;
                              }
                              setState(() {
                                _loading=true;
                              });
                              _signUpData['fullname']=_signUpData['firstname']+' '+_signUpData['lastname'];
                              var wait=Provider.of<AuthService>(context).createUser(_signUpData);
                              wait.then((status){
                                setState(() {
                                  _loading=false;
                                });

                                if(status == null){
                                  return  Scaffold.of(context).showSnackBar(SnackBar(content:Text('Invalid username number')));
                                }
                                else if(status == false){
                                  return  Scaffold.of(context).showSnackBar(SnackBar(content:Text("Internet error")));
                                }
                                else if(status != true){
                                  return Scaffold.of(context).showSnackBar(SnackBar(content:Text(status)));
                                }
                                setState(() {
                                  // Process data.
                                  _screen=1;
                                });
                                return showDialog<void>(
                                  context: context,
                                  barrierDismissible: false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Welcome '+_signUpData['fullname']),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text('Your account have been created.'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              );
                            }
                          },
                          child: Text(
                            (_loading?'loading...':'Create'),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: Text("Already have an Account?")),
                            InkWell(

                              onTap: (){
                                if(_loading) {
                                  return;
                                }
                                setState(() {
                                  // Process data.
                                  _screen=1;
                                });
                              },
                              child: Text("Sign In",
                                style: TextStyle(
                                  color:  actionColor,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.0,

                        ),
                      ]
                  )
              )
          )
      ),
    );
  }
  Widget forgetPassword(){
    double margin=0.0;
    var size=MediaQuery.of(context).size;

    if(size.height>630){
      margin=500;
    }
    else if(size.height>610){
      margin=500;
    }
    else if(size.height>510){
      margin=450;
    }
    else if(size.height>410){
      margin=400;
    }
    else if(size.height>340){
      margin=320;
    }else{
      margin=300;
    }

    return Container(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(224, 224, 224 , 1),
              blurRadius: 25.0, // soften the shadow
              spreadRadius: 2.0, // extend the shadow
              offset: Offset(
                12.0, // Move to right 10 horizontally
                1.0,   //Move to bottom 10 Vertically
              ),
            )
          ],
        ),

        child:Card(
            elevation: 4.0,
            margin: EdgeInsets.only(top:0.0,left: 20.0,right: 20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(20.0,20.0),
                  right: Radius.elliptical(20.0,20.0)
                ),
                side: BorderSide(color: Colors.black12)),
            child:Form(
              key: _formKey,
              child:Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(padding:EdgeInsets.only(top: 20),),
                      Text(
                        'Forget Password',
                        style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 20),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(

                        initialValue:_forgetDetails ,
                        onSaved: (value)=> _forgetDetails = value,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                          labelText: 'Email or Phone',
                          labelStyle: TextStyle(
                            color:  secondaryTextColor,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onChanged: (v) => _forgetDetails = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your phone or email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: margin-350.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text("")),
                          InkWell(
                            onTap: (){
                              if(_loading) {
                                return;
                              }
                              setState(() {
                                // Process data.
                                _screen=1;
                              });
                            },
                            child: Text("Login",
                              style: TextStyle(
                                color:  actionColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      MaterialButton(

                        color: primaryColor,
                        shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.vertical(
                                top: Radius.elliptical(10.0,10.0),
                                bottom: Radius.elliptical(10.0,10.0)
                            ),
                            side: BorderSide(color: primarySwatch)
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid
                          final form = _formKey.currentState;
                          form.save();


                          if (_formKey.currentState.validate()) {
                            if(_loading){
                              return;
                            }
                            setState(() {
                              _loading=true;
                            });
                            var wait=Provider.of<AuthService>(context).forgetPassword(phone: _forgetDetails);
                            wait.then((status){
                              setState(() {
                                _loading=false;
                              });

                              if(status == null){
                                return showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context ){
                                    return SmartAlert(title:'Alert',description: "Invalid user details");
                                  }
                                );
                              }
                              else if(status == false){
                                return showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context ){
                                    return SmartAlert(title:'Alert',description: "Internet error");
                                  }
                                );
                              }
                              else if(status != true){
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context ){
                                    return SmartAlert(title:'Alert',description: status);
                                  }
                                );
                              }
                              return null;
                            });
                          }
                        },
                        child: Text((_loading?'loading...':'Forget Password'),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text("New on NSCE?")),
                          InkWell(
                            onTap: (){
                              if(_loading) {
                                return;
                              }
                              setState(() {
                                // Process data.
                                _screen=2;
                              });
                            },
                            child: Text("Create an Account",
                              style: TextStyle(
                                color:  actionColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
              ),
            )
        )
    );

  }
  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
    Widget buildBody(_body,{double maxHeight}) {
      return ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: 400,
              maxHeight: maxHeight==null? MediaQuery.of(context).size.height:maxHeight,
            ),
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Positioned(
                  top: 40,
                  width: MediaQuery.of(context).size.width,
                  child: _body,
                ),
                Positioned(
                  top:0,
                  child: Container(
                    alignment: Alignment(0,0),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Image(
                        image: AssetImage('images/icon.png'),
                        fit: BoxFit.fill,
                        width: 80.0,
                        height: 80.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    switchScreen() {
      switch (_screen) {
        case 3:
          {
            return buildBody(forgetPassword(),maxHeight:600);
          }
          break;
        case 2:
          {
            return buildBody(signUp());
          }
          break;
        default:
          {
            return buildBody(login(),maxHeight:600);
          }
          break;
      }
    }

    final popup = BeautifulPopup(
      context: context,
      template: TemplateAuthentication,

    );
    popup.recolor(primaryColor);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20.0),// here the desired height
        child: AppBar(
            elevation: 0,
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: primaryTextColor),
        ),
      ),
      floatingActionButton:Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: IconButton(
                icon:Icon(Icons.message),
                onPressed: (){
                  popup.show(
                    title: 'Contact us',
                    content:ListView(
                      children: <Widget>[
                        TextField(
                          onChanged: (v)=>setState((){
                            _sendMailData['fullname']=v;
                          }),
                          decoration: InputDecoration(
                              labelText: 'Full name'
                          ),
                        ),
                        TextField(
                          controller: _text_controller,
                          onChanged: (v)=>setState((){
                            _sendMailData['email']=v;
                          }),
                          decoration: InputDecoration(
                              labelText: 'Email'
                          ),
                        ),
                        TextField(
                          onChanged: (v)=>setState((){
                            _sendMailData['body']=v;
                          }),
                          onSubmitted:(v)=>setState((){
                            _sendMailData['body']=v;
                          }) ,
                          decoration: InputDecoration(
                              labelText: 'Message'
                          ),
                        )
                      ],
                    ),
                    actions: [
                      popup.button(
                        label: _loading?"Sending...":'Send',
                        onPressed: (){
                          if(_loading) {
                            return;
                          }
                          if(_sendMailData['email'] ==null || _sendMailData['fullname'] == null || _sendMailData['body']==null){
                            showDialog(context: context,child: SmartAlert(title: 'Alert',description: 'Email, full name and message can\'t be empty'));
                            return;
                          }
                          dialogMan.show();
                          sendMail({"email":"${_sendMailData['email']}","subject":"A message from ${_sendMailData['fullname']} ","body":'${_sendMailData['fullname']} your message "${_sendMailData['body']}" \n has been received and our support will respond back to you via mail.'}).then((res){
                            dialogMan.hide();
                            String msg;
                            if(res is Map && res['error']==false){
                              msg=res['message'];
                            }else if (res is Map){
                              msg=res['message']??"Message not delivered please retry";
                            }else{
                              msg="Message not delivered please retry";
                            }
                            setState(() {
                              _sendMailData['fullname'] = null;
                            });
                            if(Navigator.of(context).canPop())Navigator.of(context).pop();
                            showDialog(context: context,child: SmartAlert(title: 'Alert',description: msg));
                          }).catchError((e){
                            print(e);
                          });
                        },
                      ),
                      popup.button(
                        label: 'Chat',
                        onPressed: (){
                          if(_sendMailData['email'] == null || _sendMailData['fullname'] == null || _sendMailData['body']==null){
                            showDialog(context: context,child: SmartAlert(title: 'Alert',description: 'Email, full name and message can\'t be empty'));
                            return;
                          }
                          if(Navigator.of(context).canPop()){
                            Navigator.of(context).pop();
                          }
                          Map _name=_sendMailData['fullname'].split(' ').asMap();
                          Map _data={};
                          _data['firstName']=_name.containsKey(0)?_name[0]:'';
                          _data['lastName']=_name.containsKey(1)?_name[1]:'';
                          _data['email']=_sendMailData['email'];
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(message: _sendMailData['body'],userDetails: _data)));
                          setState(() {
                            _sendMailData['fullname'] = null;
                          });
                        },
                      ),
                    ],
                    // bool barrierDismissible = false,
                    // Widget close,
                  );
                },
              ),
            ),
            Text('Help')
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
//        constraints: BoxConstraints(minHeight:MediaQuery.of(context).size.height,maxHeight: MediaQuery.of(context).size.height ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.fill,
          ),
//          color: primaryColor,
        ),
        child:Center(child: switchScreen(),),
      )
    );
  }
}