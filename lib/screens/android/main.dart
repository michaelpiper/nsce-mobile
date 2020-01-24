import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import screen here
import 'home.dart';
import 'splash.dart';
import 'auth.dart';
import 'settings.dart';
import 'addfund.dart';
// import services here
import '../../services/auth.dart';

buildAndroid(context){
  return MaterialApp(
    title: 'Nsce',
    theme: ThemeData(
      // This is the theme of your application.
      primarySwatch: Colors.orange,
//      primaryColor: Colors.white,
    ),
    home: FutureBuilder(
      future: Provider.of<AuthService>(context).getUser(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          return snapshot.hasData? HomePage():AuthPage();
        }else{
          return SplashPage();
        }
      },
    ),
    routes: <String, WidgetBuilder> {
      '/home': (BuildContext context) => HomePage(),
      '/auth' : (BuildContext context) => AuthPage(),
      '/splash' : (BuildContext context) => SplashPage(),
      '/settings':(BuildContext context) => SettingsPage(),
      '/addfunds':(BuildContext context) => AddFundsPage()
    },
  );
}