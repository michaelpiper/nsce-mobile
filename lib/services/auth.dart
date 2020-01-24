import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'request.dart';
import '../utils/constants.dart';
class AuthService with ChangeNotifier{
  AuthService(){
    print('new Service');

  }
  Future getUserDetails() async {
    var result = await checkAuth();
    print(result);
    if(result == false){
      return Future.value({});
    }
    if(result.containsKey('error') && result['error']) {
      return Future.value({});
    }
    if(result.containsKey('data') && result['data']!=null) {
      return Future.value(result['data']);
    }
    return Future.value({});
  }
  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(STORAGE_USER_KEY)){
      Map<String, dynamic> dat = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
      return Future.value(dat);
    }else{
      return Future.value(null);
    }
  }
  Future logout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(STORAGE_USER_KEY)){
      var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
      print(wait);
      if(wait.containsKey('authorization')){
        destroyAuth(wait['authorization']);
      }
      prefs.remove(STORAGE_USER_KEY);
    }
    notifyListeners();
    return Future.value(null);
  }
  Future createUser(formData) async{
    if(formData['username'] !='' && formData['password']!='' && formData['phone']!=''){
      var result = await createAuth(formData);
      print(result);
      if(result == false){
        return Future.value('No internet connection');
      }
      if(result.containsKey('authorization')){
        return Future.value('No internet connection');
      }
      if(result.containsKey('error') && result['error']){
        return Future.value(result['message']);
      }
      return Future.value(true);
    }else{
      return Future.value(null);
    }
  }
  Future loginUser({String username,String password}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(username !='' && password!=''){
      var result = await startAuth({'username':username,'password':password});
      print(result);
      if(result == false){
        return Future.value('No internet connection');
      }
      if(result.containsKey('error') && result['error']) {
        return Future.value(result['message']);
      }
      prefs.setString(STORAGE_USER_KEY,convert.jsonEncode(result['data']));
      notifyListeners();
      return Future.value(null);
    }else{
      if(prefs.containsKey(STORAGE_USER_KEY)) {
        prefs.remove(STORAGE_USER_KEY);
      }
      return Future.value(null);
    }
  }
}