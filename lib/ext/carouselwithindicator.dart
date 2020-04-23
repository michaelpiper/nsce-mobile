import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
class CarouselWithIndicator extends StatefulWidget {
  List children = [];
  Color activeIndicator;
  Color indicator;
  CarouselWithIndicator(child,{this.activeIndicator:const Color.fromRGBO(0, 0, 0, 0.9) ,this.indicator:const  Color.fromRGBO(0, 0, 0, 0.4)}){
    List<Color> colors=[Colors.red,Colors.green, Colors.blue, Colors.green, Colors.yellow];
    Random random = new Random();
    child=map<Widget>(
      child, (index, i) {
      return InkWell(
        onTap: (){
          if(i['link']!=null){
            launch(i['link']);
          }
        },
        child:  Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(children: <Widget>[
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                      color:  colors[random.nextInt(colors.length-1)]
                  ),
                  height: 1000.0,
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    i['title']==null?'':i['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Image(
                image:i['avatar'].substring(0,4)=="http"?NetworkImage(i['avatar']):AssetImage("${i['avatar']}"),
                fit: BoxFit.cover,
                width: 1000.0,
                height: 1000.0,
              ),
            ]),
          ),
        ),
      );

    },
    ).toList();
    children = child;

  }
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState(child:children,indicator: indicator,activeIndicator: activeIndicator);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  List child = [];
  Color activeIndicator;
  Color indicator;
  _CarouselWithIndicatorState({this.child,this.indicator,this.activeIndicator});
  @override
  Widget build(BuildContext context) {

    return Column(children: [
      CarouselSlider(
        items: child,
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        viewportFraction: 1.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          child,
              (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? activeIndicator
                      : indicator),
            );
          },
        ),
      ),
    ]);
  }
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}