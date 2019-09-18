import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/pages/theatricalFilm/is_hit.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class TheatricalFilm extends StatefulWidget {
  @override
  _TheatricalFilmState createState() => _TheatricalFilmState();
}

class _TheatricalFilmState extends State<TheatricalFilm> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          textTheme: TextTheme(
            title:TextStyle(color: Colors.black)
          ),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text('院线电影',style: TextStyle(fontSize: 20)),
          bottom: TabBar(
            labelColor:Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.black45,
            tabs: <Widget>[
              Tab(text: '正在热映'),
              Tab(text: '即将上映'),
              Tab(text: '观影指南'),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left:ScreenAdapter.width(30),right:ScreenAdapter.width(30)),
          child: TabBarView(
            children: <Widget>[
              IsHit(),
              Text('x'),
              Text('x'),
            ],
          ),
        ),
      ),
    );
  }
}