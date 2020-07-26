import 'package:flutter/material.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/ext/spinner.dart';
// third screen
class SearchPage extends StatefulWidget {

  SearchPageState createState() => SearchPageState();
}
class  SearchPageState extends State<SearchPage>{
  var _controller;
  List <Map<String,dynamic>> _searchResult=[];
  bool _loading=false;
  void _loadSearch(e){
    _changeLoading(true);
    f(search){
      if(search is bool || search == null){
        _changeSearchResult(<Map<String,dynamic>>[]);
      }else if (search['data'] is List){
        List data=search['data'];
        _changeSearchResult(data.map<Map<String,dynamic>>((l)=>l).toList());
      }else{
        _changeSearchResult(<Map<String,dynamic>>[]);
      }
      _changeLoading(false);
    }
    searchProducts(e).then(f);
  }
  _changeSearchResult(e){
    setState(() {
      _searchResult=e;
    });
  }
  _changeLoading(bool state){
    setState(() {
      _loading=state;
    });
  }
  @override
  Widget build(BuildContext context) {
    buildList(e){
      return ListTile(
        title: Text(e['name']),
        onTap: (){
          Navigator.of(context).pushNamed('/product/'+e['id'].toString());
        },
        subtitle: Divider(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),

        centerTitle: false,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _controller,

          onChanged: (e){
            _loadSearch(e);
          },
          onSubmitted: (e){
            // print(e);
          },
          cursorColor: secondaryColor,
          style: TextStyle(
              color: primaryTextColor
          ),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(
                color:  primaryTextColor,
                decoration: TextDecoration.none
            )
          ),
          textInputAction: TextInputAction.search,
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
        actions: <Widget>[
          Padding(padding:EdgeInsets.symmetric(horizontal: 10),child:_loading?Spinner(icon:Icons.sync):SizedBox())
        ],
      ),
      body: Center(
        child: _searchResult.length==0?Text('No search results'):ListView(
          children: _searchResult.map(buildList).toList(),
        )
      )
    );
  }
}