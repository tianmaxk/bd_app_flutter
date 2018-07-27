import 'package:flutter/material.dart';
import 'dart:async';

const Duration _kBottomSheetDuration = const Duration(milliseconds: 200);

class ImageContent extends StatelessWidget {
  ImageContent({Key key, this.imageurl}) : super(key: key);
  String imageurl = null;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Image.network(imageurl),
    );
  }
}

class BigImage {
  BigImage({Key key, this.context});
  BuildContext context = null;
  RouteSettings settings = null;

  Future<Null> show(String imageurl) async {
    bool value = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) { return new ImageContent(imageurl: imageurl);}
    );
  }
}

