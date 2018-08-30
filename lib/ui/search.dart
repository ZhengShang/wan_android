import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: MediaQuery.of(context).padding,
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    hintText: 'Please enter a search term'),
              ),
              MyChipGroup()
            ],
          ),
        ),
      ),
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
