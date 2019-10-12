import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class DetailComment extends StatelessWidget {

  final Map _item;
  DetailComment(this._item);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(ScreenAdapter.width(20)),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    child: Image.network('${_item['author']['avatar']}',width: 25),
                  ),
                  SizedBox(width: ScreenAdapter.width(10)),
                  Text('${_item['author']['name']}',style: TextStyle(color: Colors.grey,fontSize: 16)),
                  SizedBox(width: ScreenAdapter.width(10)),
                  _item['rating']['value'] != 0 ? Text('看过',style: TextStyle(color: Colors.grey,fontSize: 16)):Container(),
                  SizedBox(width: ScreenAdapter.width(10)),
                  _item['rating']['value'] != 0 ? RatingBarIndicator(
                    rating: _item['rating']['value'],
                    alpha:0,
                    unratedColor:Colors.grey,
                    itemPadding: EdgeInsets.all(0),
                    itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 12,
                  ):Container(),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, ScreenAdapter.height(20), 0, ScreenAdapter.height(20)),
                alignment: Alignment.centerLeft,
                child: Text('${_item['title']}',style: TextStyle(fontSize: 22)),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('${_item['content']}',style: TextStyle(fontSize: 16,color: Colors.black87),maxLines: 3,overflow:TextOverflow.ellipsis),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                child: Text('${_item['comments_count']}回复 · ${_item['useful_count']}有用',style: TextStyle(color: Colors.grey),),
              ),
            ],
          ),
        ),
        Container(
          height: ScreenAdapter.height(15),
          color: Color.fromRGBO(244, 244, 244, 1),
        )
      ],
    );
  }
}