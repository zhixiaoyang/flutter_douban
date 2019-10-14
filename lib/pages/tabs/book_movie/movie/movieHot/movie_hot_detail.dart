import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/routes/application.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_jahn_douban/weiget/custom_scroll_footer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class MovieHotDetail extends StatefulWidget {
  @override
  _MovieHotDetailState createState() => _MovieHotDetailState();
}

class _MovieHotDetailState extends State<MovieHotDetail> {
 // 豆瓣500热映列表
  List _hotList = [];
  // 分页
  int _start = 0;
  // 总数量
  int _total = 500;
  // 筛选
  String _sort = 'recommend';
  String _requestStatus = '';
  // 搜索类型切换
  AlignmentGeometry _alignment = Alignment.centerLeft;
  // 刷新控制器
  RefreshController _controller = RefreshController();

    @override
  void initState() { 
    super.initState();
    _getDouBanHot();
  }

  // 获取豆瓣热门500列表数据
  _getDouBanHot() async {
    try {
      Map<String,dynamic> params ={
        'apikey':ApiConfig.apiKey,
        'page_limit':10,
        'page_start':_start,
        'tag':'热门',
        'type':'movie',
        'sort':_sort
      };
      Response res = await ApiConfig.ajax('get','https://movie.douban.com/j/search_subjects', params);
     
      if(mounted){
        setState(() {
          _hotList.addAll(res.data['subjects']);
        });
      }
    }
    catch (e) {
      print(e);
    }

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('豆瓣热门',style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          title:TextStyle(color: Colors.black)
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        brightness: Brightness.light,
      ),
      body: SmartRefresher(
        controller: _controller,
        enablePullUp: true,
        enablePullDown: false,
        footer: CustomScrollFooter(),
        onLoading: () async {
          if(_start + 10 < _total){
            setState(() {
              _start = _start + 10;
            });
            await _getDouBanHot();
            _controller.loadComplete();
          }else{
            _controller.loadNoData();
          }
        },
        child: _hotList.length > 0 ? ListView(
          children: <Widget>[
            Container(
              height: ScreenAdapter.height(80),
              padding: EdgeInsets.only(left: ScreenAdapter.width(30),right: ScreenAdapter.width(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('影视 $_total'),
                  // 类型切换
                  _toggleBtn()
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),top: ScreenAdapter.height(30)),
                  padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.grey[300],
                      )
                    )
                  ),
                  child:GestureDetector(
                    onTap: (){
                      Application.router.navigateTo(context, '/movieDetail?id=${_hotList[index]['id']}');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 缩略图
                        _thumb(_hotList[index]), 
                        // 中间信息区域
                        SizedBox(width: ScreenAdapter.width(30)),
                        _info(_hotList[index]),
                        SizedBox(width: ScreenAdapter.width(30)),
                        // 右侧操作区域
                        _actions(_hotList[index])
                      ],
                    ),
                  )
                );
              },
              itemCount: _hotList.length,
            )
          ],
        ):BaseLoading(type: _requestStatus),
      )
    );
  }
  
  // 左侧缩略图
  Widget _thumb(item){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network('${item['cover']}',width: ScreenAdapter.width(200),height: ScreenAdapter.height(220),fit: BoxFit.cover,),
    );
  }
  // 中间信息区域
  Widget _info(item){
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          minHeight: ScreenAdapter.height(220)
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
              child: Text('${item['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
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
                SizedBox(width: ScreenAdapter.width(15)),
                Text('${item['rate']}',style: TextStyle(color: Colors.grey,fontSize: 12))
              ],
            )
          ],
        ),
      ), 
    );
  }
  // 右侧操作区域
  Widget _actions(item){
    return Container(
      height: ScreenAdapter.height(240),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){

            },
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){

                  },
                  child: Image.network('http://cdn.jahnli.cn/favorite.png',width: ScreenAdapter.width(40)),
                ),
                SizedBox(height: ScreenAdapter.height(10)),
                Text('想看',style: TextStyle(fontSize: 12,color: Colors.orange))
              ],
            ),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          Text('${item['cover_y']}人想看',style: TextStyle(fontSize: 12,color: Colors.grey))
        ],
      )
    );
  }
  // 类型切换
  _toggleBtn(){
    return Container(
      height: ScreenAdapter.height(50),
      width: ScreenAdapter.width(150),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: ScreenAdapter.width(150),
            child: AnimatedAlign(
              alignment: _alignment,
              curve: Curves.ease,
              duration: Duration(milliseconds: 500),
              child: Opacity(
                opacity: 1,
                child: Container(
                  height: ScreenAdapter.height(50),
                  width: ScreenAdapter.width(80),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  setState(() {
                    _start = 0;
                    _hotList = [];
                    _sort = 'recommend';
                    _alignment = Alignment.centerLeft; 
                  });
                  _getDouBanHot();
                },
                child: Text('热度',style: TextStyle(fontSize: 11,color:_alignment == Alignment.centerLeft ?  Colors.black: Colors.grey[500])),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _alignment = Alignment.centerRight; 
                    _start = 0;
                    _hotList = [];
                    _sort = 'time';
                  });
                  _getDouBanHot();
                },
                child: Text('时间',style: TextStyle(fontSize: 11,color:_alignment == Alignment.centerRight ?  Colors.black: Colors.grey[500])),
              ),
            ],
          ),
        ],
      ),
    );
  }

}