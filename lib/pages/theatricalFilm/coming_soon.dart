import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_jahn_douban/weiget/custom_scroll_footer.dart';
import 'package:flutter_jahn_douban/weiget/custom_scroll_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}


class _ComingSoonState extends State<ComingSoon> with AutomaticKeepAliveClientMixin{

  // 保持状态
  bool get wantKeepAlive  => true;

  // 正在热映列表
  List _comingSoonList = [];
  List _dateList = [];
  List temp = [];
  // 分页
  int _start = 0;
  // 总数量
  int _total = 0;
  String _requestStatus = '';

  RefreshController _controller = RefreshController();

    @override
  void initState() { 
    super.initState();

    _getComingSoon();

  }

  // 获取即将上映列表数据
  _getComingSoon() async {

    try {
      Map<String,dynamic> params ={
        'apikey':ApiConfig.apiKey,
        'count':10,
        'start':_start
      };
      var res = await ApiConfig.ajax('get',ApiConfig.baseUrl +  '/v2/movie/coming_soon', params);
      List temp = [];
      for(var i = 0 ; i < res.data['subjects'].length;i++){
       String validate = res.data['subjects'][i]['pubdates'][res.data['subjects'][i]['pubdates'].length - 1].substring(0,10);
        if(_dateList.indexOf("$validate") == -1){
          _dateList.add(validate);
          temp.add({
            "date":validate,
            "list":[]
          });
        }else{
          bool a = _comingSoonList.any((item){
            if(item['date'] == validate){
              item['list'].add(res.data['subjects'][i]);
            }
            return item['date'] == validate;
          });
        }
      }

      res.data['subjects'].forEach((value){
        bool b = temp.any((tempItem){ 
          if(tempItem['date'] == value['pubdates'][value['pubdates'].length - 1].substring(0,10)){
            tempItem['list'].add(value);
          }
          return tempItem['date'] == value['pubdates'][value['pubdates'].length -1 ].substring(0,10);
        });
      });
      
      if(mounted){
        setState(() {
        _comingSoonList.addAll(temp); 
          _total = res.data['total'];
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
    return SmartRefresher(
      controller: _controller,
      enablePullUp: true,
      enablePullDown: true,
      header: CustomScrollHeader(),
      footer: CustomScrollFooter(),
      onRefresh: () async {
        _controller.resetNoData();
        setState(() {
          _comingSoonList = [];
          _start = 0;
        });
        await _getComingSoon();
        _controller.refreshCompleted();
      },
      onLoading: () async {
        if(_start + 10 < _total){
          setState(() {
            _start = _start + 10;
          });
          await _getComingSoon();
          _controller.loadComplete();
        }else{
          _controller.loadNoData();
        }
      },
      child: _comingSoonList.length > 0 ? ListView.builder(
        itemBuilder: (context,index){
          return  Container(
            height: 200,
            child: Column(
            children: <Widget>[
              Text('${_comingSoonList[index]['date']}'),
              Wrap(
                children:_comingSoonList[index]['list'].map<Widget>((v){
                  return Text('${v['title']}');
                }).toList(),
              )
            ],
          ),
        );
        },
        itemCount: _comingSoonList.length,
      ):BaseLoading(type: _requestStatus),
    );
  }
  // // 右侧操作区域
  // Widget _actions(item){
  //   return Container(
  //     height: ScreenAdapter.height(240),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         GestureDetector(
  //           onTap: (){

  //           },
  //           child: Column(
  //             children: <Widget>[
  //               GestureDetector(
  //                 onTap: (){

  //                 },
  //                 child: Icon(Icons.favorite_border,size: 16,color: Colors.orange),
  //               ),
  //               SizedBox(height: ScreenAdapter.height(10)),
  //               Text('想看',style: TextStyle(fontSize: 10,color: Colors.orange))
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: ScreenAdapter.height(10)),
  //         Text('${item['collect_count']}人想看',style: TextStyle(fontSize: 10,color: Colors.grey))
  //       ],
  //     )
  //   );
  // }
  // // 左侧缩略图
  // Widget _thumb(item){
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(8),
  //     child: Image.network('${item['images']['small']}',width: ScreenAdapter.width(200),height: ScreenAdapter.height(240),fit: BoxFit.cover,),
  //   );
  // }

  // // 中间信息区域
  // Widget _info(item){
  //   return Expanded(
  //     child: Container(
  //       constraints: BoxConstraints(
  //         minHeight: ScreenAdapter.height(240)
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Container(
  //             alignment: Alignment.centerLeft,
  //             margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
  //             child: Text('${item['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400)),
  //           ),
  //           Container(
  //             alignment: Alignment.centerLeft,
  //             child: Text('${item['year']} ${item['directors'].length > 0 ? ' / ' + item['directors'][0]['name']:''}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,color: Colors.grey)),
  //           ),
  //           Container(
  //             height: ScreenAdapter.height(40),
  //             child: ListView(
  //               scrollDirection: Axis.horizontal,
  //               children: item['genres'].asMap().keys.map<Widget>((index){
  //                 return Text('${item['genres'][index]} ${index == item['genres'].length - 1 ? '':' / '}',style: TextStyle(fontSize: 12,color: Colors.grey));
  //               }).toList(),
  //             ),
  //           ),
  //           Container(
  //             height: ScreenAdapter.height(30),
  //             child: ListView(
  //               scrollDirection: Axis.horizontal,
  //               children: item['casts'].asMap().keys.map<Widget>((index){
  //                 return Text('${item['casts'][index]['name']} ${index == item['casts'].length - 1 ? '':' / '}',style: TextStyle(fontSize: 12,color: Colors.grey));
  //               }).toList(),
  //             ),
  //           )
  //         ],
  //       ),
  //     ), 
  //   );
  }


// }