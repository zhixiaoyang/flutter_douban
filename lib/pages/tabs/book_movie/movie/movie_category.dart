import 'package:flutter/material.dart';
import 'package:flutter_jahn_douban/utils/screenAdapter/screen_adapter.dart';

class MovieCategory extends StatelessWidget {

  final List _categoryList = [
    {'icon':Icons.ac_unit,'title':'找电影','color':Color.fromRGBO(111, 152, 243, 1)},
    {'icon':Icons.ac_unit,'title':'豆瓣榜单','color':Color.fromRGBO(242, 175, 54, 1)},
    {'icon':Icons.ac_unit,'title':'豆瓣猜','color':Color.fromRGBO(93, 191, 85, 1)},
    {'icon':Icons.ac_unit,'title':'豆瓣片单','color':Color.fromRGBO(137, 111, 217, 1)},
  ];

  @override
  Widget build(BuildContext context) {
   return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:_categoryList.map((item){
        return GestureDetector(
          onTap: (){
            print('${item['title']}');
          },
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(ScreenAdapter.width(20)),
                decoration: BoxDecoration(
                  color: item['color'], 
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Icon(item['icon'],color: Colors.white,),
              ),
              SizedBox(height: ScreenAdapter.height(20)),
              Text(item['title'])
            ],
          ),
        );
      }).toList(),
    );
  }
}