import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/page/article_detail.dart';

class TagWidget extends StatelessWidget {
  final List<Tag> tags;

  TagWidget(this.tags);

  @override
  Widget build(BuildContext context) {
    var childrens = <Widget>[];
    for (var value in tags) {
      childrens.add(_generateTag(context, value));
    }
    return Row(
      children: childrens,
    );
  }
}

Widget _generateTag(BuildContext context, Tag tag) {
  return Card(
    margin: EdgeInsets.only(left: 0.0),
//    color: tag.color,
    color: Colors.blue,
    child: Padding(
      padding: EdgeInsets.only(left: 8.0, top: 2.0, right: 8.0, bottom: 2.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleDetailPage(
                      'http://www.wanandroid.com${tag.url}', false)));
        },
        child: Text(tag.name,
            style: TextStyle(color: Colors.white, fontSize: 12.0)),
      ),
    ),
  );
}
