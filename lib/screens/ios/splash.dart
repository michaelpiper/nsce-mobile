import 'package:flutter/material.dart';
import '../../utils/colors.dart';
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: primaryColor,
//        child: Text('Splash screen')
        child: Image.asset('images/bootloader.png',fit: BoxFit.fill,),
      ),
    );
  }
}