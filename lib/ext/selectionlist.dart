import 'package:flutter/material.dart';
import '../utils/colors.dart';
class SelectionList extends StatefulWidget{
  final Function onChange;
  final List options;
  final Widget title;
  SelectionList(this.options,{this.onChange,this.title});
  @override
  SelectionListState createState() => SelectionListState(this.options,onChange: this.onChange,title: this.title);
}
class SelectionListState extends State<SelectionList>{
  String active;
  final Function onChange;
  final List options;
  final Widget title;
  SelectionListState(this.options,{this.onChange,this.title});
  void setActive(String idx){
    setState(() {
      active=idx;
    });
    onChange(active);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List listBody = options.map((e)=>
        Card(
          child: ListTile(
            onTap: (){
              setActive(e);
            },
            title: Text(e),
            trailing: Icon(Icons.trip_origin,color: (active==e?primaryColor:textColor),),
            leading: Icon(Icons.arrow_forward_ios),
          ),
        )
    ).toList();
    return  Container(
      child: Column(
        children: <Widget>[
          title,
          Column(
              children: listBody
          )
        ],
      ),
    );
  }
}