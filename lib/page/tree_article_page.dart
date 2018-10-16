import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/enums/loadmore.dart';
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/model/tree_json.dart';
import 'package:wan_android/widget/article_list_row.dart';
import 'package:wan_android/widget/load_more_widget.dart';

class TreeArticlePage extends StatefulWidget {
  final TreeChildren treeChildren;

  TreeArticlePage({@required this.treeChildren});

  @override
  _TreeArticlePageState createState() => _TreeArticlePageState();
}

class _TreeArticlePageState extends State<TreeArticlePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<TreeChildren> _treeList;
  int _page = 0;
  var _datas = <Article>[];
  var _loadMoreType = LoadMore.loadMore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _treeList = widget.treeChildren.children;

    _tabController = TabController(vsync: this, length: _treeList.length)
      ..addListener(() {
        _tagChanged();
      });

    _tagChanged();
  }

  void _tagChanged() {
    setState(() {
      _datas.clear();
      _page = 0;
      _loadMoreType = LoadMore.loadMore;

      _getTreeArticle(_treeList[_tabController.index]);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _treeList.map((i) {
                return Builder(builder: (BuildContext context) {
                  return Tab(
                    text: i.name,
                  );
                });
              }).toList()),
          title: Text(widget.treeChildren.name),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _treeList.map((tree) {
            if (_datas.isEmpty) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index == _datas.length) {
                  if (_loadMoreType == LoadMore.noMoreData) {
                    return NoMoreDataWidget();
                  } else if (_loadMoreType == LoadMore.loadFailed) {
                    return LoadingFailedWidget(
                      onRetryPressed: () {
                        setState(() {
                          _loadMoreType = LoadMore.loadMore;
                        });
                      },
                    );
                  } else {
                    _getTreeArticle(tree);
                    return LoadingMoreWidget();
                  }
                }
                return ArticleListRow(_datas[index]);
              },
              itemCount: _datas.length + 1,
            );
          }).toList(),
        ));
  }

  _getTreeArticle(TreeChildren i) async {
    print('Start get tree article data');
    await http
        .get('http://www.wanandroid.com/article/list/$_page/json?cid=${i.id}')
        .timeout(Duration(seconds: 10))
        .then((response) {
      print('End get tree article data. the body is ${response.body}');
      var homePageJson = HomePageJson.fromJson(json.decode(response.body));
      if (homePageJson.errorCode >= 0) {
        _page++;
        _datas.addAll(homePageJson.data.datas);
        if (homePageJson.data.curPage > homePageJson.data.pageCount) {
          _loadMoreType = LoadMore.noMoreData;
        }
        setState(() {});
      } else {
        setState(() {
          _loadMoreType = LoadMore.loadFailed;
        });
        throw Exception('服务器出错，错误码为:${homePageJson.errorCode}');
      }
    }).catchError((error) {
      setState(() {
        _loadMoreType = LoadMore.loadFailed;
      });
      throw error;
    });
  }
}
