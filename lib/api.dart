import 'package:dio/dio.dart';

const root = 'https://newspwa.baidu.com';

class Api {

  String formatUrl([String url,Map<String,Object> param]){
    String ret = url;
    if(param!=null){
      bool start = true;
      param.forEach((String key, Object value){
        ret += (start?'?':'&');
        if(start) start = false;
        ret += (key+'='+value.toString());
      });
    }
    print(ret);
    return ret;
  }

  dynamic get(String url,var param) async {
//    var httpClient = new HttpClient();
//    var uri = new Uri.https(root, url, param);
//    var request = await httpClient.getUrl(uri);
//    var response = await request.close();
//    var responseBody = await response.transform(utf8.decoder).join();
    var dio = new Dio();
    try {
      //    dio.options.baseUrl = root;
//    dio.options.connectTimeout = 5000; //5s
//    dio.options.receiveTimeout=5000;
      Response response=await dio.get(root+url,data:param);
//      Response response=await dio.get(formatUrl(root + url,param));
//      print(response.data.toString());
      print(response.data);
      return response.data;
    } on DioError catch(e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if(e.response!=null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else{
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
      }
    }
  }

  String getParamT([String category,String newids]) {
    // 新闻详情
    if (newids!=null && newids!='') {
      return 'recommendinfo';
    }
    // 相关新闻
    if (category == 'getbodyinfo') {
      return 'getbodyinfo';
    }
    // 推荐栏目
    if (category == '推荐') {
      return 'newchosenlist';
    }
    // 本地栏目
    if (category == '本地') {
      return 'localnewslist';
    }
    // 普通栏目
    return 'recommendlist';
  }

  dynamic getNewsList({String category,String newids,int ver,String nid}) async {
    Map<String,Object> param = {
      'tn': 'bdapibaiyue',
      't': getParamT(category,newids),
      'mid': '03c7a16f2e8028127e42c5f7ca9e210b',
      'ts': 0,
      'topic': category,
      'type': 'info',
      'token': 'info',
      'ln': 20,
      'an': 20,
      'withtopic': 0,
      'wf': 1,
      'ver': ver ??= 4,
      'pd': 'webapp',
      'remote_device_type': 1,
      'os_type': 1,
      'screen_size_width': 375,
      'screen_size_height': 812,
      'action': 1
    };
    if(newids!=null){
      param["nids"] = newids;
    }
    if(nid!=null){
      param["nid"] = nid;
    }
    return await get('/api/mockup/realNews/news',param);
  }

}