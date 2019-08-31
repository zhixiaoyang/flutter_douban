import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_category.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_show.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_today_play.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(30), ScreenAdapter.width(40), ScreenAdapter.width(30), ScreenAdapter.width(40)),
      child: ListView(
        children: <Widget>[
          // 顶部分类
          MovieCategory(),
          // 今日播放
          MovieTodayPlay(),
          SizedBox(height: ScreenAdapter.height(40)),
          // 上映
          MovieShow()
        ],
      ),
    );
  }
}