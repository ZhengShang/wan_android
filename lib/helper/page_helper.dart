import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android/page/article_detail.dart';

class PageHelper {
  static goDetailPage(BuildContext context, String url, bool isCollect) {
    print('Go detail page');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleDetailPage(url, isCollect)));
  }
}
