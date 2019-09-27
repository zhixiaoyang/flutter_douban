import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/routes/application.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_jahn_douban/weiget/base_loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopList extends StatefulWidget {

  // 列表数据
  final Map data;
  // 过滤列表数据
  List filterList = [];
  // 当前过滤条件索引
  int currentFilterCondition = 0;
  // 状态
  String requestStatus = '';
  // 回调函数用于筛选过滤
  Function cb;
  // 筛选描述文字
  String filterDescChar = '';
  // 底部描述类型
  String footerFieldType;

  TopList({
      this.footerFieldType = 'evaluate', 
      @required this.filterDescChar,
      @required this.requestStatus,
      @required this.filterList,
      @required this.data,
      @required this.currentFilterCondition,
      @required this.cb
  });

  @override
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> {
  // 控制滚动
  ScrollController _scrollController = ScrollController();
  // 是否展开
  bool _isExpand = true;
  @override
  void initState() { 

    super.initState();
    // // 监听滚动 控制标题栏样式
    // _scrollController.addListener((){
    //   setState(() {
    //     _isExpand = _scrollController.offset > 140 ? false:true;
    //   });r
    // });
  }
  WidgetsBinding _binding = WidgetsBinding.instance;
  @override
  void dispose() { 
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.requestStatus.isNotEmpty ?  NestedScrollView(
        headerSliverBuilder: (context,isScroll){
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color:_isExpand ? Colors.white: Colors.black
              ),
              brightness: Brightness.light,
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedDefaultTextStyle(
                  duration: Duration(seconds:1),
                  style: TextStyle(color: _isExpand ? Colors.white:Colors.black,fontSize: 20),
                  child: Text('${widget.data['subject_collection']['name']}'),
                ),
                background: Container(
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Image.network('${widget.data['subject_collection']['header_bg_image']}',fit: BoxFit.cover,height: 200 +  MediaQuery.of(context).padding.top),
                      ),
                      Positioned(
                        top: 100,
                        left: 30,
                        child: Text('${widget.data['subject_collection']['description']}',style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverBarDelegate(
                PreferredSize(
                  preferredSize: Size.fromHeight(ScreenAdapter.height(80)),
                  child:_headActions()
                ),
              ),
            ),
          ];
        },
        body:BodyView(
          widget.currentFilterCondition,
          data:widget.data,
          footerFieldType:widget.footerFieldType,
        )
      ):BaseLoading(type: widget.requestStatus),
    ); 
  }   
  
  Widget _headActions(){
    return Container(
      alignment: Alignment.bottomCenter,
      height: ScreenAdapter.height(80),
      margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('片单列表 · 共${widget.data['total']}部'),
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
                Text('${widget.filterDescChar}',style: TextStyle(fontSize: 11)),
                SizedBox(width: ScreenAdapter.width(8)),
                Text('${widget.filterList.length > 0 ? widget.filterList[widget.currentFilterCondition]:''}',style: TextStyle(fontSize: 11))
              ],
            ),
          ),
          GestureDetector(
            onTap:(){
              _timeFilter();
            },
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
                          onTap:(){
                            state(() {
                              widget.cb(index);
                            });
                            if(index == 0 ){
                              _binding.addPostFrameCallback((callback) => _scrollController.jumpTo(0.1));
                            }
                            Navigator.pop(context);
                            
                            if(widget.footerFieldType == 'desc'){
                              print(widget.currentFilterCondition);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:widget.currentFilterCondition == index ? Color.fromRGBO(66, 189, 86, 1):Colors.grey[200],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            // :
                            child: Text('${widget.filterList[index]}',style: TextStyle(fontSize: 12,color:widget.currentFilterCondition == index ? Colors.white:Colors.black)),
                          ),
                        );
                      },  
                      itemCount: widget.filterList.length,
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
}


class BodyView extends StatefulWidget {
  
  int tt ;
  // 列表数据
  final Map data;

  // 底部描述类型
  String footerFieldType;


  BodyView(this.tt,{
      this.footerFieldType = 'evaluate', 
      @required this.data,
     
  });


  @override
  _BodyViewState createState() => _BodyViewState();
}

class _BodyViewState extends State<BodyView> {
  ScrollController innerC;
  Type typeOf<T>() => T;
  WidgetsBinding _binding = WidgetsBinding.instance;

  @override
  void initState() {
    super.initState();
    PrimaryScrollController primaryScrollController = context.ancestorWidgetOfExactType(typeOf<PrimaryScrollController>());
    innerC = primaryScrollController.controller;
  }


  gogo(int type) {
    setState(() {
        _binding.addPostFrameCallback((callback) {
          print(innerC.offset);
            if(type == 1){
              innerC.jumpTo(100);
            }
            if(type == 2){
              innerC.jumpTo(600);
            }
            if(type == 3){
                innerC.jumpTo(800);
            }
            if(type == 4){
              innerC.jumpTo(1200);
            }
          if(type == 5){
              innerC.jumpTo(2600);
            }
         
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    gogo(widget.tt);
    return  ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      controller: innerC,
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
                  Application.router.navigateTo(context, '/movieDetail?id=${widget.data['subject_collection_items'][index]['id']}');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 缩略图
                    _thumb(widget.data['subject_collection_items'][index]), 
                    // 中间信息区域
                    SizedBox(width: ScreenAdapter.width(30)),
                    _info(widget.data['subject_collection_items'][index]),
                    SizedBox(width: ScreenAdapter.width(30)),
                    // 右侧操作区域
                    _actions(widget.data['subject_collection_items'][index])
                  ],
                ),
              )
            ),
            // 底部描述
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color.fromRGBO(243, 243, 243, 1),
              ),
              height: ScreenAdapter.height(60),
              padding: EdgeInsets.only(left: ScreenAdapter.width(15)),
              margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30),bottom: ScreenAdapter.height(30)),
              alignment: Alignment.centerLeft,
              child: Text(_footerDesc(widget.data['subject_collection_items'][index]),style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5),fontSize: 12)),
            ),
            Container(
              height: ScreenAdapter.height(20),
              color: Color.fromRGBO(235, 235, 235, 1),
            )
          ],
        );
      },  
      itemCount: widget.data['subject_collection_items'].length,
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
  // 底部描述
  _footerDesc(item){
    switch (widget.footerFieldType) {
      case 'evaluate':
        return '${item['rating']['count']}评价';
        break;
      case 'desc':
        return '${item['description']}';
        break;
      default:
    }
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
 
}



class SliverBarDelegate extends SliverPersistentHeaderDelegate {
  final  widget;

  SliverBarDelegate(this.widget);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: widget,
    );
  }

  @override
  bool shouldRebuild(SliverBarDelegate oldDelegate) {
    return false;
  }

  @override
  double get maxExtent => widget.preferredSize.height;

  @override
  double get minExtent => widget.preferredSize.height;
}
