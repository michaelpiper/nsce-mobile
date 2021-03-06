import 'package:NSCE/services/dialog.dictionary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth.dart';
import '../../../utils/colors.dart';
import 'package:NSCE/utils/helper.dart';

class AppDrawer extends StatelessWidget {
  final Map currentUser;
  final Map userDetails;
  Function onTabTapped;

  AppDrawer(
      {this.userDetails: const {},
      this.currentUser: const {},
      this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    ImageProvider bgIm = (userDetails.containsKey('image') &&
            userDetails['image'] != null &&
            userDetails['image'] != '')
        ? NetworkImage(baseURL('${userDetails['image']}'))
        : AssetImage('images/avatar.png');
    Widget headerSegment = Container(
      color: primaryColor,
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: CircleAvatar(
                    key: UniqueKey(),
                    backgroundImage: bgIm,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                (userDetails['firstName'] == null
                        ? ''
                        : userDetails['firstName']) +
                    ' ' +
                    (userDetails['lastName'] == null
                        ? ''
                        : userDetails['lastName']),
                style: TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
            ]),
      ),
    );

    Widget linksSegment = Container(
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).size.height / 3),
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            },
            title: Text(
              dialogDictionary.home,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.home,
              color: Colors.blue,
              size: 30,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/type');
            },
            title: Text(
              dialogDictionary.products,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.view_list,
              color: Colors.pinkAccent,
              size: 30,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
            title: Text(
              dialogDictionary.myOrders,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.assignment,
              color: Colors.greenAccent,
              size: 30,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/quarries');
            },
            title: Text(
              dialogDictionary.yards,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.shopping_basket,
              color: Colors.yellowAccent,
              size: 30,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/favorite');
            },
            title: Text(
              dialogDictionary.savedItems,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.favorite_border,
              color: Colors.redAccent,
              size: 30,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
          ),
          ListTile(
            onTap: () {
              if (onTabTapped is Function) onTabTapped(3);
              Navigator.pop(context);
            },
            title: Text(
              dialogDictionary.wallet,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.credit_card,
              color: Colors.blue,
              size: 30,
            ),
            trailing: Icon(
              Icons.arrow_right,
              color: Colors.black54,
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black54,
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
            title: Text(
              dialogDictionary.settings,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.settings,
              color: secondaryTextColor,
              size: 30,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
            title: Text(
              dialogDictionary.about,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.info_outline,
              color: secondaryTextColor,
              size: 30,
            ),
          ),
          ListTile(
            onTap: () {
              Provider.of<AuthService>(context).logout();
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            title: Text(
              dialogDictionary.logout,
              style: TextStyle(color: noteColor),
            ),
            leading: Icon(
              Icons.exit_to_app,
              color: secondaryTextColor,
              size: 30,
            ),
          ),
        ],
      ),
    );

    return Drawer(
        child: Column(children: <Widget>[headerSegment, linksSegment]));
  }
}
