import 'package:NSCE/ext/smartalert.dart';
import 'package:NSCE/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
// third screen

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String version;
  String appName;
  String buildNumber;
  String packageName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            appName ?? '',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryTextColor),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          // A title for the subsection:
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                  child: Text(
                    "Settings",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
          // The version tile :
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/change_password');
            },
            title: Text("Change password"),
            trailing: Icon(Icons.arrow_right),
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                child: SmartAlert(
                  title: "Warning",
                  description: "Are you sure you want to disable your account?",
                  onOk: () {
                    showDialog(
                      context: context,
                      child: SmartAlert(
                        title: "Alert",
                        description: "Account disable successfully.",
                      ),
                    );
                  },
                  canCancel: true,
                  okText: 'Yes',
                  cancelText: 'No',
                ),
              );
            },
            title: Text("Disable account"),
            trailing: Icon(Icons.arrow_right),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/about');
                  },
                  child: Text(
                    "About",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
          // The version tile :
          ListTile(
            enabled: false,
            title: Text("Version"),
            trailing: Text(
              version ?? "Loading ...",
              style: TextStyle(color: Colors.black38),
            ),
          ),
          ListTile(
            onTap: () async {
              const String url = ("https://nsce.com.ng/terms");
              if (await canLaunch(url)) {
                await launch(
                  url,
                  forceSafariVC: false,
                );
              }
            },
            title: Text("Terms of use"),
            trailing: Icon(Icons.arrow_right),
          ),
          // ...
        ],
      ),
    );
  }

  Future<String> getVersionNumber() async {
    final PackageInfo _ = await PackageInfo.fromPlatform();
    setState(() {
      version = _.version;
      appName = _.appName;
      buildNumber = _.buildNumber;
      packageName = _.packageName;
    });
  }
}
