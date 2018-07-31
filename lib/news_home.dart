import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'news_details.dart';

Map<String,Object> newsListMap = {};

class Choice {
  Choice({ this.title, this.active });
  String title;
  bool active;
}

const defCategory = <String>['推荐','本地','娱乐','社会','军事','互联网','科技','国际','国内','体育','房产','财经','时尚','教育','游戏','旅游','人文','创意'];

class NewsHome extends StatelessWidget {
  List<Choice> choices = <Choice>[];

  List<Choice> buildCategory(){
    List<Choice> ret = <Choice>[];
    for(var category in defCategory){
      ret.add(new Choice(title:category,active:false));
    }
    ret[0].active = true;
    return ret;
  }

  void _onSearch() {

  }

  void _handlePopupMenu(BuildContext context, String value){

  }

  @override
  Widget build(BuildContext context) {
    choices = buildCategory();
    return new DefaultTabController(
      length: choices.length,
      child: new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('百度新闻'),
          //为AppBar对象的actions属性添加一个IconButton对象，actions属性值可以是Widget类型的数组
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.search), onPressed: _onSearch),
            new PopupMenuButton<String>(
              onSelected: (String value) { _handlePopupMenu(context, value); },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                  value: 'myfavor',
                  child: const Text('我的收藏'),
                ),
                const PopupMenuItem<String>(
                  value: 'history',
                  child: const Text('浏览历史'),
                ),
              ],
            ),
          ],
          bottom: new TabBar(
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return new Tab(
                text: choice.title,
              );
            }).toList(),
          ),
        ),
        body: new TabBarView(
          children: choices.map((Choice choice) {
            return new NewsList(category: choice.title);
          }).toList(),
        ),
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  NewsList({Key key, this.category}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String category;

  @override
  _NewsListState createState() => new _NewsListState(category: category);
}

class _NewsListState extends State<NewsList> {
  _NewsListState({this.category});
  final String category;
  List<Object> _newslist = [];

  @override
  void initState(){
    _getNewsList(category);
  }

  @override
  //构建一个脚手架，里面塞入前面定义好的_buildNews类
  Widget build(BuildContext context) {
    if(newsListMap[category]==null || _newslist.length>0){
      newsListMap[category] = _newslist;
    } else {
      _newslist = newsListMap[category];
    }
    print('_newslist.length='+_newslist.length.toString());
    if(_newslist.length<=0){
      return new Center(child: Image.asset(
        'images/loading.gif',
        width: 40.0,
        height: 40.0,
        fit: BoxFit.cover,
      ),);
    }
    return new RefreshIndicator(
      child: new ListView.builder(
        //ListView(列表视图)是material.dart中的基础控件
        padding: const EdgeInsets.all(0.0), //padding(内边距)是ListView的属性，配置其属性值
        physics: new AlwaysScrollableScrollPhysics(),
        //通过ListView自带的函数itemBuilder，向ListView中塞入行，变量 i 是从0开始计数的行号
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider(); //奇数行塞入分割线对象
          final index = i ~/ 2; //当前行号除以2取整，得到的值就是_suggestions数组项索引号
          if(index>_newslist.length-1){
            return null;
          }
          print('_newslist.length='+_newslist.length.toString());
          return _buildRow(_newslist[index]); //把这个数据项塞入ListView中
        },
        shrinkWrap: true,
      ),
      onRefresh: () async {
        setState(() {
          _newslist.clear();
        });
        _getNewsList(category);
        return null;
      },
    );
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('yyyy-MM-dd HH:mm');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp*1000);
    var diff = date.difference(now);
    print("timestamp="+timestamp.toString()+" diff="+diff.toString());
    return format.format(date);
  }

  _getNewsList(String category) async {
    var newslst = await Api().getNewsList(category:category);
    var newsjson = newslst['data']['news'];
    print(newsjson);
    setState(() {
      _newslist = newsjson;
    });
  }

  _onSelectNews(var newsinfo){
    print(newsinfo);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => new NewsDetails(newsInfo: newsinfo),
      )
    );
  }

  //定义的_newslist数组项属性
  Widget _buildRow(var news) {
    print(news['title']);
    Widget OneImg = Container();
    Widget ThreeImgs = Container();
    if(news['imageurls']!=null && news['imageurls'].length>=3){
      ThreeImgs = Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(right: 4.0,top:4.0),
                  child: new Image.network(news['imageurls'][0]['url_webp'])
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(left: 2.0, right: 2.0,top:4.0),
                  child: new Image.network(news['imageurls'][1]['url_webp'])
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(left: 4.0,top:4.0),
                  child: new Image.network(news['imageurls'][2]['url_webp'])
              ),
            ),
          ]
      );
    } else if (news['imageurls']==null || news['imageurls'].length==0) {

    } else {
      print(news['imageurls'][0]['url_webp']);
      OneImg = new Expanded(
          flex:1,
          child:Container(
              padding: const EdgeInsets.only(right: 6.0),
              child: new Image.network(news['imageurls'][0]['url_webp'])
          )
      );
    }

    Widget ret = Container(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: ()=>_onSelectNews(news),
        child: Row(
          children: [
            OneImg,
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      news['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                      ),
                    ),
                  ),
                  Row(
                      children: [
                        Text(
                          readTimestamp(int.parse(news['ts'])),
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            news['site'],
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        )
                      ]
                  ),
                  ThreeImgs,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return ret;
  }
}

const test = '''
{"news":[{
			"nid": "8921235368227084544",
			"sourcets": "1532310031000",
			"ts": "1532310635000",
			"title": "北京树龄最长古树已3500岁 树干要9人才能环抱",
			"url": "http://baijiahao.baidu.com/s?id=1606743218733191136&wfr=newsapp",
			"imageurls": [{
				"url": "http://t10.baidu.com/it/u=25088772,4079781579&fm=173&app=25&f=JPEG?w=218&h=146&s=883284194F8178D8586D5DD20100C0B1",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=cd4a1777d796ed2f16cd257e52ad2534&er=1&src=http://t10.baidu.com/it/u=25088772,4079781579&fm=173&app=25&f=JPEG?w=218&h=146&s=883284194F8178D8586D5DD20100C0B1"
			}],
			"site": "环球网",
			"type": "text",
			"abs": "span class='bjh-p'>在北京密云区新城子镇新城子村村口，远远便能看见路边挺立着...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606743218733191136&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "ad07c215"
		}, {
			"nid": "9002040466426767301",
			"sourcets": "1532309409000",
			"ts": "1532310568000",
			"title": "大数据住房租金指数：西安、北京、青岛上半年租金涨幅居前三",
			"url": "http://baijiahao.baidu.com/s?id=1606742619942960090&wfr=newsapp",
			"imageurls": [{
				"url": "http://t11.baidu.com/it/u=4288528444,3413275900&fm=173&app=25&f=JPEG?w=218&h=146&s=C0124633DEE8440900EB30D60300C0A2",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=c8c91f9c876bdbf656193274920b29e2&er=1&src=http://t11.baidu.com/it/u=4288528444,3413275900&fm=173&app=25&f=JPEG?w=218&h=146&s=C0124633DEE8440900EB30D60300C0A2"
			}, {
				"url": "http://t12.baidu.com/it/u=2024092337,1900746544&fm=173&app=25&f=JPEG?w=218&h=146&s=C0124632CCF8440960EB30D60300D0A2",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=b816f8821400dc97a957acefd07b4a48&er=1&src=http://t12.baidu.com/it/u=2024092337,1900746544&fm=173&app=25&f=JPEG?w=218&h=146&s=C0124632CCF8440960EB30D60300D0A2"
			}, {
				"url": "http://t12.baidu.com/it/u=670576796,2989160425&fm=173&app=25&f=JPEG?w=218&h=146&s=C012C633CEE84409006B30D60300C0A2",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=61d78fb82ba957143a9e78f0d21861b4&er=1&src=http://t12.baidu.com/it/u=670576796,2989160425&fm=173&app=25&f=JPEG?w=218&h=146&s=C012C633CEE84409006B30D60300C0A2"
			}],
			"site": "环球网",
			"type": "text",
			"abs": "spanclass='bjh-p'>转自微信公众号、住房大数据</span>。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606742619942960090&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "58276619"
		}, {
			"nid": "9261701450291594219",
			"sourcets": "1532310053000",
			"ts": "1532311001000",
			"title": "北京发布地质灾害蓝色预警，这些地区有泥石流等风险",
			"url": "http://baijiahao.baidu.com/s?id=1606743537992780051&wfr=newsapp",
			"imageurls": [{
				"url": "http://t12.baidu.com/it/u=2382319880,2061683509&fm=173&app=25&f=JPEG?w=218&h=146&s=97A4D804601717C60E8C6D990300E080",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=4566eb97f4d979101aa82d1306b2626d&er=1&src=http://t12.baidu.com/it/u=2382319880,2061683509&fm=173&app=25&f=JPEG?w=218&h=146&s=97A4D804601717C60E8C6D990300E080"
			}],
			"site": "北京日报",
			"type": "text",
			"abs": "spanclass='bjh-p'>北京市规划国土委和市气象局23日09时联合继续发布地质灾害...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606743537992780051&wfr=newsapp",
			"topic": [],
			"long_abs": "",
			"has_related": [],
			"tag": [],
			"content": [],
			"site": "小帅谈旅游",
			"type": "text",
			"abs": "<spanclass='bjh-br'></span>地址：北京西城区西四南大街</span>。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606740970471416474&wfr=newsapp",
			"topic": [],
			"long_abs": "",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "3a84462a"
		}, {
			"nid": "10074552899130876579",
			"sourcets": "1532305854000",
			"ts": "1532306452000",
			"title": "不一的旅游：历史悠久的隋朝大运河，快来北京看看吧！",
			"url": "http://baijiahao.baidu.com/s?id=1606684349961644739&wfr=newsapp",
			"imageurls": [{
				"url": "http://t11.baidu.com/it/u=2313824353,4012607935&fm=173&app=25&f=JPEG?w=218&h=146&s=F618402143124D6E5E4939D20100F0B3",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=be3789a098896023abbc8c263be77c06&er=1&src=http://t11.baidu.com/it/u=2313824353,4012607935&fm=173&app=25&f=JPEG?w=218&h=146&s=F618402143124D6E5E4939D20100F0B3"
			}, {
				"url": "http://t11.baidu.com/it/u=257663509,2257522317&fm=173&app=25&f=JPEG?w=218&h=146&s=9E8A26C0C6B4C5CE068D64000300E0D6",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=37fb7efa1b1930d7c4b27bcd429ca3a5&er=1&src=http://t11.baidu.com/it/u=257663509,2257522317&fm=173&app=25&f=JPEG?w=218&h=146&s=9E8A26C0C6B4C5CE068D64000300E0D6"
			}, {
				"url": "http://t10.baidu.com/it/u=2711961591,1784891047&fm=173&app=25&f=JPEG?w=218&h=146&s=95A24CB6481294CA1CB3BCB203007049",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=433e9bd0b50ee5bc4b91477a566e04a2&er=1&src=http://t10.baidu.com/it/u=2711961591,1784891047&fm=173&app=25&f=JPEG?w=218&h=146&s=95A24CB6481294CA1CB3BCB203007049"
			}],
			"site": "不一的旅游",
			"type": "text",
			"abs": "spanclass='bjh-p'>当我告诉北京人我要去他们城市的行程时，他们都点头表示同意。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606684349961644739&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "4c9c0a67"
		}, {
			"nid": "10197735687953529601",
			"sourcets": "1532306699000",
			"ts": "1532307076000",
			"title": "【北京】7/23 雷阵雨 微风 空气质量良",
			"url": "http://baijiahao.baidu.com/s?id=1606739988518465479&wfr=newsapp",
			"imageurls": [{
				"url": "http://t12.baidu.com/it/u=264987179,2486215973&fm=173&app=25&f=JPEG?w=218&h=146&s=7083DE1618227D015C8E88E403007033",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=04d3173600615dc81f21196c08aee099&er=1&src=http://t12.baidu.com/it/u=264987179,2486215973&fm=173&app=25&f=JPEG?w=218&h=146&s=7083DE1618227D015C8E88E403007033"
			}, {
				"url": "http://t11.baidu.com/it/u=2138882638,3951099281&fm=173&app=25&f=JPEG?w=218&h=146&s=F0338F741F087849166AC4420300F0B9",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=b22c17b258fcacf89bbad9b8b281d97d&er=1&src=http://t11.baidu.com/it/u=2138882638,3951099281&fm=173&app=25&f=JPEG?w=218&h=146&s=F0338F741F087849166AC4420300F0B9"
			}, {
				"url": "http://t12.baidu.com/it/u=2422150871,3554961315&fm=173&app=25&f=JPEG?w=218&h=146&s=780BCE161B327009DECE8A60030060F3",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=c0d464831cd151bc9bfe78190e332439&er=1&src=http://t12.baidu.com/it/u=2422150871,3554961315&fm=173&app=25&f=JPEG?w=218&h=146&s=780BCE161B327009DECE8A60030060F3"
			}],
			"site": "智能天气播报",
			"type": "text",
			"abs": "北京，白天雷阵雨，最高气温32℃，微风，空气质量良；夜间中雨，最低气温25℃，微风。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606739988518465479&wfr=newsapp",
			"topic": [],
			"long_abs": "",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "4dc33216"
		}, {
			"nid": "9186323356826139197",
			"sourcets": "1532303653000",
			"ts": "1532306958000",
			"title": "个人之变，80后“北漂”的成熟时刻",
			"url": "http://baijiahao.baidu.com/s?id=1606476798500580081&wfr=newsapp",
			"imageurls": [{
				"url": "http://t10.baidu.com/it/u=2763248739,3588180965&fm=173&app=25&f=JPEG?w=218&h=146&s=D011837556667B17568090F90300C020",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=b1aa8333b326c72773f05ec25c281970&er=1&src=http://t10.baidu.com/it/u=2763248739,3588180965&fm=173&app=25&f=JPEG?w=218&h=146&s=D011837556667B17568090F90300C020"
			}, {
				"url": "http://t10.baidu.com/it/u=229392477,3907775219&fm=173&app=25&f=JPEG?w=218&h=146&s=BE996481944646FED8247DA20300A011",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=ad2e9b3b86fbe63cbacf33893d1f17e1&er=1&src=http://t10.baidu.com/it/u=229392477,3907775219&fm=173&app=25&f=JPEG?w=218&h=146&s=BE996481944646FED8247DA20300A011"
			}, {
				"url": "http://t10.baidu.com/it/u=2014159050,1873685717&fm=173&app=25&f=JPEG?w=218&h=146&s=FAABF54844025755CA0C2018030080D2",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=d2c2bb17441e8684adf1ccbc8dad2426&er=1&src=http://t10.baidu.com/it/u=2014159050,1873685717&fm=173&app=25&f=JPEG?w=218&h=146&s=FAABF54844025755CA0C2018030080D2"
			}],
			"site": "简单de金色",
			"type": "text",
			"abs": "spanclass='bjh-p'>2015年，张艳把它定义为自己的承上启下年。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606476798500580081&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "e60d7c59"
		}, {
			"nid": "9388473293975285520",
			"sourcets": "1532304030000",
			"ts": "1532304872000",
			"title": "北京密云 172 名因强降雨被困群众全部脱险",
			"url": "http://baijiahao.baidu.com/s?id=1606737230668706206&wfr=newsapp",
			"imageurls": [{
				"url": "http://t11.baidu.com/it/u=3701628250,1966111696&fm=173&app=25&f=JPEG?w=218&h=146&s=74AAB7F10CD344D21A9504A803007011",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=09055cf42795fac890b6615d7d3b3130&er=1&src=http://t11.baidu.com/it/u=3701628250,1966111696&fm=173&app=25&f=JPEG?w=218&h=146&s=74AAB7F10CD344D21A9504A803007011"
			}, {
				"url": "http://t12.baidu.com/it/u=3624945302,2964501612&fm=173&app=25&f=JPEG?w=218&h=146&s=FFD069890A2B008066B1ACB003003090",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=2334f602ffb930d2ff4166bb4ec69f21&er=1&src=http://t12.baidu.com/it/u=3624945302,2964501612&fm=173&app=25&f=JPEG?w=218&h=146&s=FFD069890A2B008066B1ACB003003090"
			}, {
				"url": "http://t12.baidu.com/it/u=1244525525,1001632496&fm=173&app=25&f=JPEG?w=218&h=146&s=B0B976910231BFDEEE85500C030070C0",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=00192b1f4c02bcdb130130906551fe75&er=1&src=http://t12.baidu.com/it/u=1244525525,1001632496&fm=173&app=25&f=JPEG?w=218&h=146&s=B0B976910231BFDEEE85500C030070C0"
			}],
			"site": "北青网",
			"type": "text",
			"abs": "14 时 48 分，第一批被困群众被直升机救援人员成功转移。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606737230668706206&wfr=newsapp",
			"topic": [],
			"long_abs": "央广网北京 7 月 22 日消息22 日晚，记者从北京市公安局了解到，近日因强降雨被困于密云石城镇的 172 名群众，均已全部脱险。14 时 48 分，第一批被困群众被直升机救援人员成功转移。",
			"has_related": [],
			"tag": [],
			"content": [],
			"site": "人民网北京",
			"type": "text",
			"abs": "为打击黑摩的，警方运用非现场执法手段，前期已组织力量进行取证，录了大量视频。",
			"display_type": 1,
			"display_url": "http://bj.people.com.cn/n2/2018/0723/c82838-31846151.html",
			"topic": [],
			"long_abs": "据了解，为净化道路交通环境秩序，全环节综合执法打击整治“黑摩的”专项行动八月底前将每周至少开展一次。城管队员也呼吁广大市民，出行的时候请尽量选择公共交通、正规出租车、共享单车，不要因为价格便宜或者图方便选择黑摩的，一旦发生人身、财产损失，很难维护自己的正当权益。",
			"has_related": [],
			"tag": [],
			"content": [],
			"site": "中国新闻网",
			"type": "text",
			"abs": "类似东西城这样的变化越来越多地出现在北京市民身边，胡同亮起来了、绿色多起来了，总规的落实让市民...",
			"display_type": 1,
			"display_url": "http://www.chinanews.com/gn/2018/07-23/8575549.shtml",
			"topic": [],
			"long_abs": "类似东西城这样的变化越来越多地出现在北京市民身边，胡同亮起来了、绿色多起来了，总规的落实让市民更有获得感。出现阐述“都”与“城”、“舍”与“得”、疏解与提升、“一核”与“两翼”的关系……总共6万余字、规划期到2035年并远景展望2050年的《北京城市总体规划》去年9月公布以来，全市上下积极落实，精心组织实施新一版北京城市总体规划，力争早日把宏伟蓝图变为现实。",
			"has_related": [],
			"tag": ["房企"],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "c7b104a6"
		}, {
			"nid": "9327881643634397920",
			"sourcets": "1532270220000",
			"ts": "1532310891000",
			"title": "北京1998，我很怀念她",
			"url": "http://baijiahao.baidu.com/s?id=1606701708436987486&wfr=newsapp",
			"imageurls": [{
				"url": "http://t11.baidu.com/it/u=1046381077,250680462&fm=173&app=25&f=JPEG?w=218&h=146&s=9E8B7223662240B8DE3D09D7010080A0",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=2aa472a1e97632f91093df3c1f85b72d&er=1&src=http://t11.baidu.com/it/u=1046381077,250680462&fm=173&app=25&f=JPEG?w=218&h=146&s=9E8B7223662240B8DE3D09D7010080A0"
			}, {
				"url": "http://t10.baidu.com/it/u=3418422060,360476783&fm=173&app=25&f=JPEG?w=218&h=146&s=6CC27A2337C31FE12E09ECB10100C091",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=aef0dfd07d3be42d0ec763f21b488721&er=1&src=http://t10.baidu.com/it/u=3418422060,360476783&fm=173&app=25&f=JPEG?w=218&h=146&s=6CC27A2337C31FE12E09ECB10100C091"
			}, {
				"url": "http://t12.baidu.com/it/u=2741585876,3806095357&fm=173&app=25&f=JPEG?w=218&h=146&s=C8C27A2342420AEC04B5E5920100E091",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=477ae5681935f43771c8487b87e4f914&er=1&src=http://t12.baidu.com/it/u=2741585876,3806095357&fm=173&app=25&f=JPEG?w=218&h=146&s=C8C27A2342420AEC04B5E5920100E091"
			}],
			"site": "全频旅游",
			"type": "text",
			"abs": "spanclass='bjh-p'><spanclass='bjh-br'></span></...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606701708436987486&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "f34de4f7"
		}, {
			"nid": "8617897787977456291",
			"sourcets": "1532271784000",
			"ts": "1532272428000",
			"title": "张仪村路中铁模板厂东侧道路积水 刘家窑东里11号楼顶层漏雨",
			"url": "http://baijiahao.baidu.com/s?id=1606703360418311511&wfr=newsapp",
			"imageurls": [{
				"url": "http://t10.baidu.com/it/u=2340725415,27966386&fm=173&app=25&f=JPEG?w=218&h=146&s=B01417D08060431FC401FD000300F0D1",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=6cb4677397e76f524a44f3dee100df7b&er=1&src=http://t10.baidu.com/it/u=2340725415,27966386&fm=173&app=25&f=JPEG?w=218&h=146&s=B01417D08060431FC401FD000300F0D1"
			}],
			"site": "北晚新视觉网",
			"type": "text",
			"abs": "spanclass='bjh-p'><spanclass='bjh-br'></span></...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606703360418311511&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "ddedaf5b"
		}, {
			"nid": "9446231992827897345",
			"sourcets": "1532304473000",
			"ts": "1532305195000",
			"title": "工体门柱帮忙，北京国安富贵险中求，最后20分钟为何如此狼狈？",
			"url": "http://baijiahao.baidu.com/s?id=1606737637955835131&wfr=newsapp",
			"imageurls": [{
				"url": "http://t10.baidu.com/it/u=3450341835,795508356&fm=173&app=25&f=JPEG?w=218&h=146&s=CDFF72DA5AE18A5108642A07030010DE",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=80b9b62b348a4811efe90162a1a8107d&er=1&src=http://t10.baidu.com/it/u=3450341835,795508356&fm=173&app=25&f=JPEG?w=218&h=146&s=CDFF72DA5AE18A5108642A07030010DE"
			}, {
				"url": "http://t11.baidu.com/it/u=3592306828,729061987&fm=173&app=25&f=JPEG?w=218&h=146&s=23829441567283D60080BC0B0300A0C1",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=404d5ee4aa7c22da291eb822249c10ec&er=1&src=http://t11.baidu.com/it/u=3592306828,729061987&fm=173&app=25&f=JPEG?w=218&h=146&s=23829441567283D60080BC0B0300A0C1"
			}, {
				"url": "http://t11.baidu.com/it/u=3835442152,945367193&fm=173&app=25&f=JPEG?w=218&h=146&s=B2A26EA17602135514B1E80C030030C1",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=95f41b3cc7c128908e39cae176add081&er=1&src=http://t11.baidu.com/it/u=3835442152,945367193&fm=173&app=25&f=JPEG?w=218&h=146&s=B2A26EA17602135514B1E80C030030C1"
			}],
			"site": "北晚新视觉网",
			"type": "text",
			"abs": "spanclass='bjh-p'><spanclass='bjh-br'></span></...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606737637955835131&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "83fe169f"
		}, {
			"nid": "12975845946768917541",
			"sourcets": "1532307809000",
			"ts": "1532309494000",
			"title": "北京治睡城“回天有数”补短板初见成效",
			"url": "http://society.workercn.cn/32850/201807/23/180723085114967.shtml",
			"imageurls": [{
				"url": "http://t11.baidu.com/it/u=1445049178,3747687823&fm=173&app=25&f=JPEG?w=218&h=146&s=EC930CD15F1475CE8EB4827203009072",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=5144e3ffcb023f602079305307ca88bd&er=1&src=http://t11.baidu.com/it/u=1445049178,3747687823&fm=173&app=25&f=JPEG?w=218&h=146&s=EC930CD15F1475CE8EB4827203009072"
			}],
			"site": "中工网",
			"type": "text",
			"abs": "居住人口达80万的回龙观天通苑地区如何补齐公共服务短板。",
			"display_type": 1,
			"display_url": "http://society.workercn.cn/32850/201807/23/180723085114967.shtml",
			"topic": [],
			"long_abs": "经过居民自治，龙泽苑人工湖成为社区最美的景点之一。然而这两大居住区共同存在交通拥堵、职住失衡、公共服务严重滞后等短板，被称为“睡城”。此外，“回天地区”15分钟生活圈内社会公共配套设施可达指数较低，小学、中学、社区医院、公园广场、体育场馆均存在不同程度的缺失，同时局部板块因道路阻隔，影响了既有配套可达性。",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "0cd4c668"
		}, {
			"nid": "9951309765989190561",
			"sourcets": "1532306446000",
			"ts": "1532306553000",
			"title": "北京晚报百队杯：“90后”大学生教练指导“00后”孩子",
			"url": "http://baijiahao.baidu.com/s?id=1606739697701209768&wfr=newsapp",
			"imageurls": [{
				"url": "http://t12.baidu.com/it/u=3641105450,1887189431&fm=173&app=25&f=JPEG?w=218&h=146&s=AF3670841EE298CE548A72900300E09C",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=8181db05acce96f6b6c18b817c04e3c4&er=1&src=http://t12.baidu.com/it/u=3641105450,1887189431&fm=173&app=25&f=JPEG?w=218&h=146&s=AF3670841EE298CE548A72900300E09C"
			}, {
				"url": "http://t10.baidu.com/it/u=809972409,88374200&fm=173&app=25&f=JPEG?w=218&h=146&s=B308F3A1060204F15A34351E030070D0",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=0891ea6504f15e172cca3f7c75edff48&er=1&src=http://t10.baidu.com/it/u=809972409,88374200&fm=173&app=25&f=JPEG?w=218&h=146&s=B308F3A1060204F15A34351E030070D0"
			}, {
				"url": "http://t12.baidu.com/it/u=916489778,922506298&fm=173&app=25&f=JPEG?w=218&h=146&s=AD346095084030CC5C0A57800300A09C",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=30470b5d70d5e7a91745bd4b0bd2f1fc&er=1&src=http://t12.baidu.com/it/u=916489778,922506298&fm=173&app=25&f=JPEG?w=218&h=146&s=AD346095084030CC5C0A57800300A09C"
			}],
			"site": "北晚新视觉网",
			"type": "text",
			"abs": "span class='bjh-p'>往前，很好。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606739697701209768&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "320a15c1"
		}, {
			"nid": "10043817529044568871",
			"sourcets": "1532306464000",
			"ts": "1532307089000",
			"title": "北京晚报百队杯：一群男教练里冒出了“一点红”",
			"url": "http://baijiahao.baidu.com/s?id=1606739697730587673&wfr=newsapp",
			"imageurls": [{
				"url": "http://t12.baidu.com/it/u=3963939164,77891585&fm=173&app=25&f=JPEG?w=218&h=146&s=268061A50C5398D442F538170300E0C0",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=2bd1237cc8ed3d0dede7cf767d6c1231&er=1&src=http://t12.baidu.com/it/u=3963939164,77891585&fm=173&app=25&f=JPEG?w=218&h=146&s=268061A50C5398D442F538170300E0C0"
			}, {
				"url": "http://t10.baidu.com/it/u=2800064214,3917981036&fm=173&app=25&f=JPEG?w=218&h=146&s=5C50618B044318E558910C310300F050",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=99e6d413b4c7404b462af44d24ad8444&er=1&src=http://t10.baidu.com/it/u=2800064214,3917981036&fm=173&app=25&f=JPEG?w=218&h=146&s=5C50618B044318E558910C310300F050"
			}, {
				"url": "http://t10.baidu.com/it/u=509090214,1351785678&fm=173&app=25&f=JPEG?w=218&h=146&s=65585C8AE4031EED288D39220300E090",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=6e0fa67aecf49908f9aaa8b62656d08c&er=1&src=http://t10.baidu.com/it/u=509090214,1351785678&fm=173&app=25&f=JPEG?w=218&h=146&s=65585C8AE4031EED288D39220300E090"
			}],
			"site": "北晚新视觉网",
			"type": "text",
			"abs": "span class='bjh-p'>在恒通创新园里有一家小足球俱乐部，名字就叫胜瑞斯俱乐部，...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606739697730587673&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "d444de77"
		}, {
			"nid": "9162111380597271365",
			"sourcets": "1532274636000",
			"ts": "1532274636000",
			"title": "北京旅游攻略（第二部）收藏备用分享好友",
			"url": "http://baijiahao.baidu.com/s?id=1606706348520824470&wfr=newsapp",
			"imageurls": [{
				"url": "http://t11.baidu.com/it/u=536312860,1703246391&fm=173&app=25&f=JPEG?w=218&h=146&s=9403DB144C2850070352D4C1030070B9",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=33b105ff41970a1e44854188883b24ae&er=1&src=http://t11.baidu.com/it/u=536312860,1703246391&fm=173&app=25&f=JPEG?w=218&h=146&s=9403DB144C2850070352D4C1030070B9"
			}, {
				"url": "http://t12.baidu.com/it/u=4218507287,3771992893&fm=173&app=25&f=JPEG?w=218&h=146&s=3323C3A0DC9A3FCC64345400030090D8",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=533f7d059557c6ea66a934f66702422b&er=1&src=http://t12.baidu.com/it/u=4218507287,3771992893&fm=173&app=25&f=JPEG?w=218&h=146&s=3323C3A0DC9A3FCC64345400030090D8"
			}, {
				"url": "http://t11.baidu.com/it/u=1200838843,3266428023&fm=173&app=25&f=JPEG?w=218&h=146&s=D70A0AABCA982ACC7CA108B50300C0A1",
				"height": 146,
				"width": 218,
				"url_webp": "https://timg01.bdimg.com/timg?news&quality=80&size=f218_146&wh_rate=0&imgtype=4&sec=0&di=6d163851a53040f06e3c4683be034f59&er=1&src=http://t11.baidu.com/it/u=1200838843,3266428023&fm=173&app=25&f=JPEG?w=218&h=146&s=D70A0AABCA982ACC7CA108B50300C0A1"
			}],
			"site": "游四方的孤独人",
			"type": "text",
			"abs": "spanclass='bjh-p'>今天小编也给大家介绍完了北京的景点了，这些都是小编介绍的有...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606706348520824470&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			},
			"token": "b6217365"
		}],
		"toppic": [{
			"nid": "9615237568634975384",
			"sourcets": "1532307017000",
			"ts": "1532307583000",
			"title": "台风“安比”将直击北京？降雨会有多大？",
			"url": "http://baijiahao.baidu.com/s?id=1606740297065627783&wfr=newsapp",
			"imageurls": [{
				"url": "http://timg01.baidu-img.cn/timg?tc&size=b480_300&sec=0&quality=100&di=af9e222d7aba2fa325b1e8e11ef96be2&src=http://t11.baidu.com/it/u=3451608682,3117631329&fm=173&app=25&f=JPEG?w=490&h=336&s=A97A6F91260532ED60A95944030060F1&access=215967317",
				"width": 490,
				"height": 336,
				"url_webp": "https://timg01.bdimg.com/timg?news&size=f490_336&quality=100&wh_rate=0&imgtype=4&sec=0&di=be53fff1e7a7da44acd970d70fc0df07&er=1&src=http://t11.baidu.com/it/u=3451608682,3117631329&fm=173&app=25&f=JPEG?w=490&h=336&s=A97A6F91260532ED60A95944030060F1"
			}],
			"site": "中国搜索",
			"type": "text",
			"abs": "spanclass='bjh-p'></span>。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606740297065627783&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			}
		}, {
			"nid": "9473626763048429935",
			"sourcets": "1532307445000",
			"ts": "1532307977000",
			"title": "“少女主播”群租房内被快递员侵犯后死亡，嫌疑人称属于过失",
			"url": "http://baijiahao.baidu.com/s?id=1606731567029614637&wfr=newsapp",
			"imageurls": [{
				"url": "http://timg01.baidu-img.cn/timg?tc&size=b480_300&sec=0&quality=100&di=79af95a7d2ab96c42edc97de6eb40784&src=http://t11.baidu.com/it/u=676948258,2969670579&fm=173&app=25&f=JPEG?w=589&h=493&s=F000BC1B4183DEE65642787D03005062&access=215967317",
				"width": 589,
				"height": 493,
				"url_webp": "https://timg01.bdimg.com/timg?news&size=f589_493&quality=100&wh_rate=0&imgtype=4&sec=0&di=09184ace9a333d0df9c7c28342bba2fd&er=1&src=http://t11.baidu.com/it/u=676948258,2969670579&fm=173&app=25&f=JPEG?w=589&h=493&s=F000BC1B4183DEE65642787D03005062"
			}],
			"site": "钱来无恙",
			"type": "text",
			"abs": "spanclass='bjh-p'><spanclass='bjh-br'></span></...",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606731567029614637&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			}
		}, {
			"nid": "9754697617817183601",
			"sourcets": "1532309893000",
			"ts": "1532310473000",
			"title": "北京东城区第一处城市森林公园建成开放",
			"url": "http://baijiahao.baidu.com/s?id=1606743082981560866&wfr=newsapp",
			"imageurls": [{
				"url": "http://timg01.baidu-img.cn/timg?tc&size=b480_300&sec=0&quality=100&di=d4327e26f5bf6d7e5c24f6a53384827e&src=http://t12.baidu.com/it/u=320098694,1305584849&fm=173&app=25&f=JPEG?w=640&h=429&s=FCAA6ED840B2CDC6021DEB19030090D7&access=215967317",
				"width": 640,
				"height": 429,
				"url_webp": "https://timg01.bdimg.com/timg?news&size=f640_429&quality=100&wh_rate=0&imgtype=4&sec=0&di=47c2511f5f121f9328b90b668d92d878&er=1&src=http://t12.baidu.com/it/u=320098694,1305584849&fm=173&app=25&f=JPEG?w=640&h=429&s=FCAA6ED840B2CDC6021DEB19030090D7"
			}],
			"site": "新华网",
			"type": "text",
			"abs": "spanclass='bjh-p'>7月22日，市民在北京东城区新中街城市森林公园散步。",
			"display_type": 2,
			"display_url": "http://baijiahao.baidu.com/s?id=1606743082981560866&wfr=newsapp",
			"topic": [],
			"long_abs": "span class=",
			"has_related": [],
			"tag": [],
			"content": [],
			"content_type": {
				"text": 1
			},
			"comment": {
				"count": 0
			}
		}]
}
''';