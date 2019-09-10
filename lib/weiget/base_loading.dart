import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BaseLoading extends StatelessWidget {

  final String type;
  BaseLoading({@required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:type.isEmpty ?  Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(),
          ],
        ),
      ):Text('$type'),
    );
  }
}