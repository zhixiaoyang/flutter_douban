import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class IsHit extends StatefulWidget {
  @override
  _IsHitState createState() => _IsHitState();
}

class _IsHitState extends State<IsHit> {

  // 正在热映列表
  Map _isHitList;
  // 分页
  int _start = 0;
  String _requestStatus = '';

  @override
  void initState() { 
    super.initState();
    _getIsHit();
  }

  // 获取正在热映列表数据
  void _getIsHit() async {

    try {
      Map<String,dynamic> params ={
        'apikey':ApiConfig.apiKey,
        'count':5,
        'start':_start
      };
      var res = await ApiConfig.ajax('get',ApiConfig.baseUrl +  '/v2/movie/in_theaters', params);
      setState(() {
        _isHitList =  res.data;
      });
    }
    catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return  _isHitList != null ? ListView.builder(
      itemBuilder: (context,index){
        return Container(
          margin: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: Colors.grey[300],
              )
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 缩略图
              _thumb(_isHitList['subjects'][index]), 
              // 中间信息区域
              SizedBox(width: ScreenAdapter.width(30)),
              _info(_isHitList['subjects'][index]),
              // 右侧操作区域
              _actions()
            ],
          ),
        );
      },
      itemCount: _isHitList.length,
    ):BaseLoading(type: _requestStatus);
  }
  // 右侧操作区域
  Widget _actions(){
    return Container(
      height: ScreenAdapter.height(240),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){

            },
            child: Container(
              padding: EdgeInsets.only(left: ScreenAdapter.width(30),right: ScreenAdapter.width(30),top: ScreenAdapter.width(8),bottom: ScreenAdapter.width(8)),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,color: Colors.pink
                ),
                borderRadius: BorderRadius.circular(3)
              ),
              child: Text('购票',style: TextStyle(fontSize: 13,color: Colors.pink)),
            ),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          Text('20W人看过',style: TextStyle(fontSize: 10,color: Colors.grey))
        ],
      )
    );
  }
  // 左侧缩略图
  Widget _thumb(item){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network('${item['images']['small']}',width: ScreenAdapter.width(200),height: ScreenAdapter.height(240),fit: BoxFit.cover,),
    );
  }

  // 中间信息区域
  Widget _info(item){
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          minHeight: ScreenAdapter.height(260)
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
              child: Text('${item['title']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
              child: Row(
                children: <Widget>[
                  RatingBarIndicator(
                    rating:item['rating']['average'] / 2,
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
                  SizedBox(width: ScreenAdapter.width(15)),
                  Text('${item['rating']['average']}',style: TextStyle(color: Colors.grey,fontSize: 12))
                ],
              )
            ),
            Container(
              margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
              child: Text('${item['year']} / ${item['genres'][0]} / ${item['mainland_pubdate']}上映 / 片长${item['durations'][0]}',style: TextStyle(fontSize: 12,color: Colors.grey)),
            ),
          ],
        ),
      ), 
    );
  }


}