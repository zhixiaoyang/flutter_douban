import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class MovieHot extends StatefulWidget {
  @override
  _MovieHotState createState() => _MovieHotState();
}

class _MovieHotState extends State<MovieHot> {

  // 热门电影列表
  List _movieHot  = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }
  
  // 获取数据
  _getData()async{
   try{
      var params = {
      "type":'movie',
      "tag":'热门',
      "page_limit":6,
      "page_start":0
    };
    var res = await ApiConfig.ajax('get', 'https://movie.douban.com/j/search_subjects', params);
    setState(() {
     _movieHot = res.data['subjects']; 
    });
   }
   catch(e){

   }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('豆瓣热门',style: TextStyle(fontSize: 20,color:Colors.black,fontWeight: FontWeight.w600)),
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
        SizedBox(height: ScreenAdapter.height(20)),
        GridView(
          shrinkWrap: true,
          physics:NeverScrollableScrollPhysics() ,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 3,
            //纵轴间距
            //横轴间距
            crossAxisSpacing: 10.0,
            //子组件宽高长度比例
            childAspectRatio: ScreenAdapter.getScreenWidth() / 3 /  ScreenAdapter.height(480)
          ),
          children: _movieHot.map((item){
            return Container(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    child: Image.network('${item['cover']}',
                    width: double.infinity,
                    height:ScreenAdapter.height(300),fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenAdapter.height(10),bottom: ScreenAdapter.height(10)),
                    alignment: Alignment.centerLeft,
                    child: Text('${item['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600)),
                  ),
                  Row(
                      children: <Widget>[
                        RatingBarIndicator(
                          rating:double.parse(item['rate']) / 2,
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
                        Text('${item['rate']}',style: TextStyle(fontSize: 11,color: Colors.grey))
                      ],
                    )
                  ],
                ),
              );
          }).toList(),
        )
      ],
    );
  }
}