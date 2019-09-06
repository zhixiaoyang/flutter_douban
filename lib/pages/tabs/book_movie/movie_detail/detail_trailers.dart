import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class DetailTrailer extends StatefulWidget {

  Map _movie;
  DetailTrailer(this._movie);

  @override
  _DetailTrailerState createState() => _DetailTrailerState();
}

class _DetailTrailerState extends State<DetailTrailer> {

  // 预告片
  List _trailerList = [];

  @override
  void initState() { 
    super.initState();

    _trailerList.add(widget._movie['trailers'][0]);
    widget._movie['photos'].forEach((item){
      _trailerList.add({
        "medium":item['cover']
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('预告片 / 剧照',style: TextStyle(fontSize: 20)),
              Text('全部',style: TextStyle(fontSize: 12))
            ],
          ),
          SizedBox(height: ScreenAdapter.height(30)),
          Container(
            height: ScreenAdapter.height(300),
            child: ListView.builder(
              scrollDirection:Axis.horizontal,
              itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                  child: Stack(
                    children: <Widget>[
                      Image.network('${_trailerList[index]['medium']}',height: ScreenAdapter.height(300),width: index == 0 ? ScreenAdapter.width(500):null,fit: BoxFit.fill),
                      index == 0 ? Container(
                        alignment: Alignment.center,
                        width: ScreenAdapter.width(500),
                        child: Icon(Icons.play_circle_outline,color: Colors.white,)
                      ):Text('')
                    ],
                  ),
                );
              },
              itemCount: _trailerList.length,
            ),
          )
        ],
      ),
    );
  }
}