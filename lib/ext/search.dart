import 'package:flutter/material.dart';
import 'package:NSCE/ext/spinner.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/services/request.dart';
class Search extends StatefulWidget{
  final Function onSelect;
  final String initValue;

  Search({this.onSelect,this.initValue});
  @override
  _Search createState() => _Search();
}
class _Search extends State<Search>{
  bool _searchingIndicator=false;
  List<Map<String,dynamic>> _searchRes=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void _searchState(state){

    setState(() {
      _searchingIndicator=state;
    });
  }
  void _setSearchRes(res){
    setState(() {
      _searchRes=res;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 300.0,
      width: 300.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(image: AssetImage('images/map.png'),fit: BoxFit.fill)
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60,horizontal: 10),
                child: ListView(
                  children:_searchRes.map<Widget>((e)=> Card(
                    child: ListTile(onTap:(){
                      if(widget.onSelect is Function)widget.onSelect(e);
                    },title: Text(e['address'],style: TextStyle(color: textColor),),),
                  )).toList(),
//                      .add( SizedBox(height: 40,))
                )
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child:
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                child:  TextField(
//                  controller: _txtController,
                  maxLines: 1,

                  onChanged: (e){
                    f(res){
                      if(res is Map && res['data'] is List){
                        List data = res['data'];
                        _setSearchRes(data.map<Map<String,dynamic>>((e)=>e).toList());
                        _searchState(false);
                      }
                    }
                    if(e.length>5){
                      _searchState(true);
                      searchAddress(e).then(f);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: widget.initValue??'Lagos',
                      suffixIcon: _searchingIndicator?Spinner(icon:Icons.sync):Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 5.0
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      )
                  ),
                ),
              ),

            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: Alignment(1.05, -1.05),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}