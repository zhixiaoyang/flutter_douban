import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/movie_detail.dart';
import 'package:flutter_jahn_douban/pages/tabs/tabs.dart';

// 配置清单路由
// tabs
Handler tabHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Tabs();
});

// 电影详情页
Handler movieDetailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String movieId = params['id']?.first;
  return MovieDetail(movieId:movieId);
});