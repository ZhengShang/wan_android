import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArticleDetailPage extends StatelessWidget {
  final String url;
  final bool isCollect;

  ArticleDetailPage(this.url, this.isCollect);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
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
    );
  }
}
