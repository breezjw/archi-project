
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class_exercise.g.dart';

@JsonSerializable()
class ClassExercise {
  String classExerciseId = "";
  String trainerClassId;
  String status;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime startDate;
  @JsonKey(fromJson: dateTimeFromTimestamp)
  DateTime endDate;
  int exerciseCount;

  ClassExercise({
    docId,
    required this.trainerClassId,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.exerciseCount = 0
  });

  factory ClassExercise.fromJson(Map<String, dynamic> json) =>
      _$ClassPlayStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ClassPlayStatusToJson(this);

  factory ClassExercise.fromSnapshot(DocumentSnapshot snap) {
    Timestamp startDateTimestamp = snap.get(FireStoreClassPlayStatus.startDate);
    DateTime startDate = startDateTimestamp.toDate();

    Timestamp endDateTimestamp = snap.get(FireStoreClassPlayStatus.endDate);
    DateTime endDate = startDateTimestamp.toDate();

    return ClassExercise(
      docId: snap.id,
      trainerClassId: snap.get(FireStoreClassPlayStatus.trainerClassId),
      status: snap.get(FireStoreClassPlayStatus.status),
      startDate: startDate,
      endDate: endDate,
      exerciseCount: snap.get(FireStoreClassPlayStatus.playCount)
    );
  }
}

DateTime dateTimeFromTimestamp(Timestamp timestamp) {
  return timestamp.toDate();
}

class FireStoreClassPlayStatus {
  static const String collection = "trainerClassStatus";
  static const String trainerClassId = "trainerClassId";
  static const String status = "status";
  static const String startDate = "startDate";
  static const String endDate = "endDate";
  static const String playCount = "playCount";
}