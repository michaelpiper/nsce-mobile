import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/loading.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert' as convert;
class ProductPage extends StatefulWidget {
  final int id;

  ProductPage({this.id});
  @override
  ProductStatePage createState() =>ProductStatePage(id:id);
}

class ProductStatePage extends State<ProductPage>{
  final int id;
  int unit;
  bool _loadingIndicator;
  Map<String,dynamic>  _product;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  TextEditingController _txtController = TextEditingController();
  ProductStatePage({this.id});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadingIndicator=true;
    unit=1;
  }
  void increament(){
    setState(() {
      unit++;
      _txtController.text=unit.toString();
    });
  }
  void decreament(){
    setState(() {
      if(unit>1)unit--;
      else unit=1;
      _txtController.text=unit.toString();
    });
  }
  Future _loadProduct() async {
    fetchProductWithParents(id).then((product){
      if(product==false || product==null){
        return Future.value(false);
      }
      if( product['data'] is Map){
        print(product['data']);
        setState(() {
          _product = product['data'];
          _productLoaded();
        });
        return Future.value(true);
      }else{

      }
      return Future.value(false);
    });
  }
  void _productLoaded(){
    setState(() {
      _loadingIndicator= false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_loadingIndicator){
      _loadProduct().then((loaded){
        if(loaded==false && Navigator.of(context).canPop())Navigator.of(context).pop();
      });
      return Loading();
    }
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
                  _product['Category']['Quarry']['state']+', '+_product['Category']['Quarry']['country'],
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
          Text(_product['Category']['Quarry']['likes']>0?_product['Category']['Quarry']['likes'].toString():''),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(onTap: (){
            launch('tel:'+_product['Category']['Quarry']['contactPhone']);
            },
            child:_buildButtonColumn(color, Icons.call, 'CALL'),
          ),
          InkWell(onTap: (){
            String url='https://maps.google.com/?q='+_product['Category']['Quarry']['address'];
            url+=", "+_product['Category']['Quarry']['state'];
            url+=", "+_product['Category']['Quarry']['country'];
            launch(url);
          },
            child:_buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          ),
          InkWell(onTap: (){
            String text = _product['Category']['Quarry']['address'];
            Share.share(text);
          },
            child:_buildButtonColumn(color, Icons.share, 'SHARE'),
          ),

        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        _product['Category']['Quarry']['address']+ "\n"+
        _product['Category']['Quarry']['description'],
        softWrap: true,
      ),
    );
    Widget headerSection= Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(0, 0, 0, 0), primaryColor],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
    child:
      Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .13,
              right: 0.0,
              left: 0.0
            ),
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.white,
              elevation: 4.0,
              shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(20.0,20.0),
                    bottom: Radius.elliptical(12.0,12.0)
                  )
                )
              ),
          ),
          Align(
            alignment: Alignment(0,11),
            child: Container(
              padding: EdgeInsets.only(
                  top: 20.0,
                  bottom: 60.01,
              ),
                height: 300.0,
                width:  MediaQuery.of(context).size.width-80,
                child: _product['image']==null?
                Container():
                Image.network(
                  baseURL(_product['image']),
                  alignment: Alignment(0,-11),
                  width: 200,
                  height: 240,
                  fit: BoxFit.fill,
                ),
            ),

          ),
        ],
      )
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
                  Expanded(child: Text(_product['name'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 20,color: textColor),),)
                ]
              ),
              Row(
                  children: <Widget>[
                    Expanded(child: Text('${CURRENCY['sign']} '+percentage(_product['price'],_product['discount']).toString()+'/'+_product['measuredIn'],style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: textColor),),)
                  ]
              ),
              _product['discount']==0?
              Container() :
              Row(
                  children: <Widget>[
                    Expanded(child: Text('${CURRENCY['sign']} '+_product['price'].toString(),style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: textColor,decoration: TextDecoration.lineThrough,decorationColor: noteColor),),),
                    Text(_product['discount'].toString()+'% Off',style: TextStyle(color: rejectColor,fontWeight: FontWeight.w600),)
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
                  Expanded(child:Text(_product['Category']['Quarry']['address']+' from Quarry in\n'+_product['Category']['Quarry']['state']+', '+_product['Category']['Quarry']['country'],style:TextStyle(color:noteColor,fontSize: 16,textBaseline: TextBaseline.alphabetic)))
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
                      child: Stack(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(right: 20.0),),
                          ButtonBar(
                            buttonPadding: EdgeInsets.only(top:20.0),
                            alignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 16,

                                icon: Icon(Icons.add),
                                tooltip: 'Increase volume by 1',
                                onPressed: () {
                                  increament();
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 7),
                                child:  SizedBox(
                                  width: 32,
                                  child: TextField(
                                    controller: _txtController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none
                                    ),
                                    onChanged: (e)=>setState(() {
                                      unit=int.tryParse(e);
                                    }),
                                    onSubmitted: (e)=>setState(() {
                                      unit=int.tryParse(e);
                                    }),
                                    style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.all(0.0),
                                iconSize: 16,
                                icon: Icon(Icons.remove),
                                tooltip: 'Decrease volume by 1',
                                onPressed: () {
                                  decreament();
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
                child: Text('Schedule'),
                onPressed: (){
                  Map post={'productId':id.toString(),'quantity':unit.toString(),'schedule':'','pickup':'0'};
                  storage.setItem(STORAGE_SCHEDULE_KEY, convert.jsonEncode({'post':post,'product':_product})).then<void>((value){
                    Navigator.pushNamed(context, '/schedule');
                  });
                },
              )
            ],
          ),
        )
      )
    );
    return Scaffold(
      resizeToAvoidBottomInset : true,
      appBar: AppBar(
        elevation: 0,
        title: Text(_product['name'],style: TextStyle(color: Colors.white),),
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