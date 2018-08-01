import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'utils/file_util.dart';

const String picturePath = "bd_user_pic_path";

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
    if(image!=null){
      FileUtil.saveImageFile(picturePath, image);
    }
    setState(() {
      _image = image;
    });
  }

  void _onSelectPicture(){
    getImage();
  }

  Future getOriImage() async {
    _image = await FileUtil.getLocalFile(picturePath);
    setState(() {

    });
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
                        : new Image.network("https://sfault-avatar.b0.upaiyun.com/206/120/2061206110-5afe2c9d40fa3_huge256",fit: BoxFit.fill,),
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