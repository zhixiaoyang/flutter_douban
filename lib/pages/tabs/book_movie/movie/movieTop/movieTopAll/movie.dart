import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';

class MovieTopAllMovie extends StatefulWidget {
  @override
  _MovieTopAllMovieState createState() => _MovieTopAllMovieState();
}

class _MovieTopAllMovieState extends State<MovieTopAllMovie> {

  List _mock = [
    '我和我的祖国',
    '我和我的祖国',
    '我和我的祖国',
  ];
  String _requestStatus = '';
  // 榜单数据
  Map _praiseTop;
  Map _hotTop;
  Map _top250;

  @override
  void initState() { 
    super.initState();
    // 获取榜单数据
    _getTopData();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.width(30)),
      child: _requestStatus.isNotEmpty ?  ListView(
        children: <Widget>[
          _item(_praiseTop),
          _item(_hotTop),
          _item(_top250),
        ],
      ):BaseLoading(type: _requestStatus),
    );
  }

  // 单个
  Widget _item(data){
    return Container(
      margin: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black38,
      ),
      height: ScreenAdapter.height(150),
      child: Row(
        children: <Widget>[
           _title(
            iconFgImage:data['icon_fg_image'],
            mediumName:data['medium_name'],
            typeText:data['type_text'],
          ),
          Expanded(
            child: _content(
              data:data['items'].sublist(0,3),
              bg:data['header_bg_image'],
              bgColor:data['background_color_scheme']['primary_color_dark']
            ),
          ),
        ],
      ),
    );
  }

  // 左侧头部
  Widget _title({iconFgImage,typeText,mediumName}){
    print(iconFgImage != null);
    return Container(
      width: ScreenAdapter.width(170),
      child: iconFgImage == null ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('$mediumName',style: TextStyle(color: Colors.grey[200])),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          Container(
            child: Text('$typeText',style: TextStyle(fontSize: 20)),
          )
        ],
      ):Image.network('$iconFgImage',fit: BoxFit.cover),
    );
  }

    // 中间内容
  Widget _content({data,bg,bgColor}){
    return Container(
      child:Stack(
        children: <Widget>[
          Image.network('$bg',fit: BoxFit.cover,width: ScreenAdapter.getScreenWidth()),
          Opacity(
            child: Container(
              color: Color(int.parse('0xff'+bgColor))
            ),
            opacity: 0.7,
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenAdapter.width(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:data.asMap().keys.map<Widget>((index){
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: ScreenAdapter.height(5)),
                  child: Text('${index+1}.${data[index]['title']}'),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }


}