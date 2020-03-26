import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/utils/constants.dart';
// Notification screen
class QuarryPage extends StatelessWidget {
  final int index;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  Map<String,dynamic> quarry;
  QuarryPage({this.index:0}){
       quarry = storage.getItem(STORAGE_QUARRY_KEY);
  }
  @override
  Widget build(BuildContext context) {
    quarry = ModalRoute.of(context).settings.arguments;
    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(onTap: (){
            launch('tel:'+quarry['contactPhone']);
          },
            child:_buildButtonColumn(color, Icons.call, 'CALL'),
          ),
          InkWell(onTap: (){
            String url='https://maps.google.com/?q='+quarry['address'];
            url+=", "+quarry['state'];
            url+=", "+quarry['country'];
            launch(url);
          },
            child:_buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          ),
          InkWell(onTap: (){
            String text = quarry['address'];
            Share.share(text);
          },
            child:_buildButtonColumn(color, Icons.share, 'SHARE'),
          ),

        ],
      ),
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
                      Expanded(child: Text('Shipping Info',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),),),InkWell(child: Text('Add review',style:TextStyle(color:primaryColor)))
                    ]),
                Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:7.0),),
                    Icon(Icons.local_shipping,color:noteColor),
                    Padding(padding: EdgeInsets.only(right:3.0),),
                    Expanded(child:Text(quarry['address']+' from Quarry in\n'+quarry['state']+', '+quarry['country'],style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
                  ],
                )
              ]
          ),
        ),
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
            quarry['description'],
        softWrap: true,
      ),
    );
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Quarry",style: TextStyle(color: primaryTextColor),),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: ListView(
            children: [
              buttonSection,
              shippingSection,
              textSection
            ]
        )
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