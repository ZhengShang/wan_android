import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/hotkey_json.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _textController =
      new TextEditingController(); //new

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
//            padding: EdgeInsets.symmetric(horizontal: 14.0),
            margin: MediaQuery.of(context).padding,
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop()),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      padding: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Color.fromARGB(205, 209, 211, 217)),
                      child: TextField(
                        controller: _textController,
                        maxLines: 1,
                        autofocus: true,
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
                  IconButton(icon: Icon(Icons.check), onPressed: (){
                    print('search');
                  })
                ],
              ),
              MyChipGroup(onTapd: (keyword) {
                _textController.text = keyword;
              })
            ])), //new
      )),
    );
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
  var _hotKeys = <HotKey>[];

  _MyChipGroupState(this.onTapd);

  @override
  void initState() {
    super.initState();
    getHotKeysFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[Text('热词'), _getChips()],
    );
  }

  Widget _getChips() {
    var childrens = <Widget>[];
    for (var key in _hotKeys) {
      childrens.add(ActionChip(
          onPressed: () => widget.onTapd(key.name), label: Text(key.name)));
    }
    return Wrap(
      spacing: 32.0, // gap between adjacent chips
      runSpacing: 4.0, //  gap between
      children: childrens,
    );
  }

  void getHotKeysFromServer() async {
    print('start fetch hotKeys');
    final response = await http
        .get('http://www.wanandroid.com//hotkey/json')
        .timeout(Duration(seconds: 5));
    print('end fetch hotKeys. the body is => ${response.body}');
    var hotkeyJson = HotKeyJson.fromJson(json.decode(response.body));
    if (hotkeyJson.errorCode >= 0) {
      setState(() {
        _hotKeys.clear();
        _hotKeys.addAll(hotkeyJson.data);
      });
    }
  }
}
