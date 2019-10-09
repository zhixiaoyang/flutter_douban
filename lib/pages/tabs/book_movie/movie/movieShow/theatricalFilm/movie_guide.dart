import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class MovieGuide extends StatefulWidget {
  @override
  _MovieGuideState createState() => _MovieGuideState();
}

class _MovieGuideState extends State<MovieGuide> with AutomaticKeepAliveClientMixin{

  bool get wantKeepAlive => false;

  String _requestStatus = '';


  @override
  void initState() { 
    super.initState();
    _getMovieGuide();
  }
  // 获取观影指南数据
  _getMovieGuide()async{
     try{
      Options option = Options(
        headers: {
          HttpHeaders.refererHeader: 'https://frodo.douban.com',
        },
      );
      Response res = await Dio().get('https://frodo.douban.com/api/v2/subject_collection/movie_monthly_recommend/items?start=0&count=18&udid=719d2581f4bff5f7cf575dd402c6d1f5017e80c6&rom=os&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Baidu_Market&device_id=719d2581f4bff5f7cf575dd402c6d1f5017e80c6&os_rom=android&apple=9d2ccd460de921942f2015930cac1739&icecream=6ec621ab108734be3ca493d9e0314db3&mooncake=bfcfd9f4cda583e946cf87a2e8279ff7&loc_id=108288&_sig=GaJPDh%2Bu52qtPsu4JNns7Qu34uY%3D&_ts=1570613172',options:option);
      print(res.data);
      
      if(mounted){
        setState(() {
          _requestStatus = '获取年度豆瓣榜单成功';
        });   
      }
    }
    catch(e){
      print(e);
      if(mounted){
        setState(() {
          _requestStatus = '获取年度豆瓣榜单失败'; 
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            color: Color(int.parse('0xffFFF3E0')),
            padding: EdgeInsets.all(ScreenAdapter.width(30)),
            child: Text('豆瓣为你整理出当月最值得看的院线电影。点击"想看"来收藏喜欢的电影，当影片上映、有播放源时会通知你。',style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }
}