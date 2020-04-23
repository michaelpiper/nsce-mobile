import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/request.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// Notification screen
class QuarryPage extends StatefulWidget {
  final int index;
  QuarryPage({this.index:0});
  QuarryPageState createState()=> QuarryPageState();
}
class QuarryPageState extends State<QuarryPage>{
  int index;
  Map<String,dynamic> quarry;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));
  String _rating;
  String _comment;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quarry = storage.getItem(STORAGE_QUARRY_KEY);
    index=widget.index;
  }

  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);
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
    addReview()async{
      dialogMan.show();
      await Future.delayed(Duration(seconds: 3));
      dialogMan.hide();
      showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
        f()async {
          await likeQuarries(quarry['id'].toString(),
              {'rating': _rating.toString(), 'comment': _comment.toString()})
              .then((res) {
            String message=res['message']!=null?res['message']:'Raview submited';
            showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
              completed(){
                if(Navigator.of(context).canPop())Navigator.of(context).pop();
              }
              return SmartAlert(title:"Alert",description:message,onOk: completed,);
            }
            );
          });
        }
        return AlertDialog(
          title: Text('Rate this Yard'),
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(10.0,10.0),
                bottom: Radius.elliptical(10.0,10.0)
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[
                  RatingBar(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating=rating.toString();
                      });
                    },
                  ),
                  TextField(
                      decoration: InputDecoration(
                          labelText:'Comments'
                      ),
                      onChanged: (e){
                        setState(() {
                          _comment=e;
                        });
                      }
                  )
                ]
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL',style: TextStyle(color: Colors.red),),
              onPressed: () {
                if(Navigator.of(context).canPop())Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                f();
              },
            )
          ],
        );
      });
    }
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
                      Expanded(child: Text('Shipping Info',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor),),),InkWell(onTap:addReview,child: Text('Add review',style:TextStyle(color:primaryColor)))
                    ]),
                Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(right:7.0),),
                    Icon(Icons.local_shipping,color:noteColor),
                    Padding(padding: EdgeInsets.only(right:3.0),),
                    Expanded(child:Text(quarry['address']+' from Yard in\n'+quarry['state']+', '+quarry['country'],style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
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
          title: Text("Yard",style: TextStyle(color: primaryTextColor),),
          iconTheme: IconThemeData(color: primaryTextColor),
        ),
        body: ListView(
            children: [
              SizedBox(
                height: 70,
              ),
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