import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/widget/article_list_row.dart';
import 'package:wan_android/widget/chip_group.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController =
      new TextEditingController(); //new
  String _hotKeys = "";

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
                      color: Colors.white70,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
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
                              suffixIcon: Opacity(
                                opacity: _hotKeys.isEmpty ? 0.0 : 1.0,
                                child: IconButton(
                                  icon:
                                      Icon(Icons.cancel, color: Colors.black12),
                                  onPressed: () {
                                    setState(() {
                                      _textController.clear();
                                      _hotKeys = "";
                                    });
                                  },
                                ),
                              ),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.search,
                                color: Colors.black12,
                              ),
                              hintText: "关键词"),
                        ),
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
          child: FutureBuilder<HomePageJson>(
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data.errorCode >= 0) {
            var _listData = snapshot.data.data.datas;
            return ListView.builder(
              itemBuilder: (context, index) {
                return ArticleListRow(_listData[index]);
              },
              itemCount: _listData.length,
            );
          }
          return CircularProgressIndicator();
        },
        future: doSearch(),
      ));
    }
  }

  Future<HomePageJson> doSearch() async {
    Map<String, String> map = {'k': _hotKeys};
    final respone = await http
        .post('http://www.wanandroid.com/article/query/0/json', body: map)
        .timeout(Duration(seconds: 5));
    print('End search , and  body is ${respone.body}');
    var homePageJson = HomePageJson.fromJson(json.decode(respone.body));
    return homePageJson;
  }
}
