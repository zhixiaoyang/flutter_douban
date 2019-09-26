
import 'package:dio/dio.dart';

class ApiConfig {

  static String baseUrl = 'https://api.douban.com'; 
  static String apiKey = '0b2bdeda43b5688921839c8ecb20399b'; 

  static ajax(type,url,params) async {
    try{
      var res ;
      switch (type) {
        case 'get':
          res = await Dio().get(url,queryParameters: params);
          break;
        case 'post':
          res = await Dio().post(url,data: params);
          break;
        default:
      }
      return res;
    } 
    catch(e){ 
      print(e);
    }
  }

}