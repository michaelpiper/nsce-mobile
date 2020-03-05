import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nsce/utils/colors.dart';
import '../../../services/request.dart';
// import card;
import '../../../ext/smallcard.dart';
import '../../../ext/carouselwithindicator.dart';

class ProductsScreen extends StatelessWidget{
  final String title="Tail Coin";
  Map<String, dynamic> currentUser={'phone':''};
  Map<String, dynamic> userDetails={'balance':0};
  Function reload;
  bool _loading=false;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _dealoftheday = [];
  ProductsScreen({this.currentUser=const {'phone':''} ,this.userDetails=const {'balance':0},this.reload}){
    _categories= [
      {'avatar':'images/sample1.png','link':'/product/1','name':'Stone'},
      {'avatar':'images/sample2.png','link':'/product/1','name':'Concrate'},
      {'avatar':'images/sample3.png','link':'/product/1','name':'Asphalt'},
    ];

    _dealoftheday= [
      {'avatar':'images/sample1.png','link':'/product/1','name':'Stone'},
      {'avatar':'images/sample2.png','link':'/product/1','name':'Gravel'},
      {'avatar':'images/sample1.png','link':'/product/1','name':'Stone'},
      {'avatar':'images/sample1.png','link':'/product/1','name':'Concrate'},
    ];
  }
  void _returnState(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your purchase was succesful.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _returnError(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your purchase was unsuccesful.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _returnInsuf(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your balance is too low for this purchase try adding funds.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _BuyItem(amount,context) async {
    if(_loading) {
      Scaffold.of(context).showSnackBar(SnackBar(content:Text("An item purchase is processing please wait")));
      return;
    }
    _loading=true;
    Scaffold.of(context).showSnackBar(SnackBar(content:Text("Trying to purchase item please wait")));
    var act2 = fetchAccount(id:'balance');
    act2.then((value) {

      if (value == false) {
        _returnError(context);
        _loading=false;
        return;
      }
      else if (value.containsKey('error') && value['error']) {
        _returnError(context);
        _loading=false;
        return;
      }
      else if (value.containsKey('data') && value['data'] == null) {
        _returnError(context);
        _loading=false;
        return;
      }
      else if( value['data'] <= int.tryParse(amount)){
        _loading=false;
        return _returnInsuf(context);
      }
      buyItem({'amount': amount.toString()}).then((result) {
        if (result['error'] == false) {
          _returnState(context);
          _loading = false;
        }
      }).catchError((e) {
        print(e);
        _returnError(context);
        _loading = false;
      });
    }).catchError((e) {
      print(e);
      _returnError(context);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: ListView(
          shrinkWrap: false,
          children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(0, 0, 0, 0), primaryColor],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text('seeAll ',textAlign: TextAlign.right,style: TextStyle(color: primaryTextColor,),),),
                    CarouselWithIndicator(_categories,activeIndicator: actionColor,),
                  ]
                ),
              ),
              Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                       20.0,
                      ),
                      side: BorderSide(color: Colors.black12)),
                  child:Padding(
                    padding: EdgeInsets.only(top:12.0,bottom: 10.0,left:10.0,right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Types',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,fontFamily: 'Lato'),),
                            ),
                            InkWell(
                              child: Text('see All',style: TextStyle(color: Color.fromRGBO(237, 216, 22, 1),),),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _categories.map<Widget>((e)=> SmallCard(
                                name: e['name'],
                                avatar: e['avatar'],
                                link:  e['link'],
                                width:(MediaQuery.of(context).size.width/3)-23.0,
                                height:80
                            )
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                    side: BorderSide(color: Colors.black12)),
                child:Padding(
                  padding: EdgeInsets.only(top:12.0,bottom: 10.0,left:10.0,right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Deal of the Day',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,fontFamily: 'Lato',color: Colors.deepOrange),),
                          ),
                          InkWell(
                            child: Text('see All',style: TextStyle(color: Color.fromRGBO(237, 216, 22, 1),),),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _dealoftheday.map<Widget>((e)=> SmallCard(
                            name: e['name'],
                            avatar: e['avatar'],
                            link:  e['link'],
                            width:(MediaQuery.of(context).size.width/4)-23.0,
                            height:80
                        )
                        ).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _dealoftheday.map<Widget>((e)=> SmallCard(
                            name: e['name'],
                            avatar: e['avatar'],
                            link:  e['link'],
                            width:(MediaQuery.of(context).size.width/4)-23.0,
                            height:80
                        )
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
      );
  }
}