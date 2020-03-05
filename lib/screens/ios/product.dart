import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:nsce/utils/colors.dart';
import 'package:nsce/utils/constants.dart';
class ProductPage extends StatelessWidget {
  final int id;
  ProductPage({this.id});
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Product Quarry',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Abekuta, Nigeria',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.yellow[500],
          ),
          Text('41'),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        ' sjkddsmlsdk lsdkdslk  '
            'Alps. Situated 1,578 meters above sea level, it is one of the '
            'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
            'half-hour walk through pastures and pine forest, leads you to the '
            'lake, which warms to 20 degrees Celsius in the summer. Activities '
            'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );
    Widget headerSection= Container(
//            alignment: Alignment.topCenter,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .02,
          right: 20.0,
          left: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(0, 0, 0, 1),secondaryColor, primaryColor],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .12,
            right: 20.0,
            left: 20.0),
        height: 300.0,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          child:  Image.asset(
            'images/sample1.png',
            width: 200,
            height: 240,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
    Widget aboutSection = Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text('Chippings',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: textColor),),)
                ]
              ),
              Row(
                  children: <Widget>[
                    Expanded(child: Text('${CURRENCY['sign']} 180,000.00/Unit',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: textColor),),)
                  ]
              ),
              Row(
                  children: <Widget>[
                    Expanded(child: Text('${CURRENCY['sign']} 210,000.00',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor,decoration: TextDecoration.lineThrough,decorationColor: noteColor),),),
                    Text('50% Off',style: TextStyle(color: rejectColor,fontWeight: FontWeight.w600),)
                  ]
              ),
            ]
          )
        )
      )
    );
    Widget shippingSection =  Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(
              children: <Widget>[
                Expanded(child: Text('Shipping Info',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),),),InkWell(child: Text('see more',style:TextStyle(color:primaryColor)))
              ]),
              Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right:7.0),),
                  Icon(Icons.local_shipping,color:noteColor),
                  Padding(padding: EdgeInsets.only(right:3.0),),
                  Expanded(child:Text('20 Mn. GSB(Granule Sub Base) Wetmix Coarse Aggregates. from Quarry in Abekuta',style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                ],
              )
            ]
          ),
        ),
      ),
    );
    Widget addtocart = Container(
      padding: EdgeInsets.only(
          top: 0.12,
          right: 0.0,
          left: 0.0),
      child:Card(
        color: Colors.white,
        elevation: 1.0,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(right: 20.0),
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(12.0,12.0),
                            bottom: Radius.elliptical(12.0,12.0)
                        ),
                        side: BorderSide(color: secondaryColor,)
                    ),
                    child:
                    SizedBox(
                      child: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 20.0),),
                          Text('2',
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic),
                            textAlign: TextAlign.end,
                          ),
                          ButtonBar(
                            buttonPadding: EdgeInsets.only(top:20.0),
                            alignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 16,

                                icon: Icon(Icons.add),
                                tooltip: 'Increase volume by 10',
                                onPressed: () {
                                  print('+1');
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 16,
                                icon: Icon(Icons.remove),
                                tooltip: 'Decrease volume by 10',
                                onPressed: () {
                                  print('-1');
                                },
                              ),
                            ],)
                        ],
                      ),

                      width: 130,
                      height: 40,),
                  ),
                  Text('x1 unit',
                    style: TextStyle(color: noteColor),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),

              MaterialButton(
                splashColor: primaryColor,
                color: primaryColor,
                textColor: primaryTextColor,
                hoverColor: primarySwatch,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(15.0,15.0),
                        bottom: Radius.elliptical(15.0,15.0)
                    ),
                    side: BorderSide(color: primarySwatch,)
                ),
                child: Text('Add to cart'),
                onPressed: (){
                  print(1);
                },
              )
            ],
          ),
        )
      )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Product name",style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          headerSection,
          aboutSection,
          shippingSection,
          titleSection,
          buttonSection,
          textSection,
        ],
      ),
      bottomNavigationBar: addtocart,
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}