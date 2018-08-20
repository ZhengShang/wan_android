import 'package:json_annotation/json_annotation.dart';
import 'package:wan_android/model/base_json.dart';

part 'banner_json.g.dart';

@JsonSerializable()
class BannerJson extends BaseJson {
  List<Bner> data;

  BannerJson(this.data);

  factory BannerJson.fromJson(Map<String, dynamic> json) =>
      _$BannerJsonFromJson(json);

  Map<String, dynamic> toJson() => _$BannerJsonToJson(this);
}

@JsonSerializable()
class Bner {
  /*
      "desc": "",
      "id": 2,
      "imagePath": "http://www.wanandroid.com/blogimgs/90cf8c40-9489-4f9d-8936-02c9ebae31f0.png",
      "isVisible": 1,
      "order": 2,
      "title": "JSON工具",
      "type": 1,
      "url": "http://www.wanandroid.com/tools/bejson"
   */
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  Bner(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  factory Bner.fromJson(Map<String, dynamic> json) => _$BnerFromJson(json);

  Map<String, dynamic> toJson() => _$BnerToJson(this);
}
