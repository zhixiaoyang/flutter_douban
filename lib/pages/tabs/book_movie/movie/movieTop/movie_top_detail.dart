import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/routes/application.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieTopDetail extends StatefulWidget {
  @override
  _MovieTopDetailState createState() => _MovieTopDetailState();
}

class _MovieTopDetailState extends State<MovieTopDetail> {

  // 一周口碑电影榜
  Map _weekPraise;
  String _requestStatus = '';

  // 控制滚动
  ScrollController _scrollController = ScrollController();
  // 是否展开
  bool _isExpand = true;
  int _total;
  // 主题
  bool _isDark;
  Color _baseTextColor;

  @override
  void initState() { 
    super.initState();
    _baseTextColor = _isDark == true ? Colors.white:Colors.black;
    _getWeekPraiseList();
    // 监听滚动 控制标题栏样式
    _scrollController.addListener((){
      setState(() {
        _isExpand = _scrollController.offset > 140 ? false:true;
      });
    });
  }

  @override
  void dispose() { 
    super.dispose();
    _scrollController.dispose();
  }

  

  // 获取一周口碑电影榜
  _getWeekPraiseList()async{

    try {
      Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/subject_collection/movie_weekly_best/items?start=0&count=20&for_mobile=1', options: Options(
      headers: {
          HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
        },
      ));
      if(mounted){
        setState(() {
          _weekPraise = res.data; 
          _requestStatus = '获取豆瓣榜单详情页成功';
          _total = res.data['total'];
        });
      }
    } catch (e) {
      if(mounted){
        setState(() {
          _requestStatus = '获取豆瓣榜单详情页失败';
        });
      }
    }

  }
  // 时间筛选
  _timeFilter(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )
        ),
        builder: (BuildContext context) {
          return Container(
            height: 300,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black26,
                  ),
                  alignment: Alignment.center,
                  margin:EdgeInsets.only(top:8),
                  width: ScreenAdapter.width(60),
                  height: ScreenAdapter.width(8),
                )
              ],
            ),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _requestStatus.isNotEmpty ?  NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context,isScroll){
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color:_isExpand ? Colors.white: Colors.black
              ),
              brightness: Brightness.dark,
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedDefaultTextStyle(
                  duration: Duration(seconds:1),
                  style: TextStyle(color: _isExpand ? Colors.white:Colors.black,fontSize: 20),
                  child: Text('${_weekPraise['subject_collection']['name']}'),
                ),
                background: Container(
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Image.network('${_weekPraise['subject_collection']['header_bg_image']}',fit: BoxFit.cover,height: 200 +  MediaQuery.of(context).padding.top),
                      ),
                      Positioned(
                        top: 100,
                        left: 30,
                        child: Text('${_weekPraise['subject_collection']['description']}',style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: Container(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              // 头部操作区
              _headActions(),
              ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx,index){
                  return Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),top: ScreenAdapter.height(30)),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index == 0 ? Color.fromRGBO(225, 102, 119, 1):index == 1 ? Colors.orange :index == 2 ?  Color.fromRGBO(255, 193, 93, 1):Color.fromRGBO(209, 206, 201, 1)
                          ),
                          child: Text('No.${index+1}',style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),top: ScreenAdapter.height(30)),
                        padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                        child:GestureDetector(
                          onTap: (){
                            Application.router.navigateTo(context, '/movieDetail?id=${_weekPraise['subject_collection_items'][index]['id']}');
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // 缩略图
                              _thumb(_weekPraise['subject_collection_items'][index]), 
                              // 中间信息区域
                              SizedBox(width: ScreenAdapter.width(30)),
                              _info(_weekPraise['subject_collection_items'][index]),
                              SizedBox(width: ScreenAdapter.width(30)),
                              // 右侧操作区域
                              _actions(_weekPraise['subject_collection_items'][index])
                            ],
                          ),
                        )
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color.fromRGBO(243, 243, 243, 1),
                        ),
                        height: ScreenAdapter.height(60),
                        padding: EdgeInsets.only(left: ScreenAdapter.width(15)),
                        margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),bottom: ScreenAdapter.height(30)),
                        alignment: Alignment.centerLeft,
                        child: Text('${_weekPraise['subject_collection_items'][index]['rating']['count']}评价',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5),fontSize: 12)),
                      ),
                      Container(
                        height: ScreenAdapter.height(20),
                        color: Color.fromRGBO(235, 235, 235, 1),
                      )
                    ],
                  );
                },  
                itemCount: _weekPraise['subject_collection_items'].length,
              )
            ],
          ),
        )
      ):BaseLoading(type: _requestStatus),
    );
  }

  // 头部筛选
  Widget _headActions(){
    return Container(
      margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),top: ScreenAdapter.height(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('片单列表 · 共$_total部',style: TextStyle(color: Colors.grey)),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(11)
                  ),
                  child: Row(
                    children: <Widget>[
                      Text('更新时间',style: TextStyle(color: _baseTextColor,fontSize: 11)),
                      SizedBox(width: ScreenAdapter.width(8)),
                      Text('09-20',style: TextStyle(color: _baseTextColor,fontSize: 10.5)),
                      Icon(Icons.keyboard_arrow_down,color: _baseTextColor,size: 16,)
                    ],
                  ),
                ),
                onTap:_timeFilter,
              )
            ],
          )
        ]
      ),
    );
  }
 
   // 左侧缩略图
  Widget _thumb(item){
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network('${item['cover']['url']}',width: ScreenAdapter.width(200),height: ScreenAdapter.height(220),fit: BoxFit.cover,),
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
                  rating:item['rating']['value'] / 2,
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
                Text('${item['rating']['value']}',style: TextStyle(color: Colors.grey,fontSize: 12))
              ],
            ),
            SizedBox(height: ScreenAdapter.width(15)),
            Text('${item['card_subtitle']}',style: TextStyle(color: Colors.grey,fontSize: 12))
          ],
        ),
      ), 
    );
  }
  // 右侧操作区域
  Widget _actions(item){
    return Container(
      height: ScreenAdapter.height(180),
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
                  child: Image.asset('lib/assets/favorite.png',width: ScreenAdapter.width(40))
                ),
                SizedBox(height: ScreenAdapter.height(10)),
                Text('想看',style: TextStyle(fontSize: 12,color: Colors.orange))
              ],
            ),
          ),
        ],
      )
    );
  }

}