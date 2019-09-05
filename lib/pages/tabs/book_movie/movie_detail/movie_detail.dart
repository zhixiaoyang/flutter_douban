import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_grade.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_head.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_plot.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:palette_generator/palette_generator.dart';


class MovieDetail extends StatefulWidget {

  final String movieId;

  MovieDetail({this.movieId});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {

  // 电影详情内容
  Map _movie;
  // 主题颜色
  Color _themeColor;
  Color _detailThemeColor;

  @override
  void initState() { 
    super.initState();
    _getDetail();
  }
  // 获取电影详情
  _getDetail() async{
    try{
      var params = {
        "apikey":ApiConfig.apiKey
      };
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/subject/${widget.movieId}', params);
      // 今日播放主题颜色
      var paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(res.data['images']['small'])
      );
      setState(() {
       _movie = res.data; 
       _themeColor = paletteGenerator.colors.toList()[1];
       _detailThemeColor = paletteGenerator.colors.toList()[0];
      });
      print(res);
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _themeColor != null ? Theme(
      data: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
          subhead: TextStyle(color: Colors.white),
          title: TextStyle(color: Colors.white),
        )
      ),
      child: Scaffold(
        backgroundColor: _themeColor,
        appBar: AppBar(
          title: Text('电影'),
          backgroundColor: _themeColor,
        ),
        body: ListView(
          children: <Widget>[
            // 详情头部
            DetailHead(_movie),
            // 豆瓣评分
            DetailGrade(_movie,_themeColor,_detailThemeColor),
            // 剧情简介
            DetailPlot(_movie)
          ],
        ),
      ),
    ):Scaffold(
      body: BaseLoading(),
    );
  }
}