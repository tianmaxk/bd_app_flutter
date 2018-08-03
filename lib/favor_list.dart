import 'package:flutter/material.dart';
import 'utils/sp_util.dart';
import 'news_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavorList extends StatelessWidget {
  FavorList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 12.0,
          title: const Text('我的收藏'),
          //为AppBar对象的actions属性添加一个IconButton对象，actions属性值可以是Widget类型的数组
//          actions: <Widget>[
//            new IconButton(icon: isFavor?new Icon(Icons.favorite):new Icon(Icons.favorite_border), onPressed: _onFavor),
//            new IconButton(icon: new Icon(Icons.web), onPressed: _gotoWeb)
//          ],
        ),
        body: new FavorListContent()
    );
  }
}

class FavorListContent extends StatefulWidget {
  FavorListContent({Key key}) : super(key: key);

  @override
  _FavorListContent createState() => new _FavorListContent();
}

class _FavorListContent extends State<FavorListContent> {
  List<dynamic> items = [];

  void getFavorList() async{
    SharedPreferences sp = await SPUtil.getSharedPreferences();
    String orinids = sp.getString("favornids");
    print('orinids=$orinids');
    if(orinids!=null){
      var arr = orinids.split('|');
      setState(() {
        for(int i=0;i<arr.length;i++){
          Map<String,String> obj = {};
          obj['nid'] = arr[i];
          obj['title'] = sp.getString("favortitle_${arr[i]}")??"无标题";
          items.add(obj);
        }
      });
    }
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

  _deleteFavour(String nid) async {
    SharedPreferences sp = await SPUtil.getSharedPreferences();
    String orinids = sp.getString("favornids");
    if(orinids!=null){
      var arr = orinids.split('|');
      arr.removeAt(arr.indexOf(nid));
      sp.setString("favornids", arr.join("|"));
      sp.remove("favortitle_${nid}");
    }
  }

  @override
  void initState() {
    getFavorList();
  }

  @override
  //构建一个脚手架，里面塞入前面定义好的_buildNews类
  Widget build(BuildContext context) {
//    Map<DismissDirection, double> dismissMap = new Map<DismissDirection, double>();
//    dismissMap[DismissDirection.endToStart] = 1.0;
    return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

//          return new Dismissible(
//            key: new Key(item['nid']),
//            child: new ListTile(
//              title: new Text(item['title']),
//              onTap: (){_onSelectNews(item);},
//            ),
//            onDismissed: (DismissDirection direction) {
//              setState(() {
//                items.removeAt(index);
//                //this.reIndex();
//              });
//              direction == DismissDirection.endToStart
//                  ? print("favourite")
//                  : print("remove");
//            },
//            background: new Container(
//                color: const Color.fromRGBO(183, 28, 28, 0.8),
//                child: const ListTile(
//                    leading: const Icon(Icons.delete,
//                        color: Colors.white, size: 36.0))),
//            secondaryBackground: new Container(
//                color: const Color.fromRGBO(0, 96, 100, 0.8),
//                child: const ListTile(
//                    trailing: const Icon(Icons.favorite,
//                        color: Colors.white, size: 36.0))),
//          );


          //通过拖动来删除小部件的widget
          return new Dismissible(
              direction: DismissDirection.endToStart,
//              dismissThresholds: dismissMap,
              //如果Dismissible是一个列表项 它必须有一个key 用来区别其他项
              key: new Key(item['nid']),
              //在child被取消时调用
              onDismissed: (direction) {
                _deleteFavour(item['nid']);
                items.removeAt(index);
                //这个和Android的SnackBar差不多
                Scaffold.of(context).showSnackBar(
                    new SnackBar(content: new Text("已经取消收藏"))
                );
              },
              background: new Container(
                  color: const Color.fromRGBO(183, 28, 28, 0.8),
                  child: const ListTile(
                      trailing: const Icon(Icons.delete,
                          color: Colors.white, size: 36.0))
              ),
              child: new ListTile(
                title: new Text(item['title']),
                onTap: (){_onSelectNews(item);},
              ),
          );
        }
    );
  }
}