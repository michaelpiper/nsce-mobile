import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:NSCE/utils/constants.dart';
// import services here
import '../../services/auth.dart';
import '../../services/request.dart';
// import screen here
import 'home/transactions.dart';
import 'home/notification.dart';
import 'home/products.dart';
import 'home/wallet.dart';
import 'home/drawer.dart';
import 'dart:async';
class TabContent {    
  final String title;    
  final Widget content;    
  TabContent({this.title, this.content});    
}  
class HomePage extends StatefulWidget {
  var currentUser;
  String title;
  int currentIndex;
  HomePage({Key key, this.title, this.currentIndex= 0}): super(key: key){
    this.title=(this.title !=null )?this.title:'NSCE';
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
 
  @override
  _HomePageState createState() => _HomePageState( currentIndex: currentIndex );
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Map<String, dynamic> currentUser={'phone':''};
  Map<String, dynamic> userDetails={'balance':0000};
  int currentIndex;
  String _title="";
  List _children = <TabContent>[ ];
  TabController _controller;
  Future act;
  Future act2;
  final LocalStorage storage = new LocalStorage(STORAGE_KEY);
  _HomePageState({this.currentIndex = 0}){
    _refresh();
  }
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _children.length, vsync: this);
    _title = _children[currentIndex].title;
    _controller.addListener(_handleSelected);
    _initMe();
  }
  @override
  void dispose(){
    super.dispose();
  }

  void _handleSelected() {
    setState(() {
     _title = _children[_controller.index].title;
     // print(_title);
    });
  }
  void _onTabTapped(int index) {
    setState(() {
      currentIndex = index;
      _title = _children[index].title;
    });
  }
  _foriOS(){
    return
      Scaffold(
        drawer:AppDrawer(userDetails:userDetails,currentUser: currentUser,onTabTapped:_onTabTapped),
        appBar: AppBar(
          elevation: 0,
          title:_title=="Home" ?Image.asset('images/icon_white.png',width: 102,height: 35,)
              :Text(_title,style: TextStyle(color: Colors.white,)),
          iconTheme: IconThemeData(color:primaryTextColor),
          actions: <Widget>[
            SizedBox(
              height: 25.0,
            ),
            _title=="Home" ?Container():Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child:IconButton(
                  color: primaryTextColor,
                  icon:Icon(Icons.search),
                  onPressed: (){
                    Navigator.pushNamed(context, '/search');
                  },
                )
            ),
            CartLength(),
            _title=="Home" ?Container():Padding(
              padding: const EdgeInsets.symmetric(vertical:16.0),
              child:PopupMenuButton(
                  color: primaryTextColor,
                  icon: Icon(Icons.more_vert,color:Colors.white),
                  onSelected: (result){
                    if(result=='i-don-catch-u')Navigator.pushNamed(context, '/settings');
                    else if(result=='if-i-catch-u'){
                      Provider.of<AuthService>(context).logout();
                      if(Navigator.canPop(context)) Navigator.pop(context);
                    }
                    // print(result);
                  },
                  itemBuilder: (BuildContext context)=><PopupMenuEntry>[
                    const PopupMenuItem(value:'if-i-catch-u',child: Text('Logout')),
                    const PopupMenuItem(value:'i-don-catch-u',child: Text('Settings')),
                  ]
              ),
            ),
          ],
        ),
        body:_children[currentIndex].content,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTabTapped,
          selectedLabelStyle: TextStyle(
              color: Colors.black
          ),
          selectedItemColor: Colors.blue,
          selectedIconTheme:IconThemeData(color:Colors.blueAccent),
          unselectedItemColor: Colors.black54,
          unselectedIconTheme:IconThemeData(color: Colors.black54),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), title: Text('Notifications')),
            BottomNavigationBarItem(icon: Icon(Icons.view_list), title: Text('Transactions')),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card), title: Text('Wallet')),
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      );
  }
  _initMe(){
    act = AuthService.staticGetUser();
    act.then ((value){
      setState(() {
        currentUser=value;
      });
    });
    act2 = checkAuth();
    act2.then((value){
//      // print(value);
      if(value == false){
        return;
      }
      if(value.containsKey('error') && value['error']) {
        return;
      }
      if(value.containsKey('data') && value['data']==null) {
        return ;
      }
      setState(() {
        userDetails = value['data'];
        storage.setItem(STORAGE_USER_DETAILS_KEY, userDetails).then<void>((value){});
      });
    });
  }
  _refresh(){
    TabContent _productsScreen=TabContent(title:'Home', content: ProductsScreen(currentUser: currentUser,userDetails: userDetails, reload:_initMe));
    TabContent _notificationScreen =TabContent(title:'Notifications', content: NotificationScreen());
    TabContent _transactionsScreen= TabContent(title:'Transactions', content: TransactionsScreen());
    TabContent _walletScreen= TabContent(title:'Wallet', content: WalletScreen(currentUser: currentUser,userDetails: userDetails, reload:_initMe));
    // TODO: implement initState
    _children= <TabContent>[_productsScreen, _notificationScreen,_transactionsScreen,_walletScreen];
  }
  @override
  Widget build(BuildContext context) {
    _refresh();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

//    return _forAndroid();
    return _foriOS();

  }
}


class CartLength extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartLength();
  }
}

class _CartLength extends State<CartLength> {
  int _cartCount=0;
  Timer _updateme;
  void updateCart(){
    count(cartCount){
      if(cartCount is bool || cartCount == null){
        return;
      }
      if(cartCount['error']==false && cartCount['data'] is int){

        setState(() {
          _cartCount=cartCount['data'];
        });
      }
    }
    fetchCart(id:'count').then(count);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateCart();
    _updateme=new Timer(const Duration(seconds: 5),updateCart);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _updateme.cancel();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Positioned(
            right: 8,
            top: 10,
            child:_cartCount==0?SizedBox():Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle
              ),
              padding: EdgeInsets.all(3),
              child: Text(_cartCount.toString(),style: TextStyle(color: primaryTextColor),),
            )
        ),
        Align(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child:IconButton(
                color: primaryTextColor,
                icon:Icon(Icons.shopping_cart),
                onPressed: (){
                  Navigator.pushNamed(context, '/cart');
              },
            )
          ),
        ),
      ],
    );
  }
}