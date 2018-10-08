import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wan_android/page/home_page.dart';
import 'package:wan_android/page/me_page.dart';
import 'package:wan_android/page/tree_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyNavi();
}

class _MyNavi extends State<MyApp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
        title: "Wan Android",
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              Offstage(
                offstage: index != 0,
                child: TickerMode(
                  enabled: index == 0,
                  child: HomePage(),
                ),
              ),
              Offstage(
                offstage: index != 1,
                child: TickerMode(
                  enabled: index == 1,
                  child: TreePage(),
                ),
              ),
              Offstage(
                offstage: index != 2,
                child: TickerMode(
                  enabled: index == 2,
                  child: MePage(),
                ),
              )
            ],
          ),
          bottomNavigationBar: new BottomNavigationBar(
            currentIndex: index,
            onTap: (int index) {
              setState(() {
                this.index = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("主页"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps),
                title: Text("体系"),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("我"))
            ],
          ),
        ));
  }
}
