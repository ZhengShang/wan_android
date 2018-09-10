import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/hotkey_json.dart';

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
    print('Main part');
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
        });
      });
    } else {
      return Flexible(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(index.toString()),
            selected: true,
          );
        },
        itemCount: 10,
      ));
    }
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
    var children = <Widget>[];
    for (var key in _hotKeys) {
      children.add(ActionChip(
          onPressed: () => widget.onTapd(key.name), label: Text(key.name)));
    }
    return Wrap(
      spacing: 32.0, // gap between adjacent chips
      runSpacing: 4.0, //  gap between
      children: children,
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
