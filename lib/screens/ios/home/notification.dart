import 'package:NSCE/ext/loading.dart';
import 'package:flutter/material.dart';
import 'package:NSCE/services/request.dart';
import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/ext/spinner.dart';
// Notification screen
class NotificationScreen extends StatefulWidget {
  NotificationScreenState createState()=>  NotificationScreenState();
}
class NotificationScreenState extends State<NotificationScreen>{
  bool _loading=true;
  List <Map<String,dynamic>> _notifications = [];
  void _loadNotifications() {
    _changeLoading(true);
    f(notification){
      if(notification is bool || notification == null){
        _changeNotification(<Map<String,dynamic>>[]);
      }else if (notification['data'] is List){
        List data=notification['data'];
        _changeNotification(data.map<Map<String,dynamic>>((l)=>l).toList());
      }else{
        _changeNotification(<Map<String,dynamic>>[]);
      }
      _changeLoading(false);
    }
    fetchNotifications().then(f);
  }
  void _changeNotification(e){
    setState(() {
      _notifications=e;
    });
  }
  void _changeLoading(bool state){
    setState(() {
      _loading=state;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_loading){
      _loadNotifications();
    }
    _buildList(e){
      return Card(
        elevation: 3.0,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        child:  ListTile(
          title:Text(e['title']),
          subtitle: Text(e['description']),
          trailing: IconButton(
            onPressed: (){
              f(res){
                if(res['message']!=null){
                  showDialog(context: context,barrierDismissible: false,builder: (BuildContext context){
                    return SmartAlert(title:"Alert" ,description: res['message']);
                  });
                }
              }
              e['read']?markAsUnreadNotifications(e['id']).then(f):markAsReadNotifications(e['id']).then(f);
            },
            icon: Icon(e['read']?Icons.notifications_none:Icons.notifications_active),
          ),
        ),
      );
    }
    return  Center(
      child:  _loading?Loading():_notifications.length==0?Text('No notifications available'):ListView(
        children: _notifications.map(_buildList).toList(),
      )
    );
  }
}