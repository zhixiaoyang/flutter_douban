import './route_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  // 配置路径
  // tab
  static String root = "/";
  static String movieDetail = "/movieDetail";
  static String theatricalFilm = "/theatricalFilm";
  static String doubanHot = "/doubanHot";
  static String publicPraiseList = "/publicPraiseList";
  
  // 路由配置
  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
    });
    // 配置 对应路径名称和routerHnalde.dart
    router.define(root, handler:tabHandler);
    router.define(movieDetail, handler:movieDetailHandler);
    router.define(theatricalFilm, handler:theatricalFilmHandler);
    router.define(doubanHot, handler:doubanHotHandler);

  }
}