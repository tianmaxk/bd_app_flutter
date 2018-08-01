import 'package:flutter/material.dart';
import 'dart:async';
//import '../utils/scalableImage.dart';
import 'package:flutter_advanced_networkimage/zoomable_widget.dart';

class ImageContent extends StatefulWidget {
  ImageContent({Key key, this.imageurl}) : super(key: key);
  String imageurl = null;

  @override
  _ImageContent createState() => new _ImageContent(imageurl:imageurl);

}

class _ImageContent extends State<ImageContent> {
  _ImageContent({this.imageurl});
  String imageurl = null;

  @override
  void initState() {

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
        child: ZoomableWidget(
          maxScale: 16.0,
          minScale: 0.5,
          child: Image.network(imageurl),
        ),
//      child: new ScalableImage(
//        imageProvider: new NetworkImage(imageurl),
//        dragSpeed: 4.0,
//        maxScale: 16.0,
//        wrapInAspect: true,
//        enableScaling: true,
//        screenSize: MediaQuery.of(context).size,
//      ),
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

