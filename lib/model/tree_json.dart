import 'package:json_annotation/json_annotation.dart';
import 'package:wan_android/model/base_json.dart';

part 'tree_json.g.dart';

@JsonSerializable()
class TreeJson extends BaseJson {
  List<TreeChildren> data;

  TreeJson(this.data);

  factory TreeJson.fromJson(Map<String, dynamic> json) =>
      _$TreeJsonFromJson(json);
}

@JsonSerializable()
class TreeChildren {
  /*
   "children": [],
          "courseId": 13,
          "id": 60,
          "name": "Android Studio相关",
          "order": 1000,
          "parentChapterId": 150,
          "visible": 1
   */

  List<TreeChildren> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  int visible;

  TreeChildren(
      {this.children,
      this.courseId,
      this.id,
      this.name,
      this.order,
      this.parentChapterId,
      this.visible});

  factory TreeChildren.fromJson(Map<String, dynamic> json) =>
      _$TreeChildrenFromJson(json);
}
