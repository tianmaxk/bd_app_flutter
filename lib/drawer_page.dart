import 'package:flutter/material.dart';

class DrawerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _DrawerBodyState view = new _DrawerBodyState();
    return view;
  }
}

class _DrawerBodyState extends State<DrawerBody> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        DrawerHeader(
          margin: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.all(0.0),
          child: Container(
            color: Colors.blue,
            child: Center(
//                child: const Text(
//                  '新闻类别',
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 18.0
//                  ),
//                )
              child: new ClipOval(
                child: new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: new Image.network("https://sfault-avatar.b0.upaiyun.com/206/120/2061206110-5afe2c9d40fa3_huge256",fit: BoxFit.fill,),
                ),
              ),
            ),
          ),
        ),
        const ListTile(
          leading: const Icon(Icons.assessment),
          title: const Text('百度新闻'),
//            selected: true,
        ),
        const Divider(),
        const ListTile(
          leading: const Icon(Icons.account_balance),
          title: const Text('腾讯新闻'),
          enabled: true,
        ),
      ],
    );
  }
}

class DrawerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new DrawerBody(),
    );
  }
}