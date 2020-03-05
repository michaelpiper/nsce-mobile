import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/ext/loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// Notification screen
class QuarriesPage extends StatefulWidget {
  QuarriesPageState createState()=> QuarriesPageState();
}
class QuarriesPageState extends State<QuarriesPage>{
  bool _loadingStateIndicator=true;
  List <Map<String,dynamic>> _quarriesItem=[];
  final DialogMan dialogMan =DialogMan(child: Scaffold(
    backgroundColor: Colors.transparent,
    body:Center(
     child:CircularProgressIndicator()
    )
  ));
  String _rating;
  String _comment;
  void _loadQuarries(){
    fetchQuarries().then((quarries){
      print(quarries);
      if(quarries is bool){
        showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
          return SmartAlert(title: "Error",description: "couldn't load page",onOk: (){ if(Navigator.of(context).canPop())Navigator.of(context).pop();},);
        });
      }else if(quarries['error'] is bool && quarries['error']==true){
        showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
          return SmartAlert(title: "Error",description: "couldn't load page");
        });
      }else if(quarries['data'] is List){
        List data = quarries['data'];
        setState(() {
          _quarriesItem = data.map<Map<String,dynamic>>((e)=>e).toList();
          _quarriesLoaded();
        });
      }else{
        if(Navigator.of(context).canPop())Navigator.of(context).pop();
      }
    });
  }
  void _quarriesLoaded({state:true}){
  setState(() {
  _loadingStateIndicator=!state;
  });
  }
  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);

    if(_loadingStateIndicator){
      _loadQuarries();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Quarries",style: TextStyle(color: primaryTextColor),),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: _loadingStateIndicator?Loading():
      _quarriesItem.length==0?Center(
        child: Text('No quarry available'),
      ):ListView(
        children:_quarriesItem.map<Widget>((e)=> Card(
          child: ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/quarry/'+e['id'].toString(),arguments: e);
            },
           title:Text( e['lga']+' '+e['state']+' '+e['country']),
           subtitle:Text( e['description']),
           trailing: IconButton(
              icon: Icon(Icons.star,color: Colors.orangeAccent,),
              onPressed: ()async{
               dialogMan.show();
               await Future.delayed(Duration(seconds: 3));
               dialogMan.hide();
                showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
                  f()async {
                    await likeQuarries(e['id'].toString(),
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
                    title: Text('Rate this Quarry'),
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
              },
            ),
          )
        )).toList()
      )
    );
  }
}