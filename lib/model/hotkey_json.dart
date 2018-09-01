import 'package:json_annotation/json_annotation.dart';
import 'package:wan_android/model/base_json.dart';

part 'hotkey_json.g.dart';

@JsonSerializable()
class HotKeyJson extends BaseJson {
  List<HotKey> data;

  HotKeyJson(this.data);

  factory HotKeyJson.fromJson(Map<String, dynamic> json) =>
      _$HotKeyJsonFromJson(json);

  Map<String, dynamic> toJson() => _$HotKeyJsonToJson(this);
}

@JsonSerializable()
class HotKey {
  /*
      "id": 6,
      "link": "",
      "name": "面试",
      "order": 1,
      "visible": 1
   */
  int id;
  String link;
  String name;
  int order;
  int visible;

  HotKey({this.id, this.link, this.name, this.order, this.visible});


  factory HotKey.fromJson(Map<String, dynamic> json) => _$HotKeyFromJson(json);

  Map<String, dynamic> toJson() => _$HotKeyToJson(this);
}
