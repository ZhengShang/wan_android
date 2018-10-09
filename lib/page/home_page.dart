import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/helper/page_helper.dart';
import 'package:wan_android/model/banner_json.dart';
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/page/search.dart';
import 'package:wan_android/widget/article_list_row.dart';
import 'package:wan_android/widget/banner_view.dart';

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
  final _data = <Article>[];
  final _banner = <Bner>[];
  int _page = 0;
  var _loadMoreType = LoadMore.loadMore;
  bool _titleBarOpacity = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //添加第一个null用来显示Banner
    _data.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[_buildList(), _titleBar()]);
  }

  Widget _titleBar() {
    return AnimatedOpacity(
      opacity: _titleBarOpacity ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: MediaQuery.of(context).padding,
        color: Theme.of(context).accentColor,
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        child: NavigationToolbar(
          middle: Text("Wan Android",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0)),
          trailing: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              }),
        ),
      ),
    );
  }

  Widget _buildList() {
    int count = _data.length + 1;
    print('list count  = $count');

    final th = kToolbarHeight + MediaQuery.of(context).padding.top;
    final _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.offset >= 200 - th) {
        if (!_titleBarOpacity) {
          setState(() {
            _titleBarOpacity = true;
          });
        }
      } else if (_controller.offset <= 200) {
        if (_titleBarOpacity) {
          setState(() {
            _titleBarOpacity = false;
          });
        }
      }
    });

    return RefreshIndicator(
        onRefresh: () {
          return fetchArticle(true);
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return _getBannerView();
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
            return ArticleListRow(_data[index]);
          },
          itemCount: count,
          padding: EdgeInsets.symmetric(vertical: 0.0),
          controller: _controller,
        ));
  }

  Widget _getBannerView() {
    if (_banner.isEmpty) {
      fetchBanner();
      return Text('');
    } else {
      return SizedBox(
        height: 200.0,
        child: BannerView(
          _banner.map((i) {
            Bner b = i;
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(b.imagePath))),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              b.title,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ))),
                  onTap: () {
                    PageHelper.goDetailPage(context, b.url, false);
                  },
                );
              },
            );
          }).toList(),
        ),
      );
    }
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
}
