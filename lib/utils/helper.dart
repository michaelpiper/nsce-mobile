import '../services/endpoints.dart';
import 'package:flutter/foundation.dart';
bool get isInDebugMode{
  const bool inDebugMode=true;
  if(kReleaseMode)
    return kReleaseMode;
  return inDebugMode;
}

String baseURL(String path,{replace:false}){
  if(path==null){
    path='';
  }
  else if(path.length>=7){
    if ( path.indexOf("https://")>=0){
      if(replace){
        path = path.replaceFirst("https://", '').split('/')[1]??'';
      }else {
        return path;
      }
    }
    else if (replace &&  path.indexOf("http://")>=0){
      if(replace) {
        path = path.replaceFirst("http://", '').split('/')[1] ?? '';
      }else {
        return path;
      }
    }
    return (path.substring(0,1)=='/')?BASE_URL+path:BASE_URL+'/'+path;
  }else{
    return (path.indexOf('/')==0)?BASE_URL+path:BASE_URL+'/'+path;
  }
}

double percentage(num amount,num per,{divider:100}){
  return amount - ((amount/divider)*per);
}