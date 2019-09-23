import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_actor.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_also_like.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_comments.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_grade.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_head.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_plot.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_short_comments.dart';
import 'package:flutter_jahn_douban/pages/tabs/book_movie/movie_detail/detail_trailers.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class MovieDetail extends StatefulWidget {

  final String movieId;

  MovieDetail({this.movieId});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {

  // 电影详情内容
  Map _movie;
  // 主题颜色
  String _themeColor = '';
  bool _isDark;
  String _requestStatus = '';

  // 滚动控制器
  ScrollController _scrollController = ScrollController();
  // 默认显示静态文字电影
  bool _showTitle = false;

  @override
  void initState() { 
    super.initState();
    _getDetail();
    _getDetailTheme();
    if(mounted){
      // 监听滚动
      _scrollController.addListener((){
        if(_scrollController.offset > 40){
          setState(() {
            _showTitle = true; 
          });
        }else{
          setState(() {
            _showTitle = false; 
          });
        }
      });
    }
  }
  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    super.dispose();
    _scrollController.dispose();
  }
  // 获取电影详情
  _getDetailTheme() async{
    try{
      Response res = await Dio().get('https://m.douban.com/rexxar/api/v2/movie/${widget.movieId}?ck=&for_mobile=1', options: Options(
        headers: {
          HttpHeaders.refererHeader: 'https://m.douban.com/movie/beta',
        },
      ));
      if(mounted){
        setState(() {
          _themeColor = res.data['header_bg_color'];
          _isDark = res.data['color_scheme']['is_dark'];
        });
      }
    }
    catch(e){
      print(e);
      if(mounted){
        setState(() {
          _requestStatus = '暂无数据'; 
        });
      }
      
    }
  }

    // 获取电影详情
  _getDetail() async{
    try{
      Map<String,dynamic> params = {
        "apikey":ApiConfig.apiKey
      };
      Response res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/subject/${widget.movieId}', params);
      if(mounted){
        setState(() {
          _movie = res.data; 
        });
      }
    }
    catch(e){
      print(e);
      if(mounted){
        setState(() {
          _requestStatus = '暂无数据'; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _themeColor.isNotEmpty && _movie !=null ? Theme(
      data: ThemeData(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
          subhead: TextStyle(color: Colors.white),
          title: TextStyle(color: Colors.white),
        )
      ),
      child: Scaffold(
        backgroundColor:Color(int.parse('0xff' + _themeColor)),
        appBar: AppBar(
          centerTitle: true,
          title: _showTitle ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text('${_movie['title']}',style: TextStyle(fontSize: 14)),
              ),
              Row(
                children: <Widget>[
                  RatingBarIndicator(
                    rating:_movie['rating']['average'] / 2,
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
                  SizedBox(width: ScreenAdapter.width(10)),
                  Text('${_movie['rating']['average']}',style: TextStyle(fontSize: 12))
                ],
              )
            ],
          ) : Text('电影') ,
          backgroundColor: Color(int.parse('0xff' + _themeColor)),
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context,bool){
              return [
                 // 详情头部
                SliverToBoxAdapter(child:SizedBox(height: ScreenAdapter.height(30))),
                _paddingContainer(child:DetailHead(_movie,_isDark)),
                SliverToBoxAdapter(child:SizedBox(height: ScreenAdapter.height(30))),
                // 豆瓣评分
                _paddingContainer(child:DetailGrade(_movie,_isDark)),
                // 剧情简介
                _paddingContainer(child:DetailPlot(_movie,_isDark)),
                SliverToBoxAdapter(child:SizedBox(height: ScreenAdapter.height(40))),
                // 演职员
                _paddingContainer(child:DetailActor(_movie,_isDark)),
                // 预告片 / 剧照
                _paddingContainer(child:DetailTrailer(_movie,_isDark)),
                SliverToBoxAdapter(child:SizedBox(height: ScreenAdapter.height(40))),
                // 短评
                _paddingContainer(child:DetailShortComments(_movie,_isDark)),
                SliverToBoxAdapter(child:SizedBox(height: ScreenAdapter.height(40))),
                // 有可能喜欢
                _paddingContainer(child: DetailAlsoLike(_movie['genres'][0],_isDark)),
                // 影评
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverTabBarDelegate(
                    PreferredSize(
                      preferredSize: Size.fromHeight(40),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[600]
                        ),
                        child: TabBar(
                          labelColor: Colors.white,
                          indicatorColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: Colors.grey[400],
                          tabs: <Widget>[
                            Tab(text: '影评',),
                            Tab(text: '话题'),
                            Tab(text: '小组讨论'),
                          ],
                        ),
                      ),
                    ),
                  )
                )
              ];
            },
            body: TabBarView(
              children: <Widget>[
                DetailComments(_isDark,movieId: widget.movieId),
                Center(
                  child: Text('暂无话题数据'),
                ),
                Center(
                  child: Text('暂无小组讨论数据'),
                ),
              ],
            ),
          ),
        )
      ),
    ):Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          textTheme: TextTheme(
            title:TextStyle(color: Colors.black)
          ),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          brightness: Brightness.dark,
      ),
      body: BaseLoading(type: _requestStatus),
    );
  }
}

// paddin容器
Widget _paddingContainer({@required child}){
  return SliverPadding(
    padding:EdgeInsets.only(bottom:ScreenAdapter.width(30),left: ScreenAdapter.width(30),right: ScreenAdapter.width(30)),
    sliver: SliverToBoxAdapter(
      child: child
    ),
  );
}


class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final widget;
  final Color color;

  const SliverTabBarDelegate(this.widget, {this.color})
      : assert(widget != null);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: widget,
      color: color,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;
}