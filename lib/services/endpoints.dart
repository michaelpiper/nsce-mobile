import '../utils/helper.dart';

const BASE_URL =
    isInDebugMode ? "http://10.0.2.2:9000" : "https://www.nsce.com.ng";
const API_URL =
    isInDebugMode ? "http://10.0.2.2:3001/v1" : "https://api.nsce.com.ng/v1";
//const BASE_URL = "https://www.nsce.com.ng";
//const API_URL = "https://api.nsce.com.ng/v1";
const String API_BILLING_ADDRESS = API_URL + '/billingaddress';
const String API_SHIPPING_ADDRESS = API_URL + '/shippingaddress';
const String API_AUTH_URL = API_URL + "/auth";
const String API_TRANSACTION_URL = API_URL + "/transactions";
const String API_TRANSACTION_REF_URL = API_URL + "/reference";
const String API_ACCOUNT_URL = API_URL + "/account";
const String API_TYPE_URL = API_URL + "/categories";
const String API_QUARRIES_URL = API_URL + "/quarries";
const String API_CART_URL = API_URL + "/cart";
const String API_SCHEDULE_URL = API_URL + "/cart/schedule";
const String API_CHECKOUT_URL = API_URL + "/checkout";
const String API_ORDER_URL = API_URL + "/orders";
const String API_ORDER_TRNREF_URL = API_ORDER_URL + "/trnref";
const String API_FAVORITE_ITEMS_URL = API_URL + "/favorite-items";
const String API_DISPATCH_URL = API_URL + "/dispatches";
const String API_PRODUCT_URL = API_URL + "/products";
const String API_ADVERT_URL = API_URL + "/adverts";
const String API_NOTIFICATION_URL = API_URL + "/notifications";
const String API_SERVICE_URL = API_URL + "/service";
const String API_SERVICE_DISTANCE_URL = API_SERVICE_URL + '/distance';
const API_SEND_MAIL_URL = API_URL + '/sendmail';
const String API_AUTO_COMPLETE_ADDRESS_URL =
    API_SERVICE_URL + "/auto_complete_address";
