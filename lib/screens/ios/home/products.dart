import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:NSCE/utils/helper.dart';
import '../../../services/request.dart';
// import card;
import '../../../ext/smallcard.dart';
import '../../../ext/carouselwithindicator.dart';
import '../../../ext/tablebuilder.dart';
class ProductsScreen extends StatefulWidget{
  final String title="Home";
  Map<String, dynamic> currentUser={'phone':''};
  Map<String, dynamic> userDetails={'balance':0};
  Function reload;
  bool _loading=false;
  List<Map<String, dynamic>> _types = [];
  List<Map<String, dynamic>> _quicklink = [];
  ProductsScreen({this.currentUser=const {'phone':''} ,this.userDetails=const {'balance':0},this.reload});

  @override
  _ProductsScreenState createState() =>  new _ProductsScreenState(currentUser:currentUser,userDetails:userDetails,reload:reload);
}
class _ProductsScreenState extends State<ProductsScreen> {
  final String title="Home";
  Map<String, dynamic> currentUser={'phone':''};
  Map<String, dynamic> userDetails={'balance':0};
  Function reload;
  bool _loading=false;
  bool _loadingTypeIndicator = true;
  bool _loadingAdvertIndicator=true;
  List<Map<String, dynamic>> _types = [];
  List<Map<String, dynamic>> _adverts = [];
  List<Map<String, dynamic>> _quicklink = [];
  _ProductsScreenState({this.currentUser=const {'phone':''} ,this.userDetails=const {'balance':0},this.reload}){
    _types= [];
    _adverts=[];
    _adverts=[{'id':'','link':'https://google.com','avatar':'images/sample1.png','name':''},{'id':'','link':'https://google.com','avatar':'images/sample2.png','name':''}];
    _quicklink= [
      {'avatar':'assets/icons/order.png','link':'/orders','name':'My Orders','color':Color.fromRGBO(242, 189, 40, 0.12)},
      {'avatar':'assets/icons/calculator.png','link':'/orders','name':'Calculator','color':Color.fromRGBO(242, 189, 40, 0.12)},
      {'avatar':'assets/icons/payment.png','link':'/home/2','name':'Payments','color':Color.fromRGBO(242, 189, 40, 0.12)},
      {'avatar':'assets/icons/wallet.png','link':'/home/3','name':'Wallet','color':Color.fromRGBO(242, 189, 40, 0.12)},
      {'avatar':'assets/icons/invoice.png','link':'/product/1','name':'Invoice','color':Color.fromRGBO(242, 189, 40, 0.12)},
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
  Future _loadType()async{
    fetchTypes().then((types){
      if(types==false || types==null)
        return Future.value(false);
      if(types['data'] is List){
        List data=types['data'];
        setState(() {
          _types=data.map((e)=>
          {
            'id':e['id'],
            'link':'/type/'+e['id'].toString(),
            'avatar':e['image']!=null?baseURL(e['image']):null,
            'name':e['name']
          }).toList();

          _typeLoaded();
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
  Future _loadAdvert()async{
    fetchAdverts().then((types){
      if(types==false || types==null)
        return Future.value(false);
      if(types['data'] is List){
        List data=types['data'];
        setState(() {
          _adverts=data.map<Map<String,dynamic>>((e)=>
          { 'id':e['id'],
            'link':e['link'],
            'avatar':e['image']!=null?baseURL(e['image']):null,
           }
          ).toList();

          _advertLoaded();
        });
        return Future.value(true);
      }else{

      }
      return Future.value(false);

    });
  }
  void _typeLoaded(){
    setState(() {
      _loadingTypeIndicator = false;
    });
  }
  void _advertLoaded(){
    setState(() {
      _loadingAdvertIndicator = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_loadingTypeIndicator){
      _loadType();
    }
    if(_loadingAdvertIndicator){
      _loadAdvert();
    }
    TableBuilder _table = TableBuilder(
        _types.map<Widget>((e)=> SmallCard(
            name: e['name'],
            avatar: e['avatar'],
            link:  e['link'],
            width:(MediaQuery.of(context).size.width/3)-23.0,
            height:80
        )).toList(),column: 3
    );
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
                    ),
                    _loadingAdvertIndicator?Center(child:CircularProgressIndicator()):CarouselWithIndicator(_adverts,activeIndicator: actionColor,),
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

                          ],
                        ),
                        _loadingTypeIndicator? Center(child:CircularProgressIndicator()):_table
                      ],
                    ),
                  ),
                ),
              Padding(
                padding:EdgeInsets.symmetric(vertical: 19.0,horizontal: 10.0) ,
                child:MaterialButton(
                  color: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 13.0,horizontal: 19.0),
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(10.0,10.0),
                    bottom: Radius.elliptical(10.0,10.0)
                    ),
                    side: BorderSide(color: primarySwatch,)
                  ),
                  onPressed: (){
                   Navigator.pushNamed(context, '/type');
                  },
                  child: Text('Place New Order',style: TextStyle(color: primaryTextColor),),
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

                      TableBuilder(
                        _quicklink.map<Widget>((e)=>SmallCard(
                            name: e['name'],
                            avatar: e['avatar'],
                            link:  e['link'],
                            color: e['color'],
                            radius: 2,
                            fit: BoxFit.none,
                            width:(MediaQuery.of(context).size.width/4)-23.0,
                            height:80
                          )
                        ).toList(),
                        column: 4,
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