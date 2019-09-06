import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class DetailActor extends StatefulWidget {

  final Map _movie;
  DetailActor(this._movie);

  @override
  _DetailActorState createState() => _DetailActorState();
}

class _DetailActorState extends State<DetailActor> {

  // 演员列表
  List _actor = []; 

  @override
  void initState() { 
    super.initState();

    widget._movie['directors'].forEach((item){
      item['type'] = '导演';
      _actor.add(item);
    });
    widget._movie['casts'].forEach((item){
      item['type'] = '演员';
      _actor.add(item);
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
              Text('演职员',style: TextStyle(fontSize: 20)),
              Row(
                children: <Widget>[
                  Text('全部'),
                  Icon(Icons.keyboard_arrow_right,color:Colors.white)
                ],
              )
            ],
          ),
          SizedBox(height: ScreenAdapter.height(30)),
          Container(
            height: ScreenAdapter.height(350),
            child: ListView.builder(
              scrollDirection:Axis.horizontal,
              itemBuilder: (context,index){
                return Container(
                  margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
                  child: Column(
                    children: <Widget>[
                      Image.network('${_actor[index]['avatars']['small']}',width: ScreenAdapter.width(160),fit: BoxFit.cover,),
                      SizedBox(height: ScreenAdapter.height(10)),
                      Container(
                        width: ScreenAdapter.width(160),
                        child: Text('${_actor[index]['name']}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)),
                      ),
                      SizedBox(height: ScreenAdapter.height(10)),
                      Container(
                        width: ScreenAdapter.width(160),
                        child: Text('${_actor[index]['type']}',style: TextStyle(fontSize: 10)),
                      )
                    ],
                  ),
                );
              },
              itemCount: _actor.length,
            ),
          )
        ],
      ),
    );
  }
}