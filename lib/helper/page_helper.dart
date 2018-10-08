import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PageHelper {
  static goDetailPage(BuildContext context, String url, bool isCollect) {
    print('Go detail page');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebviewScaffold(
                  url: url,
                  appBar: AppBar(
//                          title: Text(article.title),
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          isCollect ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('Do collect');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          print('Do share');
                        },
                      )
                    ],
                  ),
                  scrollBar: true,
                  withLocalStorage: true,
                )));
  }
}
