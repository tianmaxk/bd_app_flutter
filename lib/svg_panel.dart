import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVGPanel extends StatefulWidget {
  const SVGPanel({Key key}) : super(key: key);

  @override
  _SVGPageState createState() => new _SVGPageState();
}

class _SVGPageState extends State<SVGPanel> {
  final List<Widget> _painters = <Widget>[];
  double _dimension;

  @override
  void initState() {
    super.initState();
    _dimension = 250.0;

    _painters.add(new SvgPicture.string(
        '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
    <g fill="none" fill-rule="evenodd" stroke="#a9afb7" stroke-width="1.68331" transform="matrix(.9790233 0 0 .9790233 .251231 .251564)">
        <path d="m12.000501.58461768c-6.3013618 0-11.41554265 5.11452052-11.41554265 11.41554132 0 6.301361 5.11452045 11.415543 11.41554265 11.415543 6.30136 0 11.415541-5.114522 11.415541-11.415543 0-6.3013604-5.114521-11.41554132-11.415541-11.41554132z"/>
        <path d="m4.0283015 19.966358c.040271-2.293185 4.3628812-3.890093 7.9721995-3.890093 3.601731 0 7.931893 1.598153 7.972197 3.890093"/>
        <path d="m12.000501 6.4340216c2.34866 0 4.245589 1.8969293 4.245589 4.2455894 0 2.34866-1.896929 4.245591-4.245589 4.245591-2.3486611 0-4.2455906-1.896931-4.2455906-4.245591 0-2.3486601 1.8969295-4.2455894 4.2455906-4.2455894z"/>
    </g>
</svg>
'''));

    _painters.add(
      new SvgPicture.asset('assets/earth.svg'),
    );

//    for (int i = 0; i < iconNames.length; i++) {
//      _painters.add(
//        new Directionality(
//          textDirection: TextDirection.ltr,
//          child: new SvgPicture.asset(
//            iconNames[i],
//            color: Colors.blueGrey[(i + 1) * 100],
//            matchTextDirection: true,
//          ),
//        ),
//      );
//    }

//    for (String uriName in uriNames) {
//      _painters.add(
//        new SvgPicture.network(
//          uriName,
//          placeholderBuilder: (BuildContext context) => new Container(
//              padding: const EdgeInsets.all(30.0),
//              child: const CircularProgressIndicator()),
//        ),
//      );
//    }
//    _painters
//        .add(new AvdPicture.asset('assets/android_vd/battery_charging.xml'));
  }

  @override
  Widget build(BuildContext context) {
    if (_dimension > MediaQuery.of(context).size.width - 10.0) {
      _dimension = MediaQuery.of(context).size.width - 10.0;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('SVG展示'),
      ),
      body: new Column(children: <Widget>[
        new Slider(
            min: 5.0,
            max: MediaQuery.of(context).size.width - 10.0,
            value: _dimension,
            onChanged: (double val) {
              setState(() => _dimension = val);
            }),
        // new FlutterLogo(size: _dimension),
        // new Container(
        //   padding: const EdgeInsets.all(12.0),
        // child:

        // )
        new Expanded(
          child: new GridView.extent(
            shrinkWrap: true,
            maxCrossAxisExtent: _dimension,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: _painters.toList(),
          ),
        ),
      ]),
    );
  }
}
