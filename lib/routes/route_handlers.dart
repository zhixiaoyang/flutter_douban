import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/pages/doubanHot/douban_hot.dart';
import 'package:flutter_jahn_douban/pages/publicPraiseList/public_praise_list.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/movie_detail.dart';
import 'package:flutter_jahn_douban/pages/tabs/tabs.dart';
import 'package:flutter_jahn_douban/pages/theatricalFilm/theatrical_film.dart';

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

// 院线电影页
Handler theatricalFilmHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    int index = int.parse( params['index']?.first);
  return TheatricalFilm(index:index);
});

// 豆瓣热门页
Handler doubanHotHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return DoubanHot();
});

// 一周口碑电影榜单
Handler publicPraiseListHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return PublicPraiseList();
});