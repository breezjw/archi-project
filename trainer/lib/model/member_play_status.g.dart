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
      realtimeSpeed: (json['realtimeSpeed'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(int.parse(k), e as int),
              ))
          .toList(),
      realtimeCount: json['realtimeCount'] as int,
      realtimeStrength: (json['realtimeStrength'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(int.parse(k), e as int),
              ))
          .toList(),
      workoutStatus: json['workoutStatus'] as String,
    );

Map<String, dynamic> _$MemberPlayStatusToJson(MemberPlayStatus instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'classId': instance.classId,
      'name': instance.name,
      'speed': instance.speed,
      'count': instance.count,
      'strength': instance.strength,
      'realtimeSpeed': instance.realtimeSpeed
          .map((e) => e.map((k, e) => MapEntry(k.toString(), e)))
          .toList(),
      'realtimeCount': instance.realtimeCount,
      'realtimeStrength': instance.realtimeStrength
          .map((e) => e.map((k, e) => MapEntry(k.toString(), e)))
          .toList(),
      'workoutStatus': instance.workoutStatus,
    };
