import 'package:flutter/material.dart';
import 'api.dart';
import 'popup/img_show.dart';
import 'utils/sp_util.dart';
import 'utils/route_util.dart';
import 'package:tts/tts.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({Key key, this.newsInfo}) : super(key: key);
  var newsInfo = null;

  @override
  _NewsDetails createState() => new _NewsDetails();
}

class _NewsDetails extends State<NewsDetails> {
  bool isFavor = false;
  String orinid = '';
  String languageAvailableText = '';
  List<String> languages;
  List<String> articleContent;

  void _onFavor() {
    String nid = widget.newsInfo['nid'];
    print('nid=$nid');
    SPUtil.setString("favornids", isFavor?'':(orinid==null?nid:'${orinid}|${nid}'));
    SPUtil.setString("favortitle_${nid}", widget.newsInfo['title']);
    setState(() {
      isFavor = !isFavor;
    });
  }

  void _setFavor() async{
    orinid = await SPUtil.getString("favornids");
    print('orinid=$orinid');
    setState(() {
      isFavor = (('|${orinid}|').indexOf('|${widget.newsInfo['nid']}|')!=-1);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.

    languages = await Tts.getAvailableLanguages();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted)
      return;
  }

  void _gotoWeb(){
    RouteUtil.route2Web(context, widget.newsInfo['title'], widget.newsInfo['url']);
  }

  void _listenWeb() {
//    var isGoodLanguage = await Tts.isLanguageAvailable(lang);
//    var setLanguage = await Tts.setLanguage(lang);
//    print(articleContent);
    Tts.speak(articleContent.join(' '));
  }

  void _setArticleContent(List<String> lst){
    print(lst);
    articleContent = lst;
  }

  @override
  void deactivate(){
    print('deactivate');
  }

  @override
  void initState(){
//    initPlatformState();
    _setFavor();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        titleSpacing: 12.0,
        title: const Text('新闻详情'),
        //为AppBar对象的actions属性添加一个IconButton对象，actions属性值可以是Widget类型的数组
        actions: <Widget>[
          new IconButton(icon: isFavor?new Icon(Icons.favorite):new Icon(Icons.favorite_border), onPressed: _onFavor),
          new IconButton(icon: new Icon(Icons.language), onPressed: _gotoWeb),
          new IconButton(icon: new Icon(Icons.headset_mic), onPressed: _listenWeb)
        ],
      ),
      body: new NewsContent(newsInfo: widget.newsInfo, setArticleContent: _setArticleContent)
    );
  }
}

class NewsContent extends StatefulWidget {
  NewsContent({Key key, this.newsInfo, this.setArticleContent}) : super(key: key);
  var newsInfo;
  Function setArticleContent;
  List<String> article = new List();

  @override
  _NewsContent createState() => new _NewsContent();
}

class _NewsContent extends State<NewsContent> {
  var newsInfo;
  var newsDetails = null;

  @override
  void initState(){
    newsInfo = widget.newsInfo;
    _getNewsInfo();
  }

  _getNewsInfo() async {
    var newslst = await Api().getNewsList(newids:newsInfo['nid']);
    var newsjson = newslst['data']['news'][0];
    print(newsjson);
    setState(() {
      newsInfo['url'] = newsjson['url'];
      newsDetails = newsjson;
      _buildArticleCont();
    });
  }

  _buildArticleCont() {
    widget.article.clear();
    if(newsDetails!=null){
      widget.article.add(newsDetails['title']);
      var newsContent = newsDetails['content'];
      for(int i=0;i<newsContent.length;i++) {
        String txt = (newsContent[i]['data'] ??= '').toString().replaceAll(new RegExp(r'<span .*?>'), '').replaceAll('</span>', '');
        if(txt!=''){
          widget.article.add(txt);
        }
      }
      widget.setArticleContent(widget.article);
    }
  }

  @override
  //构建一个脚手架，里面塞入前面定义好的_buildNews类
  Widget build(BuildContext context) {
    if(newsDetails==null){
      return new Center(child: Image.asset(
        'images/loading.gif',
        width: 40.0,
        height: 40.0,
        fit: BoxFit.cover,
      ),);
    }
    var newsContent = newsDetails['content'];
    return new RefreshIndicator(
      child: new ListView.builder(
        //ListView(列表视图)是material.dart中的基础控件
        padding: const EdgeInsets.all(0.0), //padding(内边距)是ListView的属性，配置其属性值
        physics: new AlwaysScrollableScrollPhysics(),
        //通过ListView自带的函数itemBuilder，向ListView中塞入行，变量 i 是从0开始计数的行号
        itemBuilder: (context, i) {
          if (i.isOdd) return new Container();// new Divider(color: Colors.transparent,); //奇数行塞入分割线对象
          final index = i ~/ 2; //当前行号除以2取整，得到的值就是_suggestions数组项索引号
          if(index==0){
            return _buildTitle(newsDetails['title']);
          }else if(newsContent!=null && index>newsContent.length){
            return null;
          }
          return _buildRow(newsContent[index-1]);
        },
        shrinkWrap: true,
      ),
      onRefresh: () async {
        setState(() {
          newsDetails = null;
        });
        _getNewsInfo();
        return null;
      },
    );
  }

  Widget _buildTitle(String title){
    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),
        ),
      )
    );
  }

  Widget _buildRow(var news) {
    String type = news['type'];
    if(type=='image'){
      String imageurl = news['data']['small']['url_webp'];
      return GestureDetector(
          onTap: ()=>BigImage(context: context).show(news['data']['big']['url_webp']),
          child: Container(
            padding: const EdgeInsets.all(6.0),
            child: new Image.network(imageurl)
          ));
    } else if(type=='text'){
      String txt = (news['data']??='').toString().replaceAll(new RegExp(r'<span .*?>'), '').replaceAll('</span>', '');
      return Container(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            txt,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.0
            ),
          )
      );
    }

    return null;
  }
}
