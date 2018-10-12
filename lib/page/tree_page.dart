import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/tree_json.dart';

class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('体系'),
      ),
      body: _buildTree(),
    );
  }

  Widget _buildTree() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data as List<TreeChildren>;
          return ListView.builder(
            itemBuilder: (context, index) {
              var sub = StringBuffer();
              for (var value in data[index].children) {
                sub.writeln(value.name);
              }
              return ListTile(
                title: Text(data[index].name),
                subtitle: Text(sub.toString()),
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
          return CircularProgressIndicator();
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
