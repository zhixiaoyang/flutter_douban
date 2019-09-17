import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
class DetailPlot extends StatefulWidget {

  Map _movie;
  Color _detailThemeColor;
  DetailPlot(this._movie,this._detailThemeColor);

  @override
  _DetailPlotState createState() => _DetailPlotState();
}

class _DetailPlotState extends State<DetailPlot> {

  // 剧情简介显示更多
  int _showMore = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding:EdgeInsets.all(0),
            leading: Icon(Icons.card_giftcard,color: Color.fromRGBO(252, 166, 118, 1)),
            title: Text('选座购票',),
            trailing: Icon(Icons.keyboard_arrow_right,color: Colors.white),
          ),
          Container(
            height: ScreenAdapter.height(50),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index){
                return Container(
                  padding: EdgeInsets.only(left:ScreenAdapter.width(20),right:ScreenAdapter.width(10)),
                  margin: EdgeInsets.only(right: ScreenAdapter.width(10)),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(15),
                    color: widget._detailThemeColor
                  ),
                  child: Row(
                    children: <Widget>[
                      Text('${widget._movie['genres'][index]}',style: TextStyle(fontSize: 11)),
                      Icon(Icons.keyboard_arrow_right,color: Colors.grey[400],size: 14,)
                    ],
                  ),
                );
              },
              itemCount: widget._movie['genres'].length,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdapter.height(30)),
            alignment: Alignment.centerLeft,
            child: Text('剧情简介',style: TextStyle(fontSize: 20)),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenAdapter.height(15)),
            alignment: Alignment.centerLeft,
            child: Text('${widget._movie['summary']}',maxLines: _showMore,overflow: TextOverflow.ellipsis,),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  _showMore = _showMore == 4 ? 15:4;
                });
              },
              child: Text('${_showMore == 4 ? '展开':'收起'}',style: TextStyle(color:Colors.grey,fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }
}