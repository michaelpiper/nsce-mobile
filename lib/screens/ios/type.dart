import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../ext/smallcard.dart';
import '../../ext/tablebuilder.dart';
import '../../ext/loading.dart';
import '../../services/request.dart';
// Notification screen
class TypePage extends StatefulWidget {
  final int index;
  TypePage({this.index});
  @override
  _TypePageState createState() => _TypePageState(index:this.index);
}
class _TypePageState extends State<TypePage> with TickerProviderStateMixin {
  int index;
  List <Map<String, dynamic>> _products = [];
  List <Map<String, dynamic>> _types = [];
  bool _loadingIndicator;
  bool _loadingProductIndicator;
  _TypePageState({this.index:1});

  @override
  void initState(){
    super.initState();
    _types = [

    ];
    _products=[

    ];
    _loadingIndicator=true;
    _loadingProductIndicator=true;
  }
  Future _done()async{
    fetchTypes().then((types){
      if(types==false || types==null)
        return Future.value(false);
      if(types['data'] is List){
        List data=types['data'];
        print(data);
        setState(() {
          if(data.length>0 && index==null){
            index=data[0]['id'];
          }
          _types=data.map((e)=>
          {
            'id':e['id'],
            'avatar':e['image']!=null?baseURL(e['image']):null,
            'name':e['name']
          }).toList();
          _dataLoaded();
        });

        return Future.value(true);
      }else{
        setState(() {
          _types = [];
        });
      }
      return Future.value(false);

    });

  }
  Future loadProducts()async{
    _productLoaded(state: false);
    fetchTypeProducts(index.toString())
        .then((products){
      if(products==false || products==null)
        return;
      if(products['data'] is List) {
        List data = products['data'];
        setState(() {
          _products = data.map((e) =>
          {
            'avatar': e['image']!=null?baseURL(e['image']):null,
            'link': '/product/' + e['id'].toString(),
            'name': e['name'],
            'price': CURRENCY['sign']+' '+e['price'].toString()
          }).toList();
          _productLoaded();
        });
      }else{
        setState(() {
          _products =[];
        });
      }

    });
    return;
  }
  void _dataLoaded(){
    setState(() {
      _loadingIndicator = false;
    });
  }
  void _productLoaded({state=true}){
    setState(() {
      _loadingProductIndicator = !state;
    });
  }
  void _loadType(id){
    setState(() {
      this.index=id;
      _loadingProductIndicator = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_loadingIndicator){
      _done().then((loaded){
        if(loaded==false && Navigator.of(context).canPop())Navigator.of(context).pop();
      });
      return Loading();
    }
    if(_loadingProductIndicator){
      loadProducts();
    }


    Widget  _sidebar = Container(
      width:90,
      color: liteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:
            _types.map <Widget>((type)=>Card(
              color: (index==type['id'])?primaryColor:primaryTextColor,
              child: InkWell(
                onTap: (){
                  _loadType(type['id']);
                },
                child:
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:BorderRadius.vertical(
                            top:    Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                              image:NetworkImage(type['avatar']),
                              fit: BoxFit.cover
                          )
                      ),
                      height: 100,
                      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
                    ),
                    Text(type['name'],style:TextStyle(color:(index==type['id'])?primaryTextColor:primaryColor),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            )).toList(),
      ),
    );
    Widget productsBuilder(){
      return TableBuilder(
        _products.map<Widget>((e)=> Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
                side: BorderSide(color: Colors.black12)),
            child:Padding(
              padding: EdgeInsets.only(top:2.0,bottom: 2.0,left:2.0,right: 2.0),
              child:SmallCard(
                  name: e['name'],
                  avatar: e['avatar'],
                  link:  e['link'],
                  subtitle: e['price'],
                  width:((MediaQuery.of(context).size.width-100)/2)-23.0,
                  height:80
              ),
            )
        ),
        ).toList(),column: 2,);
    };
    Widget _body = Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(255, 255, 255, 0.98),
      child:  ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(height: 5.0,color: bgColor,),
          Container(padding:EdgeInsets.symmetric(horizontal: 12),child: Text('Product',style: TextStyle(color: noteColor,fontWeight: FontWeight.w600,fontSize: 20),),color: liteColor,),
          Container(height: 5.0,color: bgColor,),
          Container(child: productsBuilder(),)
        ]
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Types", style: TextStyle(color: liteTextColor),),
        iconTheme: IconThemeData(color: liteTextColor),
        backgroundColor: liteColor,
      ),
      backgroundColor: bgColor,
      body:Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Row(
          children: <Widget>[
            _sidebar,
            Expanded(
              child: _loadingProductIndicator? Loading():_body,
            )
          ],
        ),
      )
    );
  }
}