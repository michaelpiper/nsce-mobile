import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class SmartAlert extends StatelessWidget{
  final String title;
  final String description;
  final Function onOk;
  final Function onCancel;
  final List<Widget> actions=[];
  bool canCancel;
  bool canContinue;
  SmartAlert({this.title,this.description,this.onOk,this.onCancel,this.canCancel=false,this.canContinue=true});
  @override
  build(BuildContext context) {
    if(this.canCancel){
      actions.add( FlatButton(
        child: Text('CANCEL',style: TextStyle(color: Colors.red),),
        onPressed: () {
          if(Navigator.of(context).canPop())Navigator.of(context).pop();
          if(this.onCancel!=null){
            this.onCancel();
          }
        },
      ));
    }
    if(this.canContinue){
      actions.add( FlatButton(
        child: Text('OK'),
        onPressed: () {
          if(Navigator.of(context).canPop())Navigator.of(context).pop();
          if(this.onOk!=null){
            this.onOk();
          }
        },
      ));
    }
    // TODO: implement build
    if(Platform.isIOS){
      return CupertinoAlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(description),
            ],
          ),
        ),
        actions: actions,
      );
    }
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(description),
          ],
        ),
      ),
      actions: actions,
    );
  }
}