// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_play_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassPlayStatus _$ClassPlayStatusFromJson(Map<String, dynamic> json) =>
    ClassPlayStatus(
      docId: json['docId'],
      trainerClassId: json['trainerClassId'] as String,
      status: json['status'] as String,
      startDate: dateTimeFromTimestamp(json['startDate'] as Timestamp),
      endDate: dateTimeFromTimestamp(json['endDate'] as Timestamp),
      playCount: json['playCount'] as int? ?? 0,
    );

Map<String, dynamic> _$ClassPlayStatusToJson(ClassPlayStatus instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'trainerClassId': instance.trainerClassId,
      'status': instance.status,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'playCount': instance.playCount,
    };
