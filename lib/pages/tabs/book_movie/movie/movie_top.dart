import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';

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
        "count":6,
        "apikey":ApiConfig.apiKey
      };
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/weekly', params);
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
        "count":6,
        "apikey":ApiConfig.apiKey
      };
      var res = await ApiConfig.ajax('get', 'https://movie.douban.com/j/search_subjects', params);
      setState(() {
      _weekMovieList = res.data['subjects']; 
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
        Container(
          height: 300,
          child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              child: Column(
                  children: <Widget>[
                    // Image.network('https://img1.doubanio.com/view/celebrity/s_ratio_celebrity/public/p1566650655.49.webp',width: 100,height: 100,),
                    Container(
                      child: Column(
                        children: _weekMovieList.map((item){
                          print(item);
                          return Row(
                            children: <Widget>[
                              Text('${item['title']}')
                            ],
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}