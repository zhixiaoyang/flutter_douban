import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/pages/launchPage/launch_page.dart';
import 'package:flutter_jahn_douban/pages/tabs/tabs.dart';
import 'package:flutter_jahn_douban/routes/application.dart';
import 'package:flutter_jahn_douban/routes/routes.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   // 初始化fluro实例
   final router = Router();
   Routes.configureRoutes(router);
   Application.router = router;
    return MaterialApp(
      home: Tabs(),
      // 去掉debug
      debugShowCheckedModeBanner: false,
    );
  }
}

