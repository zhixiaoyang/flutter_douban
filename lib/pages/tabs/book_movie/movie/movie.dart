import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_category.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_hot.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_show.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_today_play.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie/movie_top.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(height: ScreenAdapter.height(50))
        ),
        _paddingContainer(MovieCategory()),
        _paddingContainer(MovieTodayPlay()),
        _paddingContainer(MovieShow()),
        _paddingContainer(MovieHot()),
        _paddingContainer(MovieTop()),
      ],
    );
  }

  // paddin容器
  Widget _paddingContainer(child){
    return SliverPadding(
      padding:EdgeInsets.only(bottom:ScreenAdapter.width(30),left: ScreenAdapter.width(30),right: ScreenAdapter.width(30)),
      sliver: SliverToBoxAdapter(
        child: child
      ),
    );
  }

}