// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassExercise _$ClassPlayStatusFromJson(Map<String, dynamic> json) =>
    ClassExercise(
      docId: json['docId'],
      trainerClassId: json['trainerClassId'] as String,
      status: json['status'] as String,
      startDate: dateTimeFromTimestamp(json['startDate'] as Timestamp),
      endDate: dateTimeFromTimestamp(json['endDate'] as Timestamp),
      exerciseCount: json['playCount'] as int? ?? 0,
    );

Map<String, dynamic> _$ClassPlayStatusToJson(ClassExercise instance) =>
    <String, dynamic>{
      'docId': instance.classExerciseId,
      'trainerClassId': instance.trainerClassId,
      'status': instance.status,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'playCount': instance.exerciseCount,
    };
