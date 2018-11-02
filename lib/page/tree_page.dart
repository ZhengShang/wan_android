import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/tree_json.dart';
import 'package:wan_android/page/tree_article_page.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTree(),
    );
  }

  Widget _buildTree() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data as List<TreeChildren>;
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            itemBuilder: (context, index) {
              var sub = StringBuffer();
              for (var value in data[index].children) {
                sub.write(value.name);
                sub.write('    ');
              }
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 0.5))),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreeArticlePage(
                                  treeChildren: data[index],
                                )));
                  },
                  title: Text(data[index].name),
                  subtitle: Text(
                    sub.toString(),
                  ),
                ),
              );
            },
            itemCount: data.length,
          );
        } else if (snapshot.hasError) {
          return Column(
            children: <Widget>[
              Text('获取体系数据失败。请点击重试.\n${snapshot.error.toString()}'),
              FlatButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text(
                    "重试",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: getTreesFromServer(),
    );
  }

  Future getTreesFromServer() {
    print('Start get Tree data');
    return http
        .get('http://www.wanandroid.com/tree/json')
        .timeout(Duration(seconds: 5))
        .then((response) {
      print('end fetch tree. the body is => ${response.body}');
      var treeJson = TreeJson.fromJson(json.decode(response.body));
      if (treeJson.errorCode >= 0) {
        return treeJson.data;
      } else {
        throw Exception('服务器出错，错误码为:${treeJson.errorCode}');
      }
    }, onError: (error) {
      throw error;
    });
  }
}
