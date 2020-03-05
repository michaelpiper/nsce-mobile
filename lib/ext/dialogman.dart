import 'package:flutter/material.dart';

class DialogMan{
  Widget child;
  BuildContext context;
  bool barrierDismissible = false;
  bool isShowing = false;
  DialogMan({this.child,this.context});
  void buildContext(BuildContext context){
    this.context=context;
  }
  void show() async {
    isShowing = true;
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible, // user must tap button!
      builder: (BuildContext context) {
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