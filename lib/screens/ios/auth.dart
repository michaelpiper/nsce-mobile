// Flutter code sample for

// This example shows a [Form] with one [TextFormField] and a [RaisedButton]. A
// [GlobalKey] is used here to identify the [Form] and validate input.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// import service here
import '../../services/auth.dart';
// import color
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/country.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _forgetDetails;
  String _password;
  int _screen=1;
  bool _loading=false;
  bool _eye_signup=true;
  bool _eye_signin=true;
  List <Widget> _countryList=[];
  Map<String, dynamic> _signUpData={'fullname':null,'country':null,'company':null,'email':null,'phone':null,'password':null,'confirm_password':null};
   _MyStatefulWidgetState(){
     f(e){
       return DropdownMenuItem(
         child: Text(e['name'],style:TextStyle(color: textColor),),
         value: e['name'],
       );
     }
     _countryList=simpleCountryCode.map(f).toList();
   }
  @override
  void initState(){
    super.initState();
  }

  Widget login(){
    double margin=0.0;
    var size=MediaQuery.of(context).size;

    if(size.height>630){
      margin=(size.height-(size.height-10))/2;
    }
    else if(size.height>610){
      margin=(size.height-610)/2;
    }
    else if(size.height>510){
      margin=(size.height-(size.height-10))/2;
    }
    else if(size.height>410){
      margin=(size.height-400)/2;
    }
    else if(size.height>310){
      margin=(size.height-300)/2;
    }else{
      margin=1;
    }

    Widget _body = Container(
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
            margin: EdgeInsets.only(top:0.0,left: 22.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(20.0,20.0),
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
                      // Padding(padding:,)
                      Text(
                        'Login',
                        style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 20),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(

                        initialValue:_username ,
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
                      SizedBox(
                        height: 25.0,
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
                            child: Text("Forget Password",
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
    return
      ListView(
        shrinkWrap: false,
        children: <Widget>[
          Container(
            color: primaryTextColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  image: AssetImage('images/auth-header.png'),
                  fit: BoxFit.fill,
                  width: 1000.0,
                  height: 90,
                ),
                SizedBox(
                  height: margin,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 420,
                  child: Stack(

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
                          child:  Center(
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
                SizedBox(
                  height: margin,
                ),
                Image(
                  image: AssetImage('images/auth-footer.png'),
                  fit: BoxFit.fill,
                  width: 1000.0,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      );
  }
  Widget signUp(){
    Widget _body =  Container(
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
          margin: EdgeInsets.only(top:0.0,left: 22.0),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(20.0,20.0),
              ),
              side: BorderSide(color: Colors.black12)),
          child: Form(
              key: _formKey,
              child:Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Padding(padding:,)
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Create Account',
                          style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 20),

                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(

                          initialValue: _signUpData['fullname'] ,
                          onSaved: (value)=> _signUpData['fullname'] = value,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person,color: secondaryTextColor),
                            labelText: 'Fullname',
                            labelStyle: TextStyle(
                              color: secondaryTextColor,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          // textInputAction: TextInputAction.continueAction,
                          onChanged: (v) => _signUpData['fullname'] = v,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your fullname';
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
                              value: _signUpData['country'],
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
                            Expanded(child:
                            Text("By clicking on Create you agree on",style: TextStyle(
                              color:  secondaryTextColor,
                            ),)
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
                            Expanded(child: Text("Have an Account?")),
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
    return ListView(
      shrinkWrap: false,
      children: <Widget>[
        Container(
          color: primaryTextColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image(
                image: AssetImage('images/auth-header.png'),
                fit: BoxFit.fill,
                width: 1000.0,
                height: 90,
              ),
              SizedBox(
                height:10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 710,
                child: Stack(

                  children: <Widget>[

                    Positioned(
                      top: 40,
                      width: MediaQuery.of(context).size.width,
                      child: _body,
                    ),
                    Positioned(
                      top:0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment(0,0),
                        child:  Center(
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
              SizedBox(
                height: 10,
              ),
              Image(
                image: AssetImage('images/auth-footer.png'),
                fit: BoxFit.fill,
                width: 1000.0,
                height: 100,
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget forgetPassword(){
    double margin=0.0;
    var size=MediaQuery.of(context).size;

    if(size.height>630){
      margin=(size.height-(size.height-10))/2;
    }
    else if(size.height>610){
      margin=(size.height-610)/2;
    }
    else if(size.height>510){
      margin=(size.height-(size.height-10))/2;
    }
    else if(size.height>410){
      margin=(size.height-400)/2;
    }
    else if(size.height>310){
      margin=(size.height-300)/2;
    }else{
      margin=1;
    }

    Widget _body = Container(
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
            margin: EdgeInsets.only(top:0.0,left: 22.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(20.0,20.0),
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
                      // Padding(padding:,)
                      Text(
                        'Forget Password',
                        style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 17),
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
                        height: 25.0,
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
    return
      ListView(
        shrinkWrap: false,
        children: <Widget>[
          Container(
            color: primaryTextColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  image: AssetImage('images/auth-header.png'),
                  fit: BoxFit.fill,
                  width: 1000.0,
                  height: 90,
                ),
                SizedBox(
                  height: margin,
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(

                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 400,
                      ),
                      Positioned(
                        top: 40,
                        width: MediaQuery.of(context).size.width,
                        child: _body,
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment(0,0),
                          child:  Center(
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
                SizedBox(
                  height: margin,
                ),
                Image(
                  image: AssetImage('images/auth-footer.png'),
                  fit: BoxFit.fill,
                  width: 1000.0,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      );
  }
  @override
  Widget build(BuildContext context) {
    Widget buildBody() {
      switch (_screen) {
        case 3:
          {
            return forgetPassword();
          }
          break;
        case 2:
          {
            return signUp();
          }
          break;
        default:
          {
            return login();
          }
          break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:buildBody() ,
        color: primaryColor,
      )
    );
  }
}