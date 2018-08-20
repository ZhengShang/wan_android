// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerJson _$BannerJsonFromJson(Map<String, dynamic> json) {
  return BannerJson((json['data'] as List)
      ?.map((e) => e == null ? null : Bner.fromJson(e as Map<String, dynamic>))
      ?.toList())
    ..errorCode = json['errorCode'] as int
    ..errorMsg = json['errorMsg'] as String;
}

Map<String, dynamic> _$BannerJsonToJson(BannerJson instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data
    };

Bner _$BnerFromJson(Map<String, dynamic> json) {
  return Bner(
      desc: json['desc'] as String,
      id: json['id'] as int,
      imagePath: json['imagePath'] as String,
      isVisible: json['isVisible'] as int,
      order: json['order'] as int,
      title: json['title'] as String,
      type: json['type'] as int,
      url: json['url'] as String);
}

Map<String, dynamic> _$BnerToJson(Bner instance) => <String, dynamic>{
      'desc': instance.desc,
      'id': instance.id,
      'imagePath': instance.imagePath,
      'isVisible': instance.isVisible,
      'order': instance.order,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url
    };
