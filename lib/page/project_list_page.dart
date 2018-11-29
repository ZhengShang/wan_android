import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/enums/loadmore.dart';
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/widget/article_list_row.dart';
import 'package:wan_android/widget/load_more_widget.dart';

///项目分类下的所有文章列表页
class ProjectListPage extends StatefulWidget {
  final int cid;
  final String title;

  ProjectListPage(this.cid, this.title);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  int _page = 1;
  var _loadMoreType = LoadMore.loadMore;
  List<Article> _datas = <Article>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          print('index = $index, datas.length = ${_datas.length}');
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
              _getArticles();
              return LoadingMoreWidget();
            }
          }
          return ArticleListRow(_datas[index]);
        },
        itemCount: _datas.length + 1,
      ),
    );
  }

  _getArticles() async {
    print('Start get project list data');
    await http
        .get(
            'http://www.wanandroid.com/project/list/$_page/json?cid=${widget.cid}')
        .timeout(Duration(seconds: 10))
        .then((response) {
      print('End get project list data. the body is ${response.body}');
      var homePageJson = HomePageJson.fromJson(json.decode(response.body));
      if (homePageJson.errorCode >= 0) {
        _page++;
        _datas.addAll(homePageJson.data.datas);
        if (homePageJson.data.curPage > homePageJson.data.pageCount) {
          _loadMoreType = LoadMore.noMoreData;
        }
        print('Porject List page . datas.length = ${_datas.length}');
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
