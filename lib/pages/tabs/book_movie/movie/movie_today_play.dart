import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:palette_generator/palette_generator.dart';
class MovieTodayPlay extends StatefulWidget {


  @override
  _MovieTodayPlayState createState() => _MovieTodayPlayState();
}

class _MovieTodayPlayState extends State<MovieTodayPlay> {

  // 今日播放主题颜色
  Color _todayPlayThemeColor;

  // 今日播放列表
  List _todayPlayList = [];

  String _requestStatus;

  @override
  void initState() { 
    super.initState();
    // 获取今日播放
    _getTodayMovie();
  }

  // 获取今日播放
  _getTodayMovie()  async{
    try{
      var params = {
        'apikey':ApiConfig.apiKey,
        'start':Random().nextInt(200),
        'count':4
      };
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/top250', params);
      if(res.data['count'] > 0){
        // 今日播放主题颜色
        var paletteGenerator = await PaletteGenerator.fromImageProvider(
          NetworkImage(res.data['subjects'][0]['images']['small'])
        );
        setState(() {
          _todayPlayThemeColor =  paletteGenerator.colors.toList()[0];
          _todayPlayList = res.data['subjects']; 
        });
      }else{
        setState(() {
          _requestStatus = '暂无今日播放'; 
        });
      }
    }
    catch(e){
      print(e);
      setState(() {
        _requestStatus = '暂无数据'; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _todayPlayList.length > 0  ? Container(
      margin: EdgeInsets.only(top: ScreenAdapter.height(30)),
      height: ScreenAdapter.height(350),
      child:  Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ScreenAdapter.width(20)),
              color: _todayPlayThemeColor,
            ),
            width: double.infinity,
            height: ScreenAdapter.height(300),
          ),
          Positioned(
            left: ScreenAdapter.width(160),
            bottom: ScreenAdapter.width(45),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network('${_todayPlayList[2]['images']['small']}',fit: BoxFit.fill),
              ),
              width:ScreenAdapter.width(260),
              height: ScreenAdapter.height(220),
            ),
          ),
          Positioned(
            left: ScreenAdapter.width(100),
            bottom: ScreenAdapter.width(45),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network('${_todayPlayList[1]['images']['small']}',fit: BoxFit.fill),
              ),
              width:ScreenAdapter.width(260),
              height: ScreenAdapter.height(260),
            ),
          ),
          Positioned(
            left: ScreenAdapter.width(40),
            bottom: ScreenAdapter.width(45),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network('${_todayPlayList[0]['images']['small']}',fit: BoxFit.fill),
              ),
              width:ScreenAdapter.width(260),
              height: ScreenAdapter.height(300),
            ),
          ),
          Positioned(
            right: ScreenAdapter.width(15),
            bottom: ScreenAdapter.width(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.movie_filter,color: Colors.white,size: 17),
                SizedBox(width: ScreenAdapter.width(6)),
                Text('看电影',style: TextStyle(color: Colors.white,fontSize: 12))
              ],
            ),
          ),
        ],
      ),
    ):Container(
      height: ScreenAdapter.height(350),
      child: BaseLoading(type:_requestStatus),
    );
  }
}