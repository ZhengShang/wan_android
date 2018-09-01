// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotkey_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotKeyJson _$HotKeyJsonFromJson(Map<String, dynamic> json) {
  return HotKeyJson((json['data'] as List)
      ?.map(
          (e) => e == null ? null : HotKey.fromJson(e as Map<String, dynamic>))
      ?.toList())
    ..errorCode = json['errorCode'] as int
    ..errorMsg = json['errorMsg'] as String;
}

Map<String, dynamic> _$HotKeyJsonToJson(HotKeyJson instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data
    };

HotKey _$HotKeyFromJson(Map<String, dynamic> json) {
  return HotKey(
      id: json['id'] as int,
      link: json['link'] as String,
      name: json['name'] as String,
      order: json['order'] as int,
      visible: json['visible'] as int);
}

Map<String, dynamic> _$HotKeyToJson(HotKey instance) => <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'name': instance.name,
      'order': instance.order,
      'visible': instance.visible
    };
