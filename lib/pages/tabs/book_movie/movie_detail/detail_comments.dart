import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailComments extends StatefulWidget {

  final String movieId;
  final bool _isDark;

  DetailComments(this._isDark,{@required this.movieId});


  @override
  _DetailCommentsState createState() => _DetailCommentsState();
}

class _DetailCommentsState extends State<DetailComments> with AutomaticKeepAliveClientMixin{

  bool get wantKeepAlive => true;
  Color _baseTextColor;

  // 评论
  List _commentsList = [];

  String _requestStatus = '';


  @override
  void initState() { 
    super.initState();
    _baseTextColor = widget._isDark == true ? Colors.white:Colors.black;
    _getComments();
  }

  // 获取评论
  _getComments() async{
    try {
      Map<String,dynamic> params = {
        'apikey':ApiConfig.apiKey
      };
      Response res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/subject/${widget.movieId}/reviews', params);
      if(mounted){
        if(res.data['reviews'].length > 0){
          setState(() {
            _commentsList =  res.data['reviews'];
          });
        } else{
          setState(() {
            _requestStatus = '暂无影评'; 
          });
        }
      }
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _commentsList.length > 0 ? ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return Container(
            margin: EdgeInsets.all(ScreenAdapter.width(30)),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipOval(
                      child: Image.network('${_commentsList[index]['author']['avatar']}',fit: BoxFit.cover,width: ScreenAdapter.width(60)),
                    ),
                    SizedBox(width: ScreenAdapter.width(20)),
                    Text('${_commentsList[index]['author']['name']}',style: TextStyle(color: _baseTextColor)),
                    SizedBox(width: ScreenAdapter.width(40)),
                    Text('看过',style: TextStyle(color: _baseTextColor)),
                    SizedBox(width: ScreenAdapter.width(20)),
                    RatingBarIndicator(
                      rating:_commentsList[index]['rating']['value'] > 0 ? _commentsList[index]['rating']['value']:0,
                      alpha:0,
                      unratedColor:Colors.grey,
                      itemPadding: EdgeInsets.all(0),
                      itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 9,
                    ),
                  ],
                ),
                SizedBox(height: ScreenAdapter.height(20)),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                  alignment: Alignment.centerLeft,
                  child: Text('${_commentsList[index]['title']}',style: TextStyle(fontSize: 18,color: _baseTextColor)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                  alignment: Alignment.centerLeft,
                  child: Text('${_commentsList[index]['content']}',style: TextStyle(color: widget._isDark ? Colors.grey[300]:Colors.grey[600]),maxLines: 3,overflow: TextOverflow.ellipsis),
                ),
                Row(
                  children: <Widget>[
                    Text('${_commentsList[index]['comments_count']}回复 · ${_commentsList[index]['useful_count']}有用',style: TextStyle(color: widget._isDark ? Colors.grey[300]:Colors.grey[500])),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: _commentsList.length
      ):BaseLoading(type:_requestStatus),
    );
  }
}