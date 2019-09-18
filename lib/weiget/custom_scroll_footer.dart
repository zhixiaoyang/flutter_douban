
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';

class CustomScrollFooter extends StatefulWidget {
  @override
  _CustomScrollFooterState createState() => _CustomScrollFooterState();
}

class _CustomScrollFooterState extends State<CustomScrollFooter> with SingleTickerProviderStateMixin{

  GifController _gifController;

  @override
  void initState() { 
    super.initState();
    _gifController = GifController(
      vsync: this,
      value: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context,LoadStatus mode){
        Widget body ;
        if(mode==LoadStatus.idle){
          _gifController.value = 30;
          _gifController.animateTo(59, duration: Duration(milliseconds: 500));
          body = Container(
            child: GifImage(
              image: AssetImage("lib/assets/douban_loading.gif"),
              controller: _gifController,
              height:ScreenAdapter.height(40),
              width:ScreenAdapter.width(40),
            ),
          );
        }
        else if(mode==LoadStatus.loading){
          _gifController.repeat( min: 0, max: 29, period: Duration(milliseconds: 500));
          body = Container(
            child: GifImage(
              image: AssetImage("lib/assets/douban_loading.gif"),
              controller: _gifController,
              height:ScreenAdapter.height(40),
              width:ScreenAdapter.width(40),
            ),
          );
        }
        else if(mode==LoadStatus.noMore){
          _gifController.value = 30;
          _gifController.animateTo(59, duration: Duration(milliseconds: 500));
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5),
                child: GifImage(
                  image: AssetImage("lib/assets/douban_loading.gif"),
                  controller: _gifController,
                  height:ScreenAdapter.height(40),
                  width:ScreenAdapter.width(40),
                ),
              ),
              Text(' 已经触碰了我的底线 ！',style: TextStyle(color: Colors.grey),)
            ],
          );
        }
        else if(mode == LoadStatus.failed){
          body = Text("加载失败 ！");
        }
        return Container(
          height:ScreenAdapter.height(100),
          child: Center(child:body),
        );
      },
    );
  }
}