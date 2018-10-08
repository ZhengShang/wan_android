import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class UserPage extends StatefulWidget {
  final String userName;

  UserPage(this.userName);

  @override
  State<StatefulWidget> createState() {
    return UserPageState(userName);
  }
}

class UserPageState extends State<UserPage> {
  final String _title;

  UserPageState(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: WebviewScaffold(
        url: 'http://www.wanandroid.com/article/list/0?author=$_title',
        scrollBar: true,
      ),
    );
  }
}
