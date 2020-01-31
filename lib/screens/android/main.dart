import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import screen here
import 'home.dart';
import 'splash.dart';
import 'auth.dart';
import 'settings.dart';
import 'addfund.dart';
import 'transaction.dart';
import 'product.dart';
// import services here
import '../../services/auth.dart';
// import color
import '../../utils/colors.dart';
buildAndroid(context){
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