import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_jahn_douban/weiget/topItems/default_top_item.dart';
import 'package:flutter_jahn_douban/weiget/topItems/year_top_item.dart';

class MovieTopAllMovie extends StatefulWidget {
  @override
  _MovieTopAllMovieState createState() => _MovieTopAllMovieState();
}

class _MovieTopAllMovieState extends State<MovieTopAllMovie> with AutomaticKeepAliveClientMixin {

  bool get wantKeepAlive => false; 

  String _requestStatus = '';
  String _requestYearTopStatus = '';

  // 榜单数据
  Map _praiseTop;
  Map _hotTop;
  Map _top250;
  // 年度榜单
  Map _yearTop = {
    'highRateChinaMovie':{},
    'highRateForeignMovie':{},
    'notInPopular':{},
  };
  // 高分榜 - 爱情片
  Map _loveData;

  @override
  void initState() { 
    super.initState();
    // 获取榜单数据
    _getTopData();
    // 获取年度榜单
    _getYearTop();
    // 高分榜
    _geLoveData();
  }
  // 获取年度榜单
  _getYearTop()async{
    try{
      Options option = Options(
        headers: {
          HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
        },
      );
      Response highRateChinaMovie = await Dio().get('https://movie.douban.com/ithil_j/activity/movie_annual${DateTime.now().year - 1}/widget/1',options:option);
      Response highRateForeignMovie = await Dio().get('https://movie.douban.com/ithil_j/activity/movie_annual${DateTime.now().year - 1}/widget/2', options:option);
      Response notInPopular = await Dio().get('https://movie.douban.com/ithil_j/activity/movie_annual${DateTime.now().year - 1}/widget/3',options:option);
      if(mounted){
        setState(() {
          _yearTop['highRateChinaMovie'] = highRateChinaMovie.data['res'];
          _yearTop['highRateForeignMovie'] = highRateForeignMovie.data['res'];
          _yearTop['notInPopular'] = notInPopular.data['res'];
          _requestYearTopStatus = '获取年度豆瓣榜单成功';
        });   
      }
    }
    catch(e){
      print(e);
      if(mounted){
        setState(() {
          _requestYearTopStatus = '获取年度豆瓣榜单失败'; 
        });
      }
    }
  }
  // 获取数据
  _getTopData()async{
    try{
      Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/movie/modules?for_mobile=1', options: Options(
        headers: {
          HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
        },
      ));
      if(mounted){
        setState(() {
          _praiseTop = res.data['modules'][8]['data']['selected_collections'][0]; 
          _top250 = res.data['modules'][8]['data']['selected_collections'][1]; 
          _hotTop = res.data['modules'][8]['data']['selected_collections'][2]; 
          _requestStatus = '获取豆瓣榜单成功';
        });   
      }
    }
    catch(e){
      if(mounted){
        setState(() {
          _requestStatus = '获取豆瓣榜单失败'; 
        });
      }
    }
  }
  // 获取高分爱情榜
  _geLoveData()async{
    Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/subject_collection/movie_love/items?os=ios&for_mobile=1&callback=jsonp1&start=0&count=18&loc_id=0&_=1571041012653', options: Options(
      headers: {
        HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
      },
    ));
    if(mounted){
      setState(() {
        _loveData = json.decode(res.data.substring(8,res.data.length - 2));
      });
    }
    print(res.data);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(30),0,ScreenAdapter.width(30),ScreenAdapter.width(30)),
      child: ListView(
        children: <Widget>[
          // 榜单
          _requestStatus.isNotEmpty ?  Column(
            children: <Widget>[
              SizedBox(height: ScreenAdapter.height(30)),
              DefaultTopItem(_praiseTop),
              DefaultTopItem(_hotTop),
              DefaultTopItem(_top250,showTrend:false),
            ],
          ):BaseLoading(type: _requestStatus),
          // 豆瓣年度榜单
          _requestYearTopStatus.isNotEmpty ?  Column(
            children: <Widget>[
              SizedBox(height: ScreenAdapter.height(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('豆瓣年度榜单',style: TextStyle(fontSize: 24,color:Colors.black,fontWeight: FontWeight.w600)),
                  Row(
                    children: <Widget>[
                      Text('全部',style: TextStyle(color:Colors.black87,fontSize: 16)),
                      Icon(Icons.keyboard_arrow_right,color:Colors.black87)
                    ],
                  )
                ],
              ),
              SizedBox(height: ScreenAdapter.height(20)),
              YearTopItem(_yearTop['highRateChinaMovie'],'评分最高华语电影','评分最高'),
              YearTopItem(_yearTop['highRateForeignMovie'],'评分最高外语电影','评分最高'),
              YearTopItem(_yearTop['notInPopular'],'年度最佳冷片','年度电影'),
            ],
          ):BaseLoading(type: _requestYearTopStatus),
        ],
        // 高分榜
        
      )
    );
  }

}