import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatelessWidget {
  final String text = 'NSCE\'s focal point is the provision of ultra-high'
      ' quality building and construction materials by adopting'
      ' safe and environmental conscious processes. We aim to'
      ' facilitate the development of sustainable infrastructure'
      ' of the future.';
  @override
  Widget build(BuildContext context) {
    buildBody() => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                text,
                textAlign: TextAlign.justify,
              ),
              Spacer(),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                        AsyncSnapshot<PackageInfo> snapshot) =>
                    Text("Build: V "+snapshot.data.version +' '+ (Platform.isIOS ? 'iOS' : 'Android')),
              ),
            ],
          ),
        );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "About",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: buildBody(),
    );
  }
}
