import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main.dart';
// import services here
import 'services/auth.dart';
void main() => runApp(
    ChangeNotifierProvider<AuthService>(
      child: MyApp(),
      create: (BuildContext context){

        return AuthService();
      }
    )
  );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //

  @override
  Widget build(BuildContext context) {


    return screen(context);
  }
}