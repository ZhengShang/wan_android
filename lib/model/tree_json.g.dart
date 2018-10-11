// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tree_json.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreeJson _$TreeJsonFromJson(Map<String, dynamic> json) {
  return TreeJson((json['data'] as List)
      ?.map((e) =>
          e == null ? null : TreeChildren.fromJson(e as Map<String, dynamic>))
      ?.toList())
    ..errorCode = json['errorCode'] as int
    ..errorMsg = json['errorMsg'] as String;
}

Map<String, dynamic> _$TreeJsonToJson(TreeJson instance) => <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data
    };

TreeChildren _$TreeChildrenFromJson(Map<String, dynamic> json) {
  return TreeChildren(
      children: (json['children'] as List)
          ?.map((e) => e == null
              ? null
              : TreeChildren.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      courseId: json['courseId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      order: json['order'] as int,
      parentChapterId: json['parentChapterId'] as int,
      visible: json['visible'] as int);
}

Map<String, dynamic> _$TreeChildrenToJson(TreeChildren instance) =>
    <String, dynamic>{
      'children': instance.children,
      'courseId': instance.courseId,
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'parentChapterId': instance.parentChapterId,
      'visible': instance.visible
    };
