import 'dart:io';
import 'package:flutter/material.dart';
import 'ios/main.dart';
import 'package:NSCE/utils/colors.dart';
Widget screen(context){
  if(Platform.isAndroid || Platform.isIOS){
    return buildAndroid(context);
  }else{
    return  MaterialApp(
      title: 'NSCE',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: primarySwatch,
        primaryColor: primarySwatch,

      ),
      home: Scaffold(
        body: Center(
          child: Text('Splash screen')
        ),
      )
    );
  }
}