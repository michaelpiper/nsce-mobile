import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';
import '../utils/constants.dart';

fetchDispatch({id:false})async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response;
    if(id!=false) {
      response = await http.get(API_DISPATCH_URL + '/driver/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_DISPATCH_URL +'/driver', headers: headers);
    }
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    return false;
  }
}
updateDispatch(id,Map body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.put(API_DISPATCH_URL + '/driver/' + id.toString(),body: body, headers: headers);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    return false;
  }
}
