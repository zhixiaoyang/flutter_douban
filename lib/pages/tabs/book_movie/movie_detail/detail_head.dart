import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class DetailHead extends StatefulWidget {

  Map _movie;
  bool _isDark;
  DetailHead(this._movie,this._isDark);

  @override
  _DetailHeadState createState() => _DetailHeadState();
}

class _DetailHeadState extends State<DetailHead> {

  Color _baseTextColor;

  @override
  void initState() { 
    super.initState();
    _baseTextColor = widget._isDark == true ? Colors.white:Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network('${widget._movie['images']['small']}',fit: BoxFit.cover,width: ScreenAdapter.width(200),height: ScreenAdapter.height(260),),
          ),
          SizedBox(width: ScreenAdapter.width(30)),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: ScreenAdapter.height(260)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
                    child: Text('${widget._movie['title']}',style: TextStyle(color:_baseTextColor,fontSize: 24,fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
                    alignment: Alignment.centerLeft,
                    child: Text('${widget._movie['original_title']}',style: TextStyle(color: _baseTextColor,fontSize: 18)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
                    child: Text('${widget._movie['countries'][0]} / ${widget._movie['genres'][0]} / ${widget._movie['pubdate']}上映 / 片长${widget._movie['durations'].length != 0 ? widget._movie['durations'][0]:'暂无'}',style: TextStyle(fontSize: 12,color: widget._isDark ? Colors.grey[300]:Colors.grey[600])),
                  ),
                  Row(
                    children: <Widget>[
                      _iconbtn(Icons.favorite_border,'想看'),
                      SizedBox(width: ScreenAdapter.width(30)),
                      _iconbtn(Icons.star_border,'看过')
                    ],
                  )
                ],
              ),
            ), 
          ),
        ],
      ),
    );
  }

  Widget _iconbtn(icon,text){
    return Expanded(
      child: Container(
        height: ScreenAdapter.height(60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: (){
            
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(icon,color: Colors.orange,size: 15,),
              SizedBox(width: ScreenAdapter.width(15)),
              Text(text,style: TextStyle(color: Colors.black),)
            ],
          ),
        ),
      ),
    );
  }  

}