import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wan_android/model/hotkey_json.dart';

class MyChipGroup extends StatefulWidget {
  final Function(String) onTapd;

  MyChipGroup({@required this.onTapd}) : assert(onTapd != null);

  @override
  State<StatefulWidget> createState() {
    return _MyChipGroupState();
  }
}

class _MyChipGroupState extends State<MyChipGroup> {
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
