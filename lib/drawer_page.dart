import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'utils/file_util.dart';
import 'utils/route_util.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();
const String picturePath = "bd_user_pic_path.png";

class DrawerBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    _DrawerBodyState view = new _DrawerBodyState();
    return view;
  }
}

class _DrawerBodyState extends State<DrawerBody> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    int len = await image.length();
    print('len=$len');
    if(len>0){
      FileUtil.saveImageFile(picturePath, image);
      setState(() {
        _image = image;
      });
    }
  }

  void _onSelectPicture(){
    getImage();
  }

  Future getOriImage() async {
    File image = await FileUtil.getLocalFile(picturePath);
    print(image);
    if(image!=null){
      setState(() {
        _image = image;
      });
    }
  }

  void _gotoBaiduIndex(){
    RouteUtil.route2Web(context, '百度搜索', 'http://www.baidu.com');
  }

  void _gotoBaiduMap(){
    RouteUtil.route2Web(context, '百度地图', 'http://map.baidu.com');
  }

  void _gotoAbout(){
    RouteUtil.route2Web(context, '关于', 'http://0.0.0.0:8080/index.html',nohttps:true);
  }

  void _gotoVideo(){
    Navigator.pushNamed(context, "/video");
  }

  @override
  void initState() {
    getOriImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        DrawerHeader(
          margin: const EdgeInsets.only(bottom:6.0),
          padding: const EdgeInsets.all(0.0),
          child: Container(
            color: Colors.blue,
            child: Center(
              child: GestureDetector(
                onTap: ()=>_onSelectPicture(),
                child: new ClipOval(
                  child: new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: _image != null
                        ? new Image.file(_image,fit: BoxFit.fill,)
                        : new Image.asset("images/userpic.jpeg",fit: BoxFit.fill,),
                  ),
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
        InkWell(
          onTap: () {_gotoBaiduIndex();},
          child: ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('百度搜素'),
            enabled: true,
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () {_gotoBaiduMap();},
          child: ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('百度地图'),
            enabled: true,
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () {_gotoAbout();},
          child: ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('关于我们'),
            enabled: true,
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () {_gotoVideo();},
          child: ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text('视频'),
            enabled: true,
          ),
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