import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/colors.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
//            borderRadius:BorderRadius.vertical(
//              top:    Radius.circular(10.0),
//            ),
//            image: DecorationImage(
//              image: ExactAssetImage('images/loading.jpg'),
//              fit: BoxFit.fill,
//              colorFilter: ColorFilter.srgbToLinearGamma(),
//            )
        ),
        child:  Center(
            child: CircularProgressIndicator( backgroundColor: primaryColor ,)
        ),
      ),
    );
  }
}