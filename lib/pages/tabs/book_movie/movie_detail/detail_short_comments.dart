import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class DetailShortComments extends StatefulWidget {

  final Map _movie;
  final Color _detailThemeColor;

  DetailShortComments(this._movie,this._detailThemeColor);

  @override
  _DetailShortCommentsState createState() => _DetailShortCommentsState();
}

class _DetailShortCommentsState extends State<DetailShortComments> {

  
  @override
  void initState() {
    super.initState();
    widget._movie['popular_comments'].forEach((item){
      item['showMore'] = 6;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      decoration: BoxDecoration(
        color: widget._detailThemeColor,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('短评',style: TextStyle(fontSize: 20)),
              Row(
                children: <Widget>[
                  Text('全部短评 ${widget._movie['comments_count']}'),
                  Icon(Icons.keyboard_arrow_right,color:Colors.white)
                ],
              )
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context,index){
              return _commentItem(widget._movie['popular_comments'][index]);
            },
            itemCount: widget._movie['popular_comments'].length,
          )
        ],
      ),
    );
  }

  // 单个短评
  Widget _commentItem(item){
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding:EdgeInsets.all(0),
            leading: ClipOval(
              child: Image.network('${item['author']['avatar']}',width: ScreenAdapter.width(60),fit: BoxFit.cover,),
            ),
            title: Text('${item['author']['name']}',style: TextStyle(fontSize: 14),),
            subtitle: Row(
              children: <Widget>[
                RatingBarIndicator(
                  rating:item['rating']['value'],
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
                Text('${((DateTime.now().millisecondsSinceEpoch - DateTime.parse(item['created_at']).millisecondsSinceEpoch) / 1000 / 60 / 60 / 24 / 31).round()}个月前',style: TextStyle(color: Colors.white54,fontSize: 12))
              ],
            ),
            trailing: Icon(Icons.more_horiz,color: Colors.white54),
          ),
          Text('${item['content']}',maxLines: item['showMore'],overflow: TextOverflow.ellipsis,),
          Container(
            margin: EdgeInsets.only(right: ScreenAdapter.width(20)),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  item['showMore'] = item['showMore'] == 6 ? 15:6;
                });
              },
              child: Text('${item['showMore'] == 6 ? '展开':'收起'}',style: TextStyle(color:Colors.grey,fontSize: 14)),
            ),
          )
        ],
      ),
    );
  }

}