import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BaseLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}