import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieShow extends StatefulWidget {
  @override
  _MovieShowState createState() => _MovieShowState();
}

class _MovieShowState extends State<MovieShow> {

  // 热映列表
  List _hotShowList = [];

  // 即将上映列表
  List _comingSoonList = [];
  
  // 热映列表total
  int _hotShowTotal = 0;

  // 正在上映列表total
  int _comingSoonTotal = 0;


  // 当前热映列表
  // 热映列表：1，即将上映2
  int _currentTabIndex = 1;

  @override
  void initState() { 
    super.initState();

    // 获取热映列表
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
         _hotShowTotal = res.data['count'];
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
    return ListView(
      shrinkWrap:true,   
      physics: NeverScrollableScrollPhysics(),  
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
        SizedBox(height: ScreenAdapter.height(30)),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _hotShowList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 3,
            //纵轴间距
            //横轴间距
            crossAxisSpacing: 10.0,
            //子组件宽高长度比例
            childAspectRatio: ScreenAdapter.getScreenWidth() / 3 /  ScreenAdapter.height(480)
          ),
          itemBuilder: (BuildContext context, int index) {
            //Widget Function(BuildContext context, int index)
            return Container(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    child: Image.network('${_hotShowList[index]['images']['small']}',
                    width: double.infinity,
                    height:ScreenAdapter.height(300),fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.height(10),bottom: ScreenAdapter.height(10)),
                    alignment: Alignment.centerLeft,
                    child: Text('${_hotShowList[index]['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)),
                  ),
                  Row(
                    children: <Widget>[
                      RatingBarIndicator(
                        rating:_hotShowList[index]['rating']['average'] / 2,
                        alpha:0,
                        unratedColor:Colors.grey,
                        itemPadding: EdgeInsets.all(0),
                        itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 11,
                      ),
                      SizedBox(width: ScreenAdapter.width(20)),
                      Text('${_hotShowList[index]['rating']['average']}',style: TextStyle(fontSize: 11,color: Colors.grey))
                    ],
                  )
                ],
              ),
            );
          }
        ),
        // GridView.count(
        //     shrinkWrap:true,
        //     physics: NeverScrollableScrollPhysics(), 
        //     //主轴间隔
        //     mainAxisSpacing: ScreenAdapter.width(20),
        //     //横轴间隔
        //     crossAxisSpacing:  ScreenAdapter.height(20),
        //     // 宽高比
        //     childAspectRatio:2.8/5,
        //     crossAxisCount: 3,
        //     //宽高比
        //     children:_hotShowList.map((item){
        //       return Container(
        //         child: Column(
        //           children: <Widget>[
        //             Image.network('${item['images']['small']}',width: double.infinity,height:ScreenAdapter.height(300),fit: BoxFit.fill),
        //             Container(
        //               margin: EdgeInsets.only(top: ScreenAdapter.height(10),bottom: ScreenAdapter.height(10)),
        //               alignment: Alignment.centerLeft,
        //               child: Text('${item['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)),
        //             ),
        //             Row(
        //               children: <Widget>[
        //                 RatingBarIndicator(
        //                   rating:item['rating']['average'] / 2,
        //                   alpha:0,
        //                   unratedColor:Colors.grey,
        //                   itemPadding: EdgeInsets.all(0),
        //                   itemBuilder: (context, index) => Icon(
        //                       Icons.star,
        //                       color: Colors.amber,
        //                   ),
        //                   itemCount: 5,
        //                   itemSize: 11,
        //                 ),
        //                 SizedBox(width: ScreenAdapter.width(20)),
        //                 Text('${item['rating']['average']}',style: TextStyle(fontSize: 11,color: Colors.grey))
        //               ],
        //             )
        //           ],
        //         ),
        //       );
        //     }).toList(),
        // ),
      ],
    ); 
  }
}