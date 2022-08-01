// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_play_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberPlayStatus _$MemberPlayStatusFromJson(Map<String, dynamic> json) =>
    MemberPlayStatus(
      docId: json['docId'],
      classId: json['classId'] as String,
      playCount: json['playCount'] as int,
      name: json['name'] as String,
      controlSpeed: json['controlSpeed'] as int,
      controlCount: json['controlCount'] as int,
      controlStrength: json['controlStrength'] as int,
      speed: (json['speed'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as int),
      ),
      count: (json['count'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as int),
      ),
      strength: (json['strength'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as int),
      ),
      workoutStatus: json['workoutStatus'] as String,
    );

Map<String, dynamic> _$MemberPlayStatusToJson(MemberPlayStatus instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'classId': instance.classId,
      'playCount': instance.playCount,
      'name': instance.name,
      'controlSpeed': instance.controlSpeed,
      'controlCount': instance.controlCount,
      'controlStrength': instance.controlStrength,
      'speed': instance.speed.map((k, e) => MapEntry(k.toString(), e)),
      'count': instance.count.map((k, e) => MapEntry(k.toString(), e)),
      'strength': instance.strength.map((k, e) => MapEntry(k.toString(), e)),
      'workoutStatus': instance.workoutStatus,
    };
