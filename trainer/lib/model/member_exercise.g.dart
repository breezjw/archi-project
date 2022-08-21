// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberClassExercise _$MemberPlayStatusFromJson(Map<String, dynamic> json) =>
    MemberClassExercise(
      docId: json['docId'],
      classId: json['classId'] as String,
      exerciseCount: json['playCount'] as int,
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
      exerciseStatus: json['workoutStatus'] as String,
    );

Map<String, dynamic> _$MemberPlayStatusToJson(MemberClassExercise instance) =>
    <String, dynamic>{
      'docId': instance.memberClassExerciseId,
      'classId': instance.classId,
      'playCount': instance.exerciseCount,
      'name': instance.name,
      'controlSpeed': instance.controlSpeed,
      'controlCount': instance.controlCount,
      'controlStrength': instance.controlStrength,
      'speed': instance.speed.map((k, e) => MapEntry(k.toString(), e)),
      'count': instance.count.map((k, e) => MapEntry(k.toString(), e)),
      'strength': instance.strength.map((k, e) => MapEntry(k.toString(), e)),
      'workoutStatus': instance.exerciseStatus,
    };
