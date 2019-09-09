import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BaseLoading extends StatelessWidget {

  final type;
  BaseLoading({this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: type == null ?  Padding(
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