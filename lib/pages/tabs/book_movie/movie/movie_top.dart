import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';

class MovieTop extends StatefulWidget {
  @override
  _MovieTopState createState() => _MovieTopState();
}


class _MovieTopState extends State<MovieTop> {

  // 一周口碑电影榜
  List _weekMovieList = [];
  // 豆瓣电影top250
  List _topMovieList = [];

  // 获取豆瓣电影top250
  _getTopData()async{
    try{
      var params = {
        "start":0,
        "count":4,
        "apikey":ApiConfig.apiKey
      };
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/top250', params);
      setState(() {
        _topMovieList = res.data['subjects']; 
      });
    }
    catch(e){
      print(e);
    }
  }

  // 一周口碑电影榜
  _getWeekData() async{
    try{
      var params = {
        "start":0,
        "count":4,
        "apikey":ApiConfig.apiKey
      };
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/weekly', params);
      setState(() {
        _weekMovieList = res.data['subjects'].sublist(0,4).map((item){
          var result = item['subject'];
          result['rank'] = item['rank'];
          return result;
        }).toList(); 
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeekData();
    _getTopData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('豆瓣榜单',style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600)),
            Container(
              child: Row(
                children: <Widget>[
                  Text('全部',style: TextStyle(fontSize: 17,color:Colors.black,fontWeight: FontWeight.w600)),
                  Icon(Icons.chevron_right)
                ],
              ),
            )
          ],
        ),
        SizedBox(height: ScreenAdapter.height(30)),
        Container(
          height: ScreenAdapter.height(480),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _weekMovieList.length > 0  ? _item(_weekMovieList):BaseLoading(),
              SizedBox(width: ScreenAdapter.width(30)),
              _topMovieList.length > 0  ? _item(_topMovieList):BaseLoading(),
            ],
          ),
        )
      ],
    );
  }
  // 
  Widget _item(data){
    return Container(
      width: ScreenAdapter.width(450),
      decoration: BoxDecoration(
        color: Color.fromRGBO(74, 76, 74, 1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    child: Image.network('${data[0]['images']['small']}',width:  ScreenAdapter.width(450),fit: BoxFit.fill),borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight:Radius.circular(8) )
                ),
                Positioned(
                  bottom: ScreenAdapter.width(40),
                  left: ScreenAdapter.width(30),
                  child: Text('一周口碑电影榜',style: TextStyle(fontSize: 24,color: Colors.white)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(ScreenAdapter.width(30)),
            child: Column(
              children: data.asMap().keys.map<Widget>((index){
                return Row(
                  children: <Widget>[
                    Container(
                      child: Text('${index+1}. ${data[index]['title']}',style: TextStyle(color: Colors.white,height:1.5)),
                    ),
                    SizedBox(width: ScreenAdapter.width(30)),
                    Text('${data[index]['rating']['average']}',style: TextStyle(color: Colors.orange),)
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}