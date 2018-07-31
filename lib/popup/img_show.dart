import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scalable_image/scalable_image.dart';

class ImageContent extends StatefulWidget {
  ImageContent({Key key, this.imageurl}) : super(key: key);
  String imageurl = null;

  @override
  _ImageContent createState() => new _ImageContent(imageurl:imageurl);

}

class _ImageContent extends State<ImageContent> {
  _ImageContent({this.imageurl});
  String imageurl = null;
//  double imgwidth = 0.0;
//  double imgheight = 0.0;
//  double screenwid = 0.0;
//  double screenhei = 0.0;
//  double imagescale = 1.0;
//  double lastscale = 1.0;
//  double leftscroll = 0.0;
//  double topscroll = 0.0;
//  ScrollController _scrollController = new ScrollController();
//  ScrollController _verscrollController = new ScrollController();

  @override
  void initState() {

  }

  @override
  void dispose() {
//    _scrollController.dispose();
//    _verscrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    screenwid = MediaQuery.of(context).size.width;
//    screenhei = MediaQuery.of(context).size.height;
//    print('screenwid='+screenwid.toString()+', screenhei='+screenhei.toString());
//    if(imgwidth<=0.0){
//      imgwidth = screenwid;
//      imgheight = screenhei;
//    }
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
//      child: GestureDetector(
//        onScaleUpdate: (ScaleUpdateDetails details)=>onUpdateScaleImage(details),
//        onScaleEnd: (ScaleEndDetails details)=>onScaleImage(details),
        child: new ScalableImage(
          imageProvider: new NetworkImage(imageurl),
          dragSpeed: 4.0,
          maxScale: 16.0,
          wrapInAspect: true,
          enableScaling: true,
        ),
//      ),
    );
//    return Container(
//      color: Colors.black,
//      child: SingleChildScrollView(
//        controller: _verscrollController,
//        child:SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//          controller: _scrollController,
//          child: GestureDetector(
//            onScaleUpdate: (ScaleUpdateDetails details)=>onUpdateScaleImage(details),
//            onScaleEnd: (ScaleEndDetails details)=>onScaleImage(details),
//            child: SizedBox(
//              child: img,
//              width: imgwidth,
//              height: imgheight,
//            ),
//          ),
//        ),
//      ),
//    );
  }

//  onUpdateScaleImage(ScaleUpdateDetails details){
//    setState(() {
//      imagescale = lastscale * details.scale;
//      imgwidth = imagescale * screenwid;
//      imgheight = imagescale * screenhei;
//      leftscroll = (imagescale-1) * screenwid / 2;
//      topscroll = (imagescale-1) * screenhei / 2;
//      print(imagescale);
////      print(_scrollController.position);
////      print(_verscrollController.position);
//      if(leftscroll>=0){
//        _scrollController.animateTo(leftscroll, duration: new Duration(milliseconds: 1), curve: Curves.ease);
//        _verscrollController.animateTo(topscroll, duration: new Duration(milliseconds: 1), curve: Curves.ease);
//      }
//    });
//
//  }
//
//  onScaleImage(ScaleEndDetails details){
//    lastscale = imagescale;
//  }
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

