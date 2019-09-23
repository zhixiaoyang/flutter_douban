import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';

class PublicPraiseList extends StatefulWidget {
  @override
  _PublicPraiseListState createState() => _PublicPraiseListState();
}

class _PublicPraiseListState extends State<PublicPraiseList> {

  // 数据列表
  List _list = [];

  @override
  void initState() { 
    super.initState();
    _getData();
  }

  // 获取一周口碑榜
  _getData()async{

    Map<String,dynamic> params = {
      'apikey':ApiConfig.apiKey
    };

    Response res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/weekly', params);
    if(mounted){
      setState(() {
        _list = res.data['subjects'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context,bool){
          return [
            SliverAppBar(
              title: Text('x'),
              pinned:true,
              flexibleSpace:FlexibleSpaceBar(
                background: Image.asset('images/timg.jpg', fit: BoxFit.cover),
              )
            )
          ];
        },
        body:Container(
          child: Text('x'),
        ),
      ),
    );
  }
}