import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';
import '../utils/constants.dart';
createAuth(Map<String,String> body) async {
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
  try{
    var response = await http.post(API_AUTH_URL, body: body );
    // print(response);
    // print(response.request);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
     return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
destroyAuth(body) async {
  // print(API_AUTH_URL);
  Map<String, String> headers={'Authorization':body};
  try{
    var response = await http.delete(API_AUTH_URL, headers: headers);
    // print(response.body);

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
  // print(API_AUTH_URL);
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
    // print(e);
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
//    // print(response.body);
    // print(response.request.url);
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
recoverAuth(body)async{
  Map<String, String> headers={};
  try{
    var response = await http.patch(API_AUTH_URL,body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
sendMail(Map<String,String> body)async{
  Map<String, String> headers={};
  try{
    var response = await http.post(API_SEND_MAIL_URL,body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
buyItem(body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(body);
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_TRANSACTION_URL,body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
//trn
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
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
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
    // print(response.body);
    // print(response.request.url);
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
//    // print(response.body);
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
//    // print(API_ACCOUNT_URL);
//    // print(response.body);
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

updateAccount(Map body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.put(API_ACCOUNT_URL , headers: headers,body:body);
    // print(response.request.url);
//    // print(response.body);
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
patchAccount(Map body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.patch(API_ACCOUNT_URL , headers: headers,body:body);
    // print(response.request.url);
//    // print(response.body);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
//type

fetchTypes({id=false})async{
  Map<String, String> headers={};
  try{
    var response;
    if(id!=false) {
      response = await http.get(API_TYPE_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_TYPE_URL , headers: headers);
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
fetchTypeProducts(id)async{
  Map<String, String> headers={};
  try{
    var response = await http.get(API_TYPE_URL + '/' + id.toString()+'/products', headers: headers);
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


//products

fetchProducts({id=false})async{
  Map<String, String> headers={};
  try{
    var response;
    if(id!=false) {
      response = await http.get(API_PRODUCT_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_PRODUCT_URL , headers: headers);
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
fetchProductWithParent(id)async{
  Map<String, String> headers={};
  try{
    var response = await http.get(API_PRODUCT_URL + '/' + id.toString()+'/with-parent', headers: headers);

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
fetchProductWithParents(id)async{
  Map<String, String> headers={};
  try{
    var  response = await http.get(API_PRODUCT_URL + '/' + id.toString()+'/with-parents', headers: headers);

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
searchProducts(query)async{
  Map<String, String> headers={};
  try{
    var response = await http.get(API_PRODUCT_URL + '/search/' + query.toString(), headers: headers);
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

//order
fetchOrders({id=false})async{
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
      response = await http.get(API_ORDER_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_ORDER_URL , headers: headers);
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

fetchOrderDispatch({id=false})async{
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
      response = await http.get(API_DISPATCH_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_DISPATCH_URL , headers: headers);
    }
    // print(response.request.url);
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

fetchOrderWithDispatches({id=false})async{
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
      response = await http.get(API_ORDER_URL + '/' + id.toString()+'/with-dispatches', headers: headers);
    }
    else {
      response = await http.get(API_DISPATCH_URL , headers: headers);
    }
    // print(response.request.url);
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

//fetch adverts

fetchAdverts({id=false})async{
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
      response = await http.get(API_ADVERT_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_ADVERT_URL , headers: headers);
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

scheduleOrder(body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(body);
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_SCHEDULE_URL,body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
// cart
addToCart(body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // print(body);
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_CART_URL,body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
fetchCart({id=false})async{
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
      response = await http.get(API_CART_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_CART_URL , headers: headers);
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
fetchCartWithParent(id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.get(API_CART_URL + '/' + id.toString()+'/with-parent', headers: headers);

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
fetchCartWithParents(id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var  response = await http.get(API_CART_URL + '/' + id.toString()+'/with-parents', headers: headers);

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

destroyCart(id) async {
  // print(API_CART_URL);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.delete(API_CART_URL+'/'+id.toString(), headers: headers);
    // print(response.body);
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
// fetch favorite-items
fetchFavoriteItems({id=false})async{
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
      response = await http.get(API_FAVORITE_ITEMS_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_FAVORITE_ITEMS_URL , headers: headers);
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
addToFavoriteItems(String id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_FAVORITE_ITEMS_URL,body:{'productId':id},headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
removeFromFavoriteItems(String id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.delete(API_FAVORITE_ITEMS_URL+'/'+id,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
//add quarries

fetchQuarries({id=false})async{
  Map<String, String> headers={};
  try{
    var response;
    if(id!=false) {
      response = await http.get(API_QUARRIES_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_QUARRIES_URL , headers: headers);
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
fetchQuarryLike({id=false})async{
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
      response = await http.get(API_QUARRIES_URL + '/' + id.toString()+'/like', headers: headers);
    }
    else {
      response = await http.get(API_QUARRIES_URL , headers: headers);
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
likeQuarries(String id,Map<String,String> body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_QUARRIES_URL+'/'+id.toString()+'/like',body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
unlikeQuarries(String id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.delete(API_QUARRIES_URL+'/'+id.toString()+'/like',headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
// fetch Notifications
fetchNotifications({id=false})async{
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
      response = await http.get(API_NOTIFICATION_URL + '/' + id.toString(), headers: headers);
    }
    else {
      response = await http.get(API_NOTIFICATION_URL , headers: headers);
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
markAsReadNotifications(id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_NOTIFICATION_URL+ '/' + id.toString(),headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
markAsUnreadNotifications(id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.delete(API_NOTIFICATION_URL+ '/' + id.toString(),headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}


searchAddress(String address)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.get(API_AUTO_COMPLETE_ADDRESS_URL + '/?address=' + address, headers: headers);

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

fetchOrderLike({id=false})async{
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
      response = await http.get(API_ORDER_URL + '/' + id.toString()+'/like', headers: headers);
    }
    else {
      response = await http.get(API_ORDER_URL , headers: headers);
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
likeOrders(String id,Map<String,String> body)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.post(API_ORDER_URL+'/'+id.toString()+'/like',body:body,headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}
unlikeOrders(String id)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> headers={};
  if(prefs.containsKey(STORAGE_USER_KEY)) {
    var wait = convert.jsonDecode(prefs.getString(STORAGE_USER_KEY));
    if(wait.containsKey('authorization')) {
      headers['Authorization']=wait['authorization'];
    }
  }
  try{
    var response = await http.delete(API_ORDER_URL+'/'+id.toString()+'/like',headers: headers);
    // print(response.body);
    // print(response.request.url);
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return false;
    }
  }
  catch(e){
    // print(e);
    return false;
  }
}


