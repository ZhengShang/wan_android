import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/model/hotkey_json.dart';
import 'package:wan_android/widget/tag_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController =
      new TextEditingController(); //new
  final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);
  final TextStyle _grayText = new TextStyle(fontSize: 12.0, color: Colors.grey);
  String _hotKeys = "";
  List<Article> _listData = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      home: Scaffold(
          body: IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
            margin: MediaQuery.of(context).padding,
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Card(
                      elevation: 0.5,
                      margin: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                      color: Colors.white30,
                      child: TextField(
                        controller: _textController,
                        textInputAction: TextInputAction.search,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                        autofocus: true,
                        onChanged: (text) {
                          print('The hotkey is $text');
                          setState(() {
                            _hotKeys = text;
                            doSearch();
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.search,
                              color: Colors.black12,
                            ),
                            hintText: "关键词"),
                      ),
                    ),
                  ),
                  InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          "取消",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
              bodyPart()
            ])), //new
      )),
    );
  }

  Widget bodyPart() {
    print('hot key == empty ? => ${_hotKeys.isEmpty}');
    if (_hotKeys.isEmpty) {
      return MyChipGroup(onTapd: (keyword) {
        _textController.text = keyword;
        _textController.selection =
            TextSelection.collapsed(offset: keyword.length);
        setState(() {
          _hotKeys = keyword;
          doSearch();
        });
      });
    } else {
      return Flexible(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return _buildRow(_listData[index]);
        },
        itemCount: _listData.length,
      ));
    }
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

  doSearch() async {
    _listData.clear();
    Map<String, String> map = {'k': _hotKeys};
    final respone = await http
        .post('http://www.wanandroid.com/article/query/0/json', body: map)
        .timeout(Duration(seconds: 5));
    print('End search , and  body is ${respone.body}');
    var homePageJson = HomePageJson.fromJson(json.decode(respone.body));
    if (homePageJson.errorCode >= 0) {
      setState(() {
        _listData = homePageJson.data.datas;
      });
      FocusScope.of(context).requestFocus(new FocusNode());
    }
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

class MyChipGroup extends StatefulWidget {
  final Function(String) onTapd;

  MyChipGroup({@required this.onTapd}) : assert(onTapd != null);

  @override
  State<StatefulWidget> createState() {
    return _MyChipGroupState(onTapd);
  }
}

class _MyChipGroupState extends State<MyChipGroup> {
  final Function(String) onTapd;

  _MyChipGroupState(this.onTapd);

  @override
  void initState() {
    super.initState();
    getHotKeysFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Align(
            child: Text('热词'),
            alignment: Alignment.topLeft,
          ),
        ),
        _getChips()
      ],
    );
  }

  Widget _getChips() {
    return FutureBuilder<HotKeyJson>(
      future: getHotKeysFromServer(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data.errorCode >= 0) {
            var children = <Widget>[];
            for (var key in snapshot.data.data) {
              children.add(ActionChip(
                  onPressed: () => widget.onTapd(key.name),
                  label: Text(key.name)));
            }
            return Wrap(
              spacing: 32.0, // gap between adjacent chips
              runSpacing: 4.0, //  gap between
              children: children,
            );
          } else {
            return Text("暂无热词");
          }
        }

        // By default, show a loading spinner
        return CircularProgressIndicator();
      },
    );
  }

  Future<HotKeyJson> getHotKeysFromServer() async {
    print('start fetch hotKeys');
    final response = await http
        .get('http://www.wanandroid.com//hotkey/json')
        .timeout(Duration(seconds: 5));
    print('end fetch hotKeys. the body is => ${response.body}');
    var hotkeyJson = HotKeyJson.fromJson(json.decode(response.body));
    return hotkeyJson;
  }
}
