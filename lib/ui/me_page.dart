import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  const MePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
        child: ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('is default list $index'),
        );
      },
      itemCount: 20,
    ));
  }
}
