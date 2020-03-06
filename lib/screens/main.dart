import 'dart:io';
import 'package:flutter/material.dart';
import 'customer/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import screen here
import 'package:nsce/screens/customer/home.dart';
import 'package:nsce/screens/customer/splash.dart';
import 'package:nsce/screens/customer/auth.dart';
import 'package:nsce/screens/customer/settings.dart';
import 'package:nsce/screens/customer/addfund.dart';
import 'package:nsce/screens/customer/transaction.dart';
import 'package:nsce/screens/customer/product.dart';
// import services here
import 'package:nsce/services/auth.dart';
// import color
import 'package:nsce/utils/colors.dart';
buildApp(context){
  return MaterialApp(
    title: 'Nsce',
    theme: ThemeData(
      // This is the theme of your application.
      primarySwatch: primarySwatch,
      primaryColor: primaryColor,
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
    onGenerateRoute: (settings){
      List data=settings.name.split('/');
      print(data);
      if(data[1]=='transaction' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return  TransactionPage(trnId:int.parse(data[2]));
        });
      }
      else  if(data[1]=='product' && data[2]!=null){
        return MaterialPageRoute(builder: (context){
          return ProductPage(id:int.parse(data[2]));
        });
      }
      return null;
    },
    routes: <String, WidgetBuilder> {
      '/home': (BuildContext context) => HomePage(),
      '/auth' : (BuildContext context) => AuthPage(),
      '/splash' : (BuildContext context) => SplashPage(),
      '/settings':(BuildContext context) => SettingsPage(),
      '/addfunds':(BuildContext context) => AddFundsPage(),
    },
  );
}
Widget screen(context){
  if(Platform.isAndroid || Platform.isIOS){
    return buildApp(context);
  }else{
    return  MaterialApp(
    title: 'Nsce',
    theme: ThemeData(
      // This is the theme of your application.
//      primarySwatch: Colors.orange,
      primaryColor: Colors.white,
    ),
    home: Scaffold(
      body: Center(
        child: Text('Splash screen')
      ),
    )
    );
  }
}