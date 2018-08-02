import 'package:flutter/material.dart';
import 'news_home.dart';
import 'favor_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  Route<dynamic> _getRoute(RouteSettings settings) {
    //这个函数是动态路由，目前返回null
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '我的新闻',
      theme: new ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new NewsHome(),
        '/favorlist': (BuildContext context) => new FavorList(),
      },
      onGenerateRoute: _getRoute,
    );
  }
}