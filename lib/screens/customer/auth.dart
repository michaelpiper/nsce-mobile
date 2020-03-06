// Flutter code sample for

// This example shows a [Form] with one [TextFormField] and a [RaisedButton]. A
// [GlobalKey] is used here to identify the [Form] and validate input.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

// import service here
import 'package:nsce/services/auth.dart';
/// This Widget is the main application widget.
class AuthPage extends StatelessWidget {
  static const String _title = 'Welcome';
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
  Map<String, dynamic> _signupData={'usernamer':null,'password':null,'confirm_password':null};
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  _MyStatefulWidgetState(){

  }
  @override
  void initState(){
    super.initState();
  }


  Widget Login(){
    return Container(
        child:Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child:Form(
              key: _formKey,
              child:Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      // Padding(padding:,)
                      Center(
                          child: Image(
                            image: AssetImage('images/icon.png'),
                            width: 130,
                            height: 130,
                          )
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child:Text(
                          'Login to your account:',
                        ),
                      ),
                      TextFormField(
                        key: UniqueKey(),
                        onSaved: (value)=> _username = value,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Username'
                        ),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.continueAction,
                        onChanged: (v) => _username = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your username or email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        key: UniqueKey(),
                        obscureText: true,
                        onSaved: (value)=> _password = value,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
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
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: RaisedButton(
                          color: Colors.orangeAccent,
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            final form = _formKey.currentState;
                            form.save();
                            if (_formKey.currentState.validate()) {
                              var wait=Provider.of<AuthService>(context).loginUser(username: _username, password: _password);
                              wait.then((status){
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
                                  _screen=2;
                                });
                              });
                            }
                          },
                          child: Text('Login',
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
                          Expanded(child: Text("Don't Have a Account?")),
                          InkWell(
                            onTap: (){
                              setState(() {
                                // Process data.
                                _screen=2;
                              });
                            },
                            child: Text("Sign Up",
                              style: TextStyle(
                                color:  Colors.orangeAccent,
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
  Widget Signup(){
    return Container(
        child:Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child:Form(
              key: _formKey,
              child:Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      // Padding(padding:,)
                      Center(
                          child: Image(
                            image: AssetImage('images/icon.png'),
                            width: 130,
                            height: 130,
                          )
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child:Text(
                          'Sign up for a new account:',
                        ),
                      ),
                      TextFormField(
                        key: UniqueKey(),
                        onSaved: (value)=> _signupData['username'] = value,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                        ),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.continueAction,
                        onChanged: (v) => _signupData['username'] = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your username or email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        key: UniqueKey(),
                        obscureText: true,
                        onSaved: (value)=> _signupData['password'] = value,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.continueAction,
                        onChanged: (v) => _signupData['password'] = v,
                        validator: (value) {
                          if (value.isEmpty ) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        key: UniqueKey(),
                        obscureText: true,
                        onSaved: (value)=> _signupData['confirm_password'] = value,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Confirm Password',
                        ),
                        keyboardType: TextInputType.text,
                        // textInputAction: TextInputAction.continueAction,
                        onChanged: (v) => _signupData['confirm_password'] = v,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          }
                          else if (value != _signupData['password']) {
                            return 'Password not the same with confirm password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Center(
                        child: RaisedButton(
                          color:  Colors.orangeAccent,
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            final form = _formKey.currentState;
                            form.save();
                            if (_formKey.currentState.validate()) {
                              var wait=Provider.of<AuthService>(context).createUser(_signupData);
                              wait.then((status){
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
                          child: Text(
                            'SignUp',
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
                              setState(() {
                                // Process data.
                                _screen=1;
                              });
                            },
                            child: Text("Sign In",
                              style: TextStyle(
                                color:  Colors.orangeAccent,
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
    switch (_screen){
      case 2: {
        return Signup();
      }
      break;
      default: {
        return Login();
      }
      break;
    }

  }
}