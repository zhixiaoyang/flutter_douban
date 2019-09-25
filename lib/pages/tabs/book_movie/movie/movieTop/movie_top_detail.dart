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
  // 过滤日期列表
  List _dateList = [];
  int _currentFilterDate = 0;

  @override
  void initState() { 
    super.initState();
    _baseTextColor = _isDark == true ? Colors.white:Colors.black;
    _getWeekPraiseList();
    _getFillterDate();
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

      Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/subject_collection/movie_weekly_best/items?start=0&count=20&for_mobile=1&updated_at=${_dateList.length > 0 ? _dateList[_currentFilterDate]:''}', options: Options(
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
    }
    catch (e) {
      print(e);
      if(mounted){
        setState(() {
          _requestStatus = '获取豆瓣榜单详情页失败';
        });
      }
    }
  }
  // 获取筛选日期
  _getFillterDate()async{
    try {
      Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/subject_collection/movie_weekly_best/dates?for_mobile=1', options: Options(
      headers: {
          HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
        },
      ));
      if(mounted){
        setState(() {
          _dateList = res.data['data']; 
        });
      }
    }
    catch (e) {
      print(e);
    }
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
                      // 头部排名
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
                      // 具体内容
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
                      // 评价数
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

  // 时间筛选
  _timeFilter(){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )
      ),
      context:context, 
      builder: (context) {
        return StatefulBuilder(
          builder: (context,state){
            return Container(
              height: 300,
              padding: EdgeInsets.fromLTRB(ScreenAdapter.width(30),0,ScreenAdapter.width(30),0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black26,
                    ),
                    alignment: Alignment.center,
                    margin:EdgeInsets.only(top:ScreenAdapter.height(16),bottom:ScreenAdapter.height(40)),
                    width: ScreenAdapter.width(60),
                    height: ScreenAdapter.width(8),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin:EdgeInsets.only(bottom:ScreenAdapter.height(20)),
                    child: Text('${DateTime.now().year}',style: TextStyle(fontSize: 18)),
                  ),
                  Container(
                    width: double.infinity,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //横轴元素个数
                        crossAxisCount: 4,
                        //纵轴间距
                        mainAxisSpacing: 8,
                        //横轴间距
                        crossAxisSpacing: 10.0,
                        //子组件宽高长度比例
                        childAspectRatio: 2.7 / 1
                      ),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            state(() {
                              _currentFilterDate = index; 
                            });
                            Navigator.pop(context);
                            _getWeekPraiseList();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:_currentFilterDate == index ? Color.fromRGBO(66, 189, 86, 1):Colors.grey[200],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            child: Text('${_dateList[index].substring(5,10)}',style: TextStyle(fontSize: 12,color: _currentFilterDate == index ? Colors.white:Colors.black)),
                          ),
                        );
                      },  
                      itemCount: _dateList.length,
                    )
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 头部筛选
  Widget _headActions(){
    return Container(
      margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),top: ScreenAdapter.height(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('片单列表 · 共$_total部',style: TextStyle(color: Colors.grey)),
          Container(
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey
              ),
              borderRadius: BorderRadius.circular(11)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('更新时间',style: TextStyle(color: _baseTextColor,fontSize: 11)),
                SizedBox(width: ScreenAdapter.width(8)),
                Text('${_dateList[_currentFilterDate].substring(5,10)}',style: TextStyle(color: _baseTextColor,fontSize: 11))
              ],
            ),
          ),
          GestureDetector(
            onTap:_timeFilter,
            child: Row(
              crossAxisAlignment:CrossAxisAlignment.end,
              children: <Widget>[
                Image.asset('lib/assets/filter.png',width: ScreenAdapter.width(30)),
                Text('筛选',style: TextStyle(fontSize: 14))
              ],  
            ),
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