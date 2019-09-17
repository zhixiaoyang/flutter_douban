import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/api/api_config.dart';
import 'package:flutter_jahn_douban/routes/application.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieShow extends StatefulWidget {
  @override
  _MovieShowState createState() => _MovieShowState();
}

class _MovieShowState extends State<MovieShow> {

  // 热映列表
  List _hotShowList = [];

  // 即将上映列表
  List _comingSoonList = [];
  
  // 热映列表total
  int _hotShowTotal = 0;

  // 正在上映列表total
  int _comingSoonTotal = 0;


  // 当前热映列表
  // 热映列表：1，即将上映2
  int _currentTabIndex = 1;

  @override
  void initState() { 
    super.initState();

    // 获取热映
    _getHotShowList();
    // 获取即将上映
    _getComingSoonList();
  }

  // 获取热映列表
  _getHotShowList()async{
    var params = {
      "start":0,
      "count":6,
      "apikey":ApiConfig.apiKey
    };
    try{
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/in_theaters', params);
      if(res.data['subjects'].length > 0){
        setState(() {
         _hotShowList = res.data['subjects'];
         _hotShowTotal = res.data['total'];
        });
      }
    }
    catch(e){
      print(e);
    }
  }
    // 获取即将上映列表
  _getComingSoonList()async{
    var params = {
      "start":0,
      "count":6,
      "apikey":ApiConfig.apiKey
    };
    try{
      var res = await ApiConfig.ajax('get', ApiConfig.baseUrl + '/v2/movie/coming_soon', params);
      if(res.data['subjects'].length > 0){
        setState(() {
         _comingSoonList = res.data['subjects'];
         _comingSoonTotal = res.data['total'];
        });
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap:true,   
      physics: NeverScrollableScrollPhysics(),  
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                   decoration: BoxDecoration(
                    border: _currentTabIndex == 1 ? Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1
                      )
                    ):null
                  ),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _currentTabIndex = 1;
                      });
                    },
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(seconds: 1),
                      style: TextStyle(color: _currentTabIndex == 1 ? Colors.black:Colors.grey),
                      child: Text('影院热映',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                SizedBox(width: ScreenAdapter.width(20)),
                Container(
                  padding: EdgeInsets.only(bottom: ScreenAdapter.height(20)),
                  decoration: BoxDecoration(
                    border:  _currentTabIndex == 2 ? Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width:  1
                      )
                    ):null
                  ),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _currentTabIndex = 2;
                      });
                    },
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(seconds: 1),
                      style: TextStyle(color: _currentTabIndex == 2 ? Colors.black:Colors.grey),
                      child: Text('即将上映',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                    )
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Application.router.navigateTo(context,'/theatricalFilm');
                  },
                  child: Text('全部 ${_currentTabIndex == 1 ? _hotShowTotal : _comingSoonTotal}'),
                ),
                Icon(Icons.chevron_right)
              ],
            )
          ],
        ),
        SizedBox(height: ScreenAdapter.height(30)),
        _currentTabIndex == 1 ? _movieShow(_hotShowList) : _movieShow(_comingSoonList)
        
      ],
    ); 
  }

  // 热映
  Widget _movieShow(data){
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //横轴元素个数
        crossAxisCount: 3,
        //纵轴间距
        //横轴间距
        crossAxisSpacing: 10.0,
        //子组件宽高长度比例
        childAspectRatio: ScreenAdapter.getScreenWidth() / 3 /  ScreenAdapter.height(480)
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Application.router.navigateTo(context, '/movieDetail?id=${data[index]['id']}&type=$_currentTabIndex');
          },
          child: Container(
            child: Column(
              children: <Widget>[
                ClipRRect(
                  child: Image.network('${data[index]['images']['small']}',
                  width: double.infinity,
                  height:ScreenAdapter.height(300),fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(5),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenAdapter.height(10),bottom: ScreenAdapter.height(10)),
                  alignment: Alignment.centerLeft,
                  child: Text('${data[index]['title']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600)),
                ),
                _currentTabIndex == 1 ?  Row(
                  children: <Widget>[
                    RatingBarIndicator(
                      rating:data[index]['rating']['average'] / 2,
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
                    Text('${data[index]['rating']['average']}',style: TextStyle(fontSize: 11,color: Colors.grey))
                  ],
                ):Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(ScreenAdapter.width(6)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1,color: Colors.pink),
                    ),
                    child: Text('${data[index]['mainland_pubdate']}',style: TextStyle(fontSize: 9,color: Colors.pink)),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }


}