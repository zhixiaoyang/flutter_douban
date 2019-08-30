import 'package:flutter/material.dart';

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
            CircularProgressIndicator(
              strokeWidth: 2,
            ),
            SizedBox(width: 10),
            Text('加载中...',style: TextStyle(fontSize: 22,color: Colors.grey))
          ],
        ),
      ),
    );
  }
}