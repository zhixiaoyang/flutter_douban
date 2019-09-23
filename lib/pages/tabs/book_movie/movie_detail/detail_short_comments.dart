import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class DetailShortComments extends StatefulWidget {

  final Map _movie;
  final bool _isDark;

  DetailShortComments(this._movie,this._isDark);

  @override
  _DetailShortCommentsState createState() => _DetailShortCommentsState();
}

class _DetailShortCommentsState extends State<DetailShortComments> {

  Color _baseTextColor;
  
  @override
  void initState() {
    super.initState();
    _baseTextColor = widget._isDark == true ? Colors.white:Colors.black;
    if(mounted){
      widget._movie['popular_comments'].forEach((item){
        item['showMore'] = 6;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('短评',style: TextStyle(fontSize: 20,color:_baseTextColor)),
              Row(
                children: <Widget>[
                  Text('全部短评 ${widget._movie['comments_count']}',style:TextStyle(color: _baseTextColor)),
                  Icon(Icons.keyboard_arrow_right,color:_baseTextColor)
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
          ),
          ListTile(
            title: Text('查看全部短评',style: TextStyle(color: _baseTextColor)),
            trailing: Icon(Icons.keyboard_arrow_right,color:_baseTextColor),
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
            title: Text('${item['author']['name']}',style: TextStyle(fontSize: 14,color: _baseTextColor)),
            subtitle: Row(
              children: <Widget>[
                RatingBarIndicator(
                  rating:item['rating']['value'] > 0 ? item['rating']['value']:0,
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
                Text('${((DateTime.now().millisecondsSinceEpoch - DateTime.parse(item['created_at']).millisecondsSinceEpoch) / 1000 / 60 / 60 / 24 / 31).round()}个月前',style: TextStyle(color: widget._isDark ? Colors.white54:Colors.grey[600],fontSize: 12))
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_horiz,color:widget._isDark ?Colors.white54:Colors.grey[600]),
              onPressed: (){
                print('object');
                showCupertinoModalPopup(
                  context: context,
                  builder: (context){
                    return CupertinoActionSheet(
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text('分享'),
                          onPressed: () { /** */ },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('举报'),
                          onPressed: () { /** */ },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        isDefaultAction: true,
                        child: Text('取消'),
                        onPressed: () { /** */ },
                      ),
                    );
                  }
                );
              },
            )
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('${item['content']}',style: TextStyle(color: _baseTextColor),maxLines: item['showMore'],overflow: TextOverflow.ellipsis),
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenAdapter.width(20),top: ScreenAdapter.height(10)),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  item['showMore'] = item['showMore'] == 6 ? 15:6;
                });
              },
              child: Text('${item['showMore'] == 6 ? '展开':'收起'}',style: TextStyle(color:Colors.grey,fontSize: 14)),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Icon(Icons.thumb_up,color: _baseTextColor,size: 15,),
                SizedBox(width: ScreenAdapter.width(20)),
                Text('${item['useful_count'] ?? 0}',style: TextStyle(color: _baseTextColor))
              ],
            ),
          )
        ],
      ),
    );
  }

}