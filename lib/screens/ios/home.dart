import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:NSCE/utils/local_notications_helper.dart';
import 'package:NSCE/utils/constants.dart';
import 'package:NSCE/ext/smartalert.dart';
// import services here
import '../../services/auth.dart';
import '../../services/request.dart';
// import screen here
import 'home/transactions.dart';
import 'home/notification.dart';
import 'home/products.dart';
import 'home/wallet.dart';
import 'home/drawer.dart';




final notifications = FlutterLocalNotificationsPlugin();
final settingsAndroid = AndroidInitializationSettings('app_icon');
final settingsIOS = IOSInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) =>
        onSelectNotification(payload)
);
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {

  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('Firebase notification: ${notification['title']}');
    showOngoingNotification(notifications,
        title: notification['title'], body: notification['body'],payload: '$notification');
  }

  // Or do other work.
}
Future onSelectNotification(String payload) async {
  print('onSelectNotification: was click');
  Builder(builder: (context){
    Navigator.of(context).push(
        MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Notification',style: TextStyle(color: primaryTextColor),),
                ),
                body: SingleChildScrollView(
                  child: Html(
                      padding: EdgeInsets.all(12.0),
                      data:payload
                  ),
                ),
              );
            }
        )
    );
    return Container();
  });

}
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
  Timer _updateme;
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
    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch');
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message)async{
        print('Firebase: ${message['notification']}');
        showSilentNotification(notifications,
            title:  message['notification']['title'], body:  message['notification']['body'],payload: '$message');
        showDialog(
            context: context,
            builder: (context){
              return SmartAlert(title: message['notification']['title'], description: message['notification']['body']);
            });
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume');
      },
    );
    _firebaseMessaging.getToken().then((token){
      print('Firebase Token is $token');
      if(token!=null) {
        patchAccount({"pushNotificationToken": token});
        _firebaseMessaging.subscribeToTopic('all');
      }
    });
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings setting) {
      print('onIosSettingsRegistered: ' + setting.toString());
    });
  }
  @override
  void dispose(){
    super.dispose();
    if(_updateme!=null)
    _updateme.cancel();
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
    setState(() {
      userDetails = storage.getItem(STORAGE_USER_DETAILS_KEY)??{};
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
  Future<bool>_exitApp(BuildContext context){
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Do you want to exit this application?'),
        content: new Text('We hate to see you leave...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
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
    return WillPopScope(
        onWillPop: () => _exitApp(context),
    child: _foriOS()
    );
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