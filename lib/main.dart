import 'package:flutter/material.dart';
import 'news_home.dart';
import 'favor_list.dart';
import 'about.dart';
import 'package:jaguar/jaguar.dart' show Jaguar;
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  Route<dynamic> _getRoute(RouteSettings settings) {
    //这个函数是动态路由，目前返回null
    return null;
  }

  buildAssetServer() async {
    final server = new Jaguar();
    server.addApi(new FlutterAssetServer());
    await server.serve();

    server.log.onRecord.listen((r) => print(r));
  }

  @override
  Widget build(BuildContext context) {
    buildAssetServer();
    return new MaterialApp(
      title: '我的新闻',
      theme: new ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new NewsHome(),
        '/favorlist': (BuildContext context) => new FavorList(),
        '/about': (BuildContext context) => new About(),
      },
      onGenerateRoute: _getRoute,
    );
  }
}