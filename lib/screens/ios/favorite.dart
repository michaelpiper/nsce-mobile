import 'package:NSCE/services/request.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'package:NSCE/ext/dialogman.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/ext/smartalert.dart';
// Notification screen
class FavoritePage extends StatefulWidget {
  @override
   FavoritePageState createState() => FavoritePageState();
}
class FavoritePageState extends State<FavoritePage>{
  bool _loadingStateIndicator=true;
  List <Map<String,dynamic>> _favoriteItem=[];
  final DialogMan dialogMan =DialogMan(child: Scaffold(
      backgroundColor: Colors.transparent,
      body:Center(
          child:CircularProgressIndicator()
      )
  ));

  void _loadFav(){
    fetchFavoriteItems().then((fav){
      // print(fav);
      if(fav is bool){
        showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
          return SmartAlert(title: "Error",description: "couldn't load page",onOk: (){ if(Navigator.of(context).canPop())Navigator.of(context).pop();},);
        });
      }else if(fav['error'] is bool && fav['error']==true){
        showDialog<void>(context: context,barrierDismissible: false,builder: (BuildContext context){
          return SmartAlert(title: "Error",description: "couldn't load page");
        });
      }else if(fav['data'] is List){
        List data = fav['data'];
        setState(() {
          _favoriteItem = data.map<Map<String,dynamic>>((e)=>e).toList();
          _favLoaded();
        });
      }else{
        if(Navigator.of(context).canPop())Navigator.of(context).pop();
      }
    });
  }
  void _favLoaded({state:true}){
    setState(() {
      _loadingStateIndicator=!state;
    });
  }
  @override
  Widget build(BuildContext context) {
    dialogMan.buildContext(context);

    if(_loadingStateIndicator){
      _loadFav();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Saved Items",style: TextStyle(color: primaryTextColor),),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: _loadingStateIndicator?Loading():_favoriteItem.length==0?
          Center(
            child: Text('No product added to saved item'),
          ):ListView(
        children:_favoriteItem.map<Widget>((e)=>
        Card(
          child: ListTile(
            onTap: (){
              Navigator.pushNamed(context, '/product/'+e['Product']['id'].toString());
            },
            leading: e['Product']['image']==null? Container(width: 200,
              height: 200,):Image(
              image: NetworkImage(baseURL(e['Product']['image'])),
              width: 40,
              height: 40,
              fit: BoxFit.fill,
            ),
            title: Text(e['Product']['name']),
            trailing: IconButton(
              icon: Icon(Icons.delete,color: Colors.redAccent,),
              onPressed: (){
                dialogMan.show();
                removeFromFavoriteItems(e['id'].toString()).then((res){
                  dialogMan.hide();
                  if(res is Map && res['error']==false){
                    for(var i=0;i<_favoriteItem.length;i++){
                      if(_favoriteItem[i]['id']==e['id']){
                        setState(() {
                          _favoriteItem.removeAt(i);
                        });
                      }
                      break;
                    }
                  }
                });
              },
            ),
          )
        )).toList()
      )
    );
  }
}