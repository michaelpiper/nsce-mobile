import 'dart:io';
import 'package:flutter/material.dart';
import 'android/main.dart';
import 'ios/main.dart';
Widget screen(context){
  if(Platform.isAndroid){
    return buildAndroid(context);
  }else if(Platform.isIOS){
    return buildIOS(context);
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