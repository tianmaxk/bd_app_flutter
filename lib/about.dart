import 'package:flutter/material.dart';

class About extends StatelessWidget {
  About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('关于我们'),
          //为AppBar对象的actions属性添加一个IconButton对象，actions属性值可以是Widget类型的数组
//          actions: <Widget>[
//            new IconButton(icon: isFavor?new Icon(Icons.favorite):new Icon(Icons.favorite_border), onPressed: _onFavor),
//            new IconButton(icon: new Icon(Icons.web), onPressed: _gotoWeb)
//          ],
        ),
        body: new Text("欢迎")
    );
  }
}