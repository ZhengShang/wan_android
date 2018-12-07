import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android/helper/page_helper.dart';
import 'package:wan_android/model/home_page_json.dart';
import 'package:wan_android/page/user_page.dart';
import 'package:wan_android/widget/tag_widget.dart';

class ArticleListRow extends StatefulWidget {
  final Article article;

  ArticleListRow(this.article);

  @override
  _ArticleListRowState createState() => _ArticleListRowState();
}

class _ArticleListRowState extends State<ArticleListRow> {
  @override
  Widget build(BuildContext context) {
    final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);
    final TextStyle _grayText =
        new TextStyle(fontSize: 12.0, color: Colors.grey);

    final article = widget.article;

    return Card(
      margin: EdgeInsets.only(left: 12.0, top: 6.0, right: 12.0, bottom: 6.0),
      elevation: 12.0,
      child: InkWell(
        onTap: () {
          PageHelper.goDetailPage(context, article.link, article.collect);
        },
        child: _getBanneredWidget(
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          print('Go to the author page');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserPage(article.author)));
                        },
                        child: Text(
                          article.author,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        article.niceDate,
                        style: _grayText,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Text(
                    article.title,
                    style: _biggerFont,
                  ),
                  TagWidget(article.tags),
                  Text(article.desc, style: _grayText),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              print('Go to superChapter page');
                            },
                            child: Text(
                              article.superChapterName,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          Icon(
                            Icons.arrow_right,
                            color: Colors.grey,
                          ),
                          InkWell(
                              onTap: () {
                                print('Go to chapter page');
                              },
                              child: Text(article.chapterName,
                                  style: TextStyle(color: Colors.blue)))
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                            article.collect
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: article.collect ? Colors.red : Colors.grey),
                        onPressed: () {
                          print('do collect');
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
            article),
      ),
    );
  }

  /// 对于refre标记的文章，标记为"NEW"
  Widget _getBanneredWidget(Widget w, Article article) {
    if (article.fresh) {
      return Banner(
        message: "NEW",
        location: BannerLocation.topEnd,
        color: Colors.red,
        child: w,
      );
    } else {
      return w;
    }
  }
}
