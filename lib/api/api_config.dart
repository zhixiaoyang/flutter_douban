
import 'package:dio/dio.dart';

class ApiConfig {

  static String baseUrl = 'https://api.douban.com'; 
  static String apiKey = '0df993c66c0c636e29ecbb5344252a4a'; 

  static ajax(type,url,params) async {
    try{
      var res ;
      Options options = Options(
        contentType : "json"
      );
      switch (type) {
        case 'get':
          res = await Dio().get(url,queryParameters: params,options:options);
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