import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';
import '../utils/constants.dart';
createAuth(body) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  // Await the http get response, then decode the json-formatted response. headers: headers,
  /*  
    If body is a List, it's used as a list of bytes for the body of the request.
    If body is a Map, it's encoded as form fields using encoding.
    The content-type of the request will be set to "application/x-www-form-urlencoded";
    this cannot be overridden.
    encoding defaults to utf8.
  */
  print(API_AUTH_URL);
  print(body);
  try{
    var response = await http.post(API_AUTH_URL, body: body );
    print(response);
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
destroyAuth(body) async {
  print(API_AUTH_URL);
  Map<String, String> headers={'Authorization':body};
  try{
    var response = await http.delete(API_AUTH_URL, headers: headers);
    print(response.body);

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
startAuth(body) async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  // Await the http get response, then decode the json-formatted response. headers: headers,
  /*  
    If body is a List, it's used as a list of bytes for the body of the request.
    If body is a Map, it's encoded as form fields using encoding.
    The content-type of the request will be set to "application/x-www-form-urlencoded";
    this cannot be overridden.
    encoding defaults to utf8.
  */
  print(API_AUTH_URL);
  var bytes = convert.utf8.encode(body['username']+':'+body['password']);
  var base64Str = convert.base64.encode(bytes);
  Map<String, String> headers={'Authorization':'Basic '+base64Str};
  try{
    var response = await http.put(API_AUTH_URL,headers: headers );
    if ( response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    return false;
  }

}
checkAuth() async {
  // This example uses the Google Books API to search for books about http.
  // https://developers.google.com/books/docs/overview
  // Await the http get response, then decode the json-formatted response. headers: headers,
  /*  
    If body is a List, it's used as a list of bytes for the body of the request.
    If body is a Map, it's encoded as form fields using encoding.
    The content-type of the request will be set to "application/x-www-form-urlencoded";
    this cannot be overridden.
    encoding defaults to utf8.
  */
  print(API_AUTH_URL);

  Map<String, String> headers={'Authorization':''};

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }

  try{
    var response = await http.get(API_AUTH_URL, headers: headers);
    print(response.body);
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
buyItem(body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(body);
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_TRANSACTION_URL,body:body,headers: headers);
    print(response.body);
    print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    print(e);
    return false;
  }
}
createTrn(body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_TRANSACTION_REF_URL,body:body,headers: headers);
    print(response.body);
    print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    print(e);
    return false;
  }
}
verifyTrn(trnRef)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.get(API_TRANSACTION_REF_URL+'/'+trnRef,headers: headers);
    print(response.body);
    print(response.request.url);
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

fetchTrn({id=false})async{
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
      response = await http.get(API_TRANSACTION_URL +'/'+ id.toString() , headers: headers);
    }else{
      response = await http.get(API_TRANSACTION_URL , headers: headers);
    }
//    print(response.body);
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



// account

fetchAccount({id=false})async{
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
      response = await http.get(API_ACCOUNT_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_ACCOUNT_URL , headers: headers);
    }
    print(API_ACCOUNT_URL);
    print(response.body);
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