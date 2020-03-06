import '../services/endpoints.dart';
bool get isInDebugMode{
  bool inDebugMode=false;
  assert(inDebugMode=true);
  return inDebugMode;
}

String baseURL(String path,{replace:false}){
  if(path.substring(0,8)=="https://" || path.substring(0,7)=="http://"){
    if(replace){
      path = path.replaceFirst("https://", '').replaceFirst("http://", '').split('/')[1]??'';
    }else{
      return path;
    }
  }
  return (path.substring(0,1)=='/')?BASE_URL+path:BASE_URL+'/'+path;
}

double percentage(num amount,num per,{divider:100}){
  return amount - ((amount/divider)*per);
}