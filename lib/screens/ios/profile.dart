import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/colors.dart';
import '../../ext/loading.dart';
// Notification screen
class ProfilePage extends StatefulWidget {

  ProfilePage();
  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {

  bool _loadingIndicator;

  _ProfilePageState();

  @override
  void initState() {
    _loadingIndicator=true;

  }
  Future _done()async{
    await Future.delayed(new Duration(seconds: 10));
    _dataLoaded();
  }
  void _dataLoaded(){
    setState(() {
      _loadingIndicator = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (_loadingIndicator) {
      _done();
      return Loading();
    }
    Widget bodyBuilder(){
      return ListView(
          children: [
            Center(
              child: RaisedButton(
                onPressed: () {
                  // Navigator.pop(context);
                },
                child: Text('logout'),
              ),
            )
          ]
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile",style: TextStyle(color: primaryTextColor),),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body:bodyBuilder()
    );
  }

}