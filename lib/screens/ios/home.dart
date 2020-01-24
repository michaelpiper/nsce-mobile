
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import services here
import '../../services/auth.dart';

// import screen here
import 'home/settings.dart';
import 'home/transaction.dart';
import 'home/notification.dart';

class TabContent {    
  final String title;    
  final Widget content;    
  TabContent({this.title, this.content});    
}  
class HomePage extends StatefulWidget {
  var currentUser;
  String title;
  HomePage({Key key, this.title}): super(key: key){
    this.title=(this.title !=null )?this.title:'Nsce';
  }

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  var currentUser={'phone':''};
  int _currentIndex = 0;
  int _counter=0;
  String _title;
  List _children = <TabContent>[ ];
  List <Widget>_childrenWithoutTitle=<Widget>[];
  TabController _controller;
  Future act;
  _HomePageState(){
    TabContent _homescreen=TabContent(title:'Tail Coin', content: HomeScreen(_incrementCounter,currentUser: currentUser, counter: _counter,));
    TabContent _notificationPage =TabContent(title:'Notifications', content: NotificationPage());
    TabContent _transactionPage= TabContent(title:'Transactions', content: TransactionPage());
    // TODO: implement initState
    _children= <TabContent>[_homescreen,_notificationPage,_transactionPage];
  }
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _children.length, vsync: this);
    _title= _children[_controller.index].title;
    _controller.addListener(_handleSelected);
  }
  void _handleSelected() {
    setState(() {
     _title= _children[_controller.index].title;
     print(_title);
    });
  }
  void _onTabTapped(int index) {
    setState(() {
      if(index>2){
       return _openSettings();
      }
      _currentIndex = index;
      _title = _children[index].title;
    });
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter= _counter+2;
      TabContent _homescreen=TabContent(    
        title: 'Tail Coins',    
        content: HomeScreen(_incrementCounter,currentUser: currentUser, counter: _counter,),
      );
      TabContent _notificationPage = TabContent(    
        title: 'Notifications',   
        content:  NotificationPage());
      TabContent _transactionPage= TabContent(    
        title: 'Transactions', 
        content:  TransactionPage());
      _children= <TabContent>[_homescreen,_notificationPage,_transactionPage];
      print('$_counter is counted increase');
    });
  }
  void _openSettings(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>SettingsPage()),
    );
  }
  _foriOS(){
    return 
    Scaffold(
      appBar: AppBar(title: Text(_title),),
      body:_children[_currentIndex].content,
      // body:HomeScreen(_incrementCounter,currentUser: currentUser, counter: _counter,),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
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
          BottomNavigationBarItem(icon: Icon(Icons.mail), title: Text('Notifications')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('Transactions')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  _forAndroid(){
    _childrenWithoutTitle = _children.map<Widget>(( child)=>child.content).toList();
    return 
     Scaffold(
        appBar: AppBar( 
          title: Text(_title),
          bottom: TabBar(
          controller: _controller,
          isScrollable: true,
          tabs: <Tab>[
              Tab(
                text:'Home',
                icon: Icon(Icons.home),
              ),
              Tab(
                text:'Transactions',
                icon: Icon(Icons.attach_money),
              ),
              Tab(
                text:'Notifications',
                icon: Icon(Icons.schedule),
              ),
            ],
          ),
        ),
        body:TabBarView(
          controller: _controller,
            children: _childrenWithoutTitle
        ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  @override
  Widget build(BuildContext context) {
    act = Provider.of<AuthService>(context).getUser();
    act.then((value){
      setState(() {
      currentUser=value;
      _children [0]= TabContent(title:'Tail Coin', content: HomeScreen(_incrementCounter,currentUser: currentUser, counter: _counter,));
      });
    });
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // return _foriOS();
    if(Platform.isAndroid){
      return _forAndroid();
    }else if(Platform.isIOS){
      return _foriOS();
    }
    return Container(); 
  }
}
class HomeScreen extends StatelessWidget{
   String title="Tail Coin";
  var currentUser={'phone':''};
  int counter;
  Function incrementCounter;
  HomeScreen(this.incrementCounter,{this.currentUser=const {'phone':''} ,this.counter=1});
 
   @override
  Widget build(BuildContext context) {
    
  return 
    Scaffold(
      body:
        Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You phone number is: ${currentUser['phone']}',
              ),
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$counter',
                style: Theme.of(context).textTheme.display1,
              ),
              RaisedButton(
                child: Text('Open route'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>TransactionPage()),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      )
    );
  }
}