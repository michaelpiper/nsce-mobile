import 'package:flutter/material.dart';

class DialogMan{
  Widget child;
  BuildContext context;
  bool barrierDismissible = false;
  bool isShowing = false;
  DialogMan({this.child,this.context});

  void show() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible, // user must tap button!
      builder: (BuildContext context) {
        isShowing = true;
        return child;
      },
    );

  }
  void hide(){
    if(isShowing) Navigator.of(context).pop();
  }
  void autoDismiss(bool v){
    barrierDismissible=v;
  }
}