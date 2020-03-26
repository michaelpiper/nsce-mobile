import '../utils/helper.dart';


String get BASE_URL {
//  if(isInDebugMode){
//    return "http://192.168.43.40:9000";
//  }else{
    return "https://www.nsce.com.ng";
//  }
}
String get API_URL {
//  if (isInDebugMode) {
//    return "http://192.168.43.40:3001/v1";
//  }
//  else {
    return "https://api.nsce.com.ng/v1";
//  }
}
final String API_AUTH_URL=API_URL+"/auth";
final String API_TRANSACTION_URL=API_URL+"/transactions";
final String API_TRANSACTION_REF_URL=API_URL+"/reference";
final String API_ACCOUNT_URL=API_URL+"/account";
final String API_TYPE_URL=API_URL+"/categories";
final String API_QUARRIES_URL=API_URL+"/quarries";
final String API_CART_URL=API_URL+"/cart";
final String API_SCHEDULE_URL=API_URL+"/cart/schedule";
final String API_CHECKOUT_URL=API_URL+"/checkout";
final String API_ORDER_URL=API_URL+"/orders";
final String API_ORDER_TRNREF_URL=API_ORDER_URL+"/trnref";
final String API_FAVORITE_ITEMS_URL=API_URL+"/favorite-items";
final String API_DISPATCH_URL=API_URL+"/dispatches";
final String API_PRODUCT_URL=API_URL+"/products";
final String API_ADVERT_URL=API_URL+"/adverts";
final String API_NOTIFICATION_URL=API_URL+"/notifications";
final String API_SERVICE_URL=API_URL+"/service";
final String API_AUTO_COMPLETE_ADDRESS_URL = API_SERVICE_URL+"/auto_complete_address";