import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'request.dart';
import '../utils/helper.dart';
import '../utils/constants.dart';

class AuthService with ChangeNotifier {
  AuthService() {
    // print('new Service');
  }

  static Future getAccount({id = false}) async {
    var result = await fetchAccount(id: id);
    if (id != false) {
      if (result == false) {
        return Future.value(null);
      }
      return Future.value(result['data']);
    } else {
      if (result == false) {
        return Future.value({});
      }
      return Future.value(result);
    }
  }

  static Future getUserDetails() async {
    var result = await checkAuth();
//    // print(result);
    if (result == false) {
      return Future.value({});
    }
    if (result.containsKey('error') && result['error']) {
      return Future.value({});
    }
    if (result.containsKey('data') && result['data'] != null) {
      Map<String, dynamic> dat = result['data'];
      return Future.value(dat);
    }
    return Future.value({});
  }

  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(STORAGE_USER_KEY)) {
      Map<String, dynamic> dat =
          convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
      return Future.value(dat);
    } else {
      return Future.value(null);
    }
  }

  static Future staticGetUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(STORAGE_USER_KEY)) {
      Map<String, dynamic> dat =
          convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
      return Future.value(dat);
    } else {
      return Future.value(null);
    }
  }

  Future getUserForLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 5));
    if (prefs.containsKey(STORAGE_USER_KEY)) {
      Map<String, dynamic> dat =
          convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
      return Future.value(dat);
    } else {
      return Future.value(null);
    }
  }

  Future forgetPassword({@required phone}) async {
    var result = await recoverAuth({'phone': phone});
    if (result == false) {
      return Future.value('No internet connection');
    }
    if (result.containsKey('error')) {
      return Future.value(result['message']);
    }
    return Future.value(null);
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(STORAGE_USER_KEY)) {
      var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
      // print(wait);
      if (wait.containsKey('authorization')) {
        destroyAuth(wait['authorization']);
      }
      prefs.remove(STORAGE_USER_KEY);
    }
    notifyListeners();
    return Future.value(null);
  }

  Future createUser(formData) async {
    if (formData['username'] != '' &&
        formData['password'] != '' &&
        formData['phone'] != '') {
      var result = await createAuth(formData);
      // print(result);
      if (result == false) {
        return Future.value('No internet connection');
      }
      if (result.containsKey('error') && result['error']) {
        return Future.value(result['message']);
      }
      return Future.value(true);
    } else {
      return Future.value(null);
    }
  }

  Future loginUser({String username, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isInDebugMode &&
        username == 'test@test.com' &&
        password == 'password1') {
      var result = {
        'id': '4',
        'email': 'pipermichael@aol.com',
        'phone': '08147065493',
        'createdAt': '2020-02-13T10:37:17.000Z',
        'updatedAt': '2020-02-13T10:37:17.000Z',
        'authorization': 'Bearer MTU4MjUzNjA0MTUwNnd3S09SQXJ5NG9RT0ZoS3FvSg=='
      };
      prefs.setString(STORAGE_USER_KEY, convert.jsonEncode(result));
      notifyListeners();
      return Future.value(null);
    } else if (username != '' && password != '') {
      var result =
          await startAuth({'username': username, 'password': password});
      if (result == false) {
        return Future.value('No internet connection');
      }
      if (result.containsKey('error') && result['error']) {
        return Future.value(result['message']);
      }
      prefs.setString(STORAGE_USER_KEY, convert.jsonEncode(result['data']));
      notifyListeners();
      return Future.value(null);
    } else {
      if (prefs.containsKey(STORAGE_USER_KEY)) {
        prefs.remove(STORAGE_USER_KEY);
      }
      return Future.value(null);
    }
  }
}
