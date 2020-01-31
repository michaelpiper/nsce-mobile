import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget{
  final String name;
  final String avatar;
  final String link;
  final double width;
  final double height;
  SmallCard({this.name,this.avatar,this.link,this.width: 80,this.height: 80});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: Image(
                image: AssetImage(avatar),
                width: width,
                height: height,
              ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(link.toString());
            },
            child:Text(name) ,
          )

        ],
      ) ,
    );
  }
}