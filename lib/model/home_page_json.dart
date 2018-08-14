import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'home_page_json.g.dart';

@JsonSerializable()
class HomePageJson {
  /*
    "data": {
        "curPage": 2,
        "datas": [],
        "offset": 20,
        "over": false,
        "pageCount": 77,
        "size": 20,
        "total": 1522
     }
    "errorCode": 0,
    "errorMsg": ""
   */

  int errorCode;
  String errorMsg;
  Data data;

  HomePageJson({this.errorCode, this.errorMsg, this.data});

  factory HomePageJson.fromJson(Map<String, dynamic> json) =>
      _$HomePageJsonFromJson(json);

  Map<String, dynamic> toJson() => _$HomePageJsonToJson(this);
}

@JsonSerializable()
class Data {
  /*
        "curPage": 2,
        "datas": [],
        "offset": 20,
        "over": false,
        "pageCount": 77,
        "size": 20,
        "total": 1522
   */
  int curPage;
  List<Article> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  Data(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Article {
  /*
   "    apkLink": "",
        "author": "mouxuefei",
        "chapterId": 338,
        "chapterName": "日历&amp;时钟",
        "collect": false,
        "courseId": 13,
        "desc": "今天玩小米mix2的时候看到了小米的时间控件效果真的很棒。有各种动画效果，3d触摸效果，然后就想着自己能不能也实现一个这样的时间控件，那就开始行动绘制一个简易版本的小米时间控件吧o((≧▽≦o)",
        "envelopePic": "http://www.wanandroid.com/blogimgs/d61e55e4-cd39-4940-a1ad-befc4aeb9f78.png",
        "fresh": false,
        "id": 3202,
        "link": "http://www.wanandroid.com/blog/show/2256",
        "niceDate": "2018-07-30",
        "origin": "",
        "projectLink": "https://github.com/mouxuefei/MIClockView",
        "publishTime": 1532965108000,
        "superChapterId": 294,
        "superChapterName": "开源项目主Tab",
        "tags": [
          {
            "name": "项目",
            "url": "/project/list/1?cid=338"
          }
        ],
        "title": "自定义view之kotlin绘制精简小米时间控件 MIClockView",
        "type": 0,
        "userId": -1,
        "visible": 1,
        "zan": 0
   */

  String apkLink;
  String author;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String origin;
  String projectLink;
  double publishTime;
  int superChapterId;
  String superChapterName;
  List<Tag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  Article(
      {this.apkLink,
      this.author,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.envelopePic,
      this.fresh,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.projectLink,
      this.publishTime,
      this.superChapterId,
      this.superChapterName,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan});

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  @override
  String toString() {
    return 'Article{apkLink: $apkLink, author: $author, chapterId: $chapterId, chapterName: $chapterName, collect: $collect, courseId: $courseId, desc: $desc, envelopePic: $envelopePic, fresh: $fresh, id: $id, link: $link, niceDate: $niceDate, origin: $origin, projectLink: $projectLink, publishTime: $publishTime, superChapterId: $superChapterId, superChapterName: $superChapterName, tags: $tags, title: $title, type: $type, userId: $userId, visible: $visible, zan: $zan}';
  }
}

@JsonSerializable()
class Tag {
  /*
  "  tags": [
          {
            "name": "项目",
            "url": "/project/list/1?cid=338"
          }
        ],
   */
  String name;
  String url;
  Color color;

  Tag({this.name, this.url}) {
    //每一个Tag，都分配唯一随即颜色。 如果初始化在TagWidget中，则会随着列表的回收机制，
    //不断的改变其颜色，无法做到不变。
    final int r = Random().nextInt(255);
    final int g = Random().nextInt(255);
    final int b = Random().nextInt(255);
    final color = Color.fromARGB(255, r, g, b);
    this.color = color;
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);

  Map<String, dynamic> toJson() => _$TagsToJson(this);
}
