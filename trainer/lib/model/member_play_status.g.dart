// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_play_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberPlayStatus _$MemberPlayStatusFromJson(Map<String, dynamic> json) =>
    MemberPlayStatus(
      docId: json['docId'],
      classId: json['classId'] as String,
      name: json['name'] as String,
      speed: json['speed'] as int,
      count: json['count'] as int,
      strength: json['strength'] as int,
    );

Map<String, dynamic> _$MemberPlayStatusToJson(MemberPlayStatus instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'classId': instance.classId,
      'name': instance.name,
      'speed': instance.speed,
      'count': instance.count,
      'strength': instance.strength,
    };
