import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class MovieShow extends StatefulWidget {
  @override
  _MovieShowState createState() => _MovieShowState();
}

class _MovieShowState extends State<MovieShow> {

  // 热映列表
  List _hotShowList = [];

  // 即将上映列表
  List _comingSoonList = [];

  // 当前热映列表
  // 热映列表：1，即将上映2
  int _currentTabIndex = 1;

  @override
  void initState() { 
    super.initState();
    _getHotShowList();
  }

  // 获取热映列表
  _getHotShowList()async{
    var params = {
      "start":0,
      "count":6,
      "apikey":ApiConfig.apiKey
    };
    try{
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/in_theaters', params);
      if(res.data['subjects'].length > 0){
        setState(() {
         _hotShowList = res.data['subjects'];
        });
      }
      print(res.data);
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                     _currentTabIndex = 1;
                    });
                  },
                  child: Text('即将热映',style: TextStyle(fontSize: 18,color: _currentTabIndex == 1 ? Colors.black:Colors.grey)),
                ),
                SizedBox(width: ScreenAdapter.width(20)),
                GestureDetector(
                  onTap: (){
                    setState(() {
                     _currentTabIndex = 2;
                    });
                  },
                  child: Text('正在上映',style: TextStyle(fontSize: 18,color: _currentTabIndex == 2 ? Colors.black:Colors.grey)),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  child: Text('全部 32'),
                ),
                Icon(Icons.chevron_right)
              ],
            )
          ],
        ),
        GridView.count(
            shrinkWrap:true,
            //主轴间隔
            mainAxisSpacing: 4.0,
            //横轴间隔
            crossAxisSpacing: 4.0,
            crossAxisCount: 3,
            //宽高比
            children: [
              Text('x'),
              Text('x'),
              Text('x'),
              Text('x'),
              Text('x'),
            ],
        ),
      ],
    ); 
  }
}