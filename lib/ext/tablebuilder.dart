import 'package:flutter/material.dart';
class TableBuilder extends StatelessWidget{
  final int column;
  final List data;
  final List<List<Widget>> built=[];
  TableBuilder(this.data,{this.column: 5});
  List _rowBuilder(){
    var count=0;
    var row =0;
    for(var i=0;i<data.length;i++){
      if(count == column){
        row++;
        count=0;
      }
      if(built.length!=row+1){
        built.add([]);
      }
      built[row].add(data[i]);
      count++;
    }
    return built.map<Widget>((body)=> Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: body,
    )).toList();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:_rowBuilder()
    );
  }
}