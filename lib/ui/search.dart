import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: IconTheme(
        data: IconThemeData(color: Theme.of(context).accentColor),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          margin: MediaQuery.of(context).padding,
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  padding: EdgeInsets.only(left: 8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.black26),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                        hintText: "关键词"),
                  ),
                ),
              ),
              Text("Cancel")
            ],
          ),
        ), //new
      )),
    );
  }
}

class MyChipGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyChipGroupState();
  }
}

class _MyChipGroupState extends State<MyChipGroup> {
  @override
  Widget build(BuildContext context) {
    return Chip(label: Text("Hello"));
  }
}
