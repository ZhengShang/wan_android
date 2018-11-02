import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android/page/project_page.dart';
import 'package:wan_android/page/tree_page.dart';

class TreeProjectPage extends StatefulWidget {
  @override
  _TreeProjectPageState createState() => _TreeProjectPageState();
}

class _TreeProjectPageState extends State<TreeProjectPage> {
  final Map<int, Widget> children = const {
    0: Text('体系'),
    1: Text('项目'),
  };

  int currentValue = 0;

  @override
  Widget build(BuildContext context) {
    final titileBar = Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      padding: MediaQuery.of(context).padding,
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: CupertinoSegmentedControl<int>(
        children: children,
        onValueChanged: (int newValue) {
          setState(() {
            currentValue = newValue;
          });
        },
        groupValue: currentValue,
      ),
    );

    final body = Stack(
      children: <Widget>[
        Offstage(
          offstage: currentValue != 0,
          child: TickerMode(
            enabled: currentValue == 0,
            child: TreePage(),
          ),
        ),
        Offstage(
          offstage: currentValue != 1,
          child: TickerMode(
            enabled: currentValue == 1,
            child: ProgectPage(),
          ),
        ),
      ],
    );

    return Column(
      children: <Widget>[titileBar, Flexible(child: body)],
    );
  }
}
