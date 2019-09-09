import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/routes/application.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailAlsoLike extends StatefulWidget {

// 类型
String _type = '';
DetailAlsoLike(this._type);

  @override
  _DetailAlsoLikeState createState() => _DetailAlsoLikeState();
}

class _DetailAlsoLikeState extends State<DetailAlsoLike> {

  // 可能喜欢列表
  List _alsoLikeList = [];
  // 
  String _requestStatus = '';

  @override
  void initState() { 
    super.initState();
    _getAlsoLike();
  }
  // 获取也可能喜欢
  _getAlsoLike()async{
    try {
      Map<String,dynamic> params = {
        'tag':widget._type,
        'page_start':0,
        'page_limit':8
      };
      var res = await ApiConfig.ajax('get', 'https://movie.douban.com/j/search_subjects?tag=纪录片', params);
      if( res.data['subjects'].length > 0){
        setState(() {
        _alsoLikeList = res.data['subjects'];
        });
      }else{
        setState(() {
          _requestStatus = '暂无推荐'; 
        });
      }
      print(res);
    } catch (e) {
      setState(() {
        _requestStatus = '暂无推荐'; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text('喜欢这部电影的也喜欢'),
            trailing: Icon(Icons.keyboard_arrow_right,color: Colors.white),
          ),
          _alsoLikeList.length > 0 ? _item(_alsoLikeList):BaseLoading(type:_requestStatus),
        ],
      ),
    );
  }

  // 热映
  Widget _item(data){
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //横轴元素个数
        crossAxisCount: 4,
        //纵轴间距
        //横轴间距
        crossAxisSpacing: 10.0,
        //子组件宽高长度比例
        childAspectRatio: ScreenAdapter.getScreenWidth() / 6 /  ScreenAdapter.height(280)
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            print(data[index]['id']);
            Application.router.navigateTo(context, '/movieDetail?id=${data[index]['id']}');
          },
          child: Container(
            child: Column(
              children: <Widget>[
                ClipRRect(
                  child: Image.network('${data[index]['cover']}',
                  width: double.infinity,
                  height:ScreenAdapter.height(230),fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(5),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenAdapter.height(10),bottom: ScreenAdapter.height(10)),
                  alignment: Alignment.centerLeft,
                  child: Text('${data[index]['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600)),
                ),
                Row(
                  children: <Widget>[
                    RatingBarIndicator(
                      rating:double.parse(data[index]['rate']) / 2,
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
                    SizedBox(width: ScreenAdapter.width(20)),
                    Text('${data[index]['rate']}',style: TextStyle(fontSize: 10,color: Colors.grey))
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

}