import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nsce/app/main.dart';

// import services here
import 'services/auth.dart';
void main() => runApp(
    ChangeNotifierProvider<AuthService>(
      child: MyApp(),
      create: (BuildContext context){
        return AuthService();
      }
    )
  );

