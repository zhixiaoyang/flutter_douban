import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jahn_douban/pages/home/home.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {

  // 倒计时时间
  int _time = 3;

  // 计时器
  Timer _timer;

  @override
  void initState() { 
    super.initState();
    // 隐藏状态栏
    SystemChrome.setEnabledSystemUIOverlays([]);
    //  执行定时器
    _timer = Timer.periodic(Duration(seconds: 1),(timer){
      if(_time == 1){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
          return HomePage();
        }), (Route route) => false);
        timer.cancel();
      }
      setState(() {
       _time = _time - 1; 
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 取消定时器
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromRGBO(255, 255, 255,1),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0,20,20,0),
            alignment: Alignment.centerRight,
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey,width: 1)
              ),
              alignment: Alignment.center,
              width: 80,
              height: 30,
              child: InkWell(
                highlightColor:Colors.transparent,
                radius: 0.0,
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                    return HomePage();
                  }), (Route route) => false);
                },
                child: Text('跳过 ${_time}s'),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Image.asset('lib/assets/launchPage/splash_bg.jpg',fit: BoxFit.contain,),
          ),
          Expanded(
            flex: 1,
            child: Text('来豆瓣，记录你的书影音生活',style: TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }

}