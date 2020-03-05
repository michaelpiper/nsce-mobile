// Flutter code sample for

// This example shows a [Form] with one [TextFormField] and a [RaisedButton]. A
// [GlobalKey] is used here to identify the [Form] and validate input.
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// import service here
import '../../services/auth.dart';
// import color
import 'package:nsce/utils/colors.dart';
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
  String _password;
  int _screen=1;
  bool _loading=false;
  bool _eye_signup=true;
  bool _eye_signin=true;
  Map<String, dynamic> _signUpData={'fullname':null,'country':null,'company':null,'email':null,'phone':null,'password':null,'confirm_password':null};
  // _MyStatefulWidgetState(){

  // }
  @override
  void initState(){
    super.initState();
  }

 
  Widget login(){
    return
      ListView(
        shrinkWrap: true,
        children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                  image: AssetImage('images/auth-header.png'),
                  fit: BoxFit.fill,
                  width: 1000.0,
                  height: 100,
                ),

                Container(
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
                                children: <Widget>[
                                  // Padding(padding:,)
                                  Center(
                                    child: Image(
                                      alignment: Alignment(0.0,-4.0),
                                      image: AssetImage('images/icon.png'),
                                      width: 130,
                                      height: 130,
                                    )
                                  ),
                                  Text(
                                    'Login',
                                    style: TextStyle(fontFamily: "Lato",fontStyle:FontStyle.normal,fontWeight: FontWeight.normal,fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    key: UniqueKey(),
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
                                    // textInputAction: TextInputAction.continueAction,
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
                                        key: UniqueKey(),
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
                                        // textInputAction: TextInputAction.continueAction,
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
                                    height: 15.0,
                                  ),
                                  Center(

                                    child: RaisedButton(
                                      color: primaryColor,
                                      shape: RoundedRectangleBorder(

                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.elliptical(20.0,20.0),
                                              bottom: Radius.elliptical(20.0,20.0)
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
                ),
                Image(
                  image: AssetImage('images/auth-footer.png'),
                  fit: BoxFit.fill,
                  width: 1000.0,
                  height: 100,
                ),
              ],
            ),
          )
        ]
      );
  }
  Widget signUp(){
    return
      ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height+345,
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image(
                      image: AssetImage('images/auth-header.png'),
                      fit: BoxFit.fill,
                      width: 1000.0,
                      height: 100,
                    ),
                    Center(
                      child: Image(
                          image: AssetImage('images/icon.png'),
                          width: 130,
                          height: 130,
                      )
                    ),
                    Container(
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
                        child: Card(
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
                                    child: Column(
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
                                            key: UniqueKey(),
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
                                          TextFormField(
                                            key: UniqueKey(),
                                            initialValue: _signUpData['country'] ,
                                            onSaved: (value)=> _signUpData['country'] = value,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.map,color: secondaryTextColor),
                                              labelText: 'Country',
                                              labelStyle: TextStyle(
                                                color:  secondaryTextColor,
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            // textInputAction: TextInputAction.continueAction,
                                            onChanged: (v) => _signUpData['country'] = v,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter your country';
                                              }
                                              return null;
                                            },
                                          ),
                                          TextFormField(
                                            key: UniqueKey(),
                                            initialValue: _signUpData['company'] ,
                                            onSaved: (value)=> _signUpData['company'] = value,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.person,color: secondaryTextColor,),
                                              labelText: 'Company Name',
                                              labelStyle: TextStyle(
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            // textInputAction: TextInputAction.continueAction,
                                            onChanged: (v) => _signUpData['company'] = v,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter your company name';
                                              }
                                              return null;
                                            },
                                          ),
                                          TextFormField(
                                            key: UniqueKey(),
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
                                            key: UniqueKey(),
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
                                            key: UniqueKey(),
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
                                          Center(
                                            child: RaisedButton(
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(

                                                  borderRadius: BorderRadius.vertical(
                                                      top: Radius.elliptical(20.0,20.0),
                                                      bottom: Radius.elliptical(20.0,20.0)
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
                        )
                    ),
                    Image(
                      image: AssetImage('images/auth-footer.png'),
                      fit: BoxFit.fill,
                      width: 1000.0,
                      height: 100,
                    ),
                ]
            )
        )
      ]
    );
  }
  @override
  Widget build(BuildContext context) {

    switch (_screen){
      case 2: {
       return signUp();
      }
      break; 
      default: {
       return login();
      }
      break; 
    }
   
  }
}