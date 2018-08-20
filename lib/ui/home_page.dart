import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/banner_json.dart';
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/widget/tag_widget.dart';

enum LoadMore { loadMore, noMoreData, loadFailed }

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);
  final TextStyle _grayText = new TextStyle(fontSize: 12.0, color: Colors.grey);

  final _data = <Article>[];
  final _banner = <Bner>[];
  int _page = 0;
  var _loadMoreType = LoadMore.loadMore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //添加一条空数据，作为banner占位使用
    _data.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Wan android"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: null)
            ]),
        body: _buildList());
  }

  Widget _buildList() {
    int count = _data.length + 1;
    print('list count  = $count');

    return RefreshIndicator(
        onRefresh: () {
          return fetchArticle(true);
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            //First position used for Banner.
            if (index == 0) {
              if (_banner.isEmpty) {
                fetchBanner();
                return Text('');
              }
              return CarouselSlider(
                  items: _banner.map((i) {
                    Bner b = i;
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(b.imagePath))),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    b.title,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ))),
                          onTap: () {
                            goDetailPage(b.url, false);
                          },
                        );
                      },
                    );
                  }).toList(),
                  height: 200.0,
                  autoPlay: true);
            } else if (index == _data.length) {
              //The last extra item.
              //Used for showing LoadMore or NoMore text.
              if (_loadMoreType == LoadMore.noMoreData) {
                print('show there is no more items');
                return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "没有更多数据了.",
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (_loadMoreType == LoadMore.loadMore) {
                //show loadMore and fetch new data;
                fetchArticle(false);
                print('fetch new data');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                            width: 24.0,
                            height: 24.0,
                            child: CircularProgressIndicator())),
                    Text("正在加载中...")
                  ],
                );
              } else {
                //Show load more failed, and user can click RETRY.
                return Center(
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _loadMoreType = LoadMore.loadMore;
                          });
                        },
                        child: Text("加载失败，请点击重试",
                            style: TextStyle(
                              color: Colors.blue,
                            ))));
              }
            }
            return _buildRow(_data[index]);
          },
          itemCount: count,
        ));
  }

  Widget _buildRow(Article article) {
    return Card(
      margin: EdgeInsets.only(left: 12.0, top: 6.0, right: 12.0, bottom: 6.0),
      elevation: 12.0,
      child: InkWell(
        onTap: () {
          goDetailPage(article.link, article.collect);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print('Go to the author page');
                    },
                    child: Text(
                      article.author,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    article.niceDate,
                    style: _grayText,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Text(
                article.title,
                style: _biggerFont,
              ),
              TagWidget(article.tags),
              Text(article.desc, style: _grayText),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          print('Go to superChapter page');
                        },
                        child: Text(
                          article.superChapterName,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: Colors.grey,
                      ),
                      InkWell(
                          onTap: () {
                            print('Go to chapter page');
                          },
                          child: Text(article.chapterName,
                              style: TextStyle(color: Colors.blue)))
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                        article.collect
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: article.collect ? Colors.red : Colors.grey),
                    onPressed: () {
                      print('do collect');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> fetchBanner() async {
    print('start fetch banner');
    final response = await http
        .get('http://www.wanandroid.com/banner/json')
        .timeout(Duration(seconds: 5));
    print('end fetch banner. the body is => ${response.body}');
    var bannerJson = BannerJson.fromJson(json.decode(response.body));
    if (bannerJson.errorCode >= 0) {
      setState(() {
        _banner.clear();
        _banner.addAll(bannerJson.data);
      });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: new Text('获取Banner失败，错误码为： ${bannerJson.errorCode}'),
                content: Text(bannerJson.errorMsg),
                actions: <Widget>[
                  FlatButton(
                    child: new Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
    }
  }

  fetchArticle(bool isRefresh) async {
    print('start fetch, isRefresh = $isRefresh');
    int fetchPage = isRefresh ? 0 : _page;
    final respone = await http
        .get('http://www.wanandroid.com/article/list/$fetchPage/json')
        .timeout(Duration(seconds: 5))
        .catchError((e) {
      if (e is TimeoutException) {
        showSnackBar('连接超时');
      } else {
        showSnackBar(e.toString());
      }
      print('Fetch error, the error is $e');
      showLoadFailed();
    });

    print('End fetch , and  body is ${respone.body}');
    var homePageJson = HomePageJson.fromJson(json.decode(respone.body));
    if (homePageJson.errorCode >= 0) {
      if (homePageJson.data.curPage > homePageJson.data.pageCount) {
        setState(() {
          _loadMoreType = LoadMore.noMoreData;
        });
        return;
      }

      var articles = homePageJson.data.datas;

      if (articles.isEmpty) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("没有新的文章")));
        return;
      }

      setState(() {
        if (isRefresh) {
          var temp = <Article>[];
          for (var value in articles) {
            if (!_data.contains(value)) {
              temp.add(value);
            }
          }
          showSnackBar(temp.isEmpty ? "暂无新的文章" : "已更新${temp.length}条新文章");
          print('fetched new items size is ${temp.length}, ==> $temp');
          _data.insertAll(0, temp);
        } else {
          _data.addAll(articles);
          _page++;
        }
      });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: new Text('获取列表失败，错误码为： ${homePageJson.errorCode}'),
                content: Text(homePageJson.errorMsg),
                actions: <Widget>[
                  FlatButton(
                    child: new Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
      showLoadFailed();
    }
  }

  showSnackBar(String content) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
        content: Text(content)));
  }

  ///显示列表加载失败
  showLoadFailed() {
    setState(() {
      _loadMoreType = LoadMore.loadFailed;
    });
  }

  goDetailPage(String url, bool isCollect) {
    print('Go detail page');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebviewScaffold(
                  url: url,
                  appBar: AppBar(
//                          title: Text(article.title),
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          isCollect ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('Do collect');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('Do share');
                        },
                      )
                    ],
                  ),
                  scrollBar: true,
                  withLocalStorage: true,
                )));
  }
}
