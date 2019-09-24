import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
class MovieTopDetail extends StatefulWidget {
  @override
  _MovieTopDetailState createState() => _MovieTopDetailState();
}

class _MovieTopDetailState extends State<MovieTopDetail> {

  // 一周口碑电影榜
  Map _weekPraise;
  String _requestStatus = '';

  // 获取一周口碑电影榜
  _getWeekPraiseList()async{

    try {
      Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/subject_collection/movie_weekly_best/items?start=0&count=20&for_mobile=1', options: Options(
      headers: {
          HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
        },
      ));
      if(mounted){
        setState(() {
          _weekPraise = res.data; 
          _requestStatus = '获取豆瓣榜单详情页成功';
        });
      }
    } catch (e) {
      if(mounted){
        setState(() {
          _requestStatus = '获取豆瓣榜单详情页失败';
        });
      }
    }

  }

  @override
  void initState() { 
    super.initState();
    _getWeekPraiseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _requestStatus.isNotEmpty ?  NestedScrollView(
        headerSliverBuilder: (context,val){
          return [
            SliverAppBar(
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('${_weekPraise['subject_collection']['name']}'),
              ),
            )
          ];
        },
        body: Text('x'),
      ):BaseLoading(type: _requestStatus),
    );
  }
}