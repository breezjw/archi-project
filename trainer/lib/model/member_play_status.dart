
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'member_play_status.g.dart';

final Logger logger = Logger();

class FireStoreMemberPlayStatus {
  static const String collection = "memberPlayStatus";
  static const String classId = "classId";
  static const String name = "name";
  static const String speed = "speed";
  static const String count = "count";
  static const String strength = "strength";
  static const String realtimeSpeed = "realtimeSpeed";
  static const String realtimeCount = "realtimeCount";
  static const String realtimeStrength = "realtimeStrength";
  static const String workoutStatus = "workoutStatus";
}

@JsonSerializable()
class MemberPlayStatus {
  //TODO: docId
  String docId = "";
  String classId;
  String name;
  int speed;
  int count;
  int strength;
  List<Map<int, int>> realtimeSpeed;
  int realtimeCount;
  List<Map<int, int>> realtimeStrength;
  String workoutStatus;

  MemberPlayStatus({
    docId,
    required this.classId,
    required this.name,
    required this.speed,
    required this.count,
    required this.strength,
    required this.realtimeSpeed,
    required this.realtimeCount,
    required this.realtimeStrength,
    required this.workoutStatus,
  });

  static List<Map<int, int>> convertListMap(List<dynamic> listFirestore) {
    return listFirestore.map((e) {
      var test = e as Map<String, dynamic>;
      return test.map((key, value) =>MapEntry(int.parse(key), value as int));
    }).toList();
  }

  factory MemberPlayStatus.fromJson(Map<String, dynamic> json) => _$MemberPlayStatusFromJson(json);
  Map<String, dynamic> toJson() => _$MemberPlayStatusToJson(this);

  factory MemberPlayStatus.fromSnapshot(DocumentSnapshot snap) {

      var speeds = convertListMap(snap.get(FireStoreMemberPlayStatus.realtimeSpeed) as List);
      var strengths = convertListMap(snap.get(FireStoreMemberPlayStatus.realtimeStrength) as List);

      return MemberPlayStatus(
      docId: snap.id,
      classId: snap.get(FireStoreMemberPlayStatus.classId),
      name: snap.get(FireStoreMemberPlayStatus.name),
      speed: snap.get(FireStoreMemberPlayStatus.speed),
      count: snap.get(FireStoreMemberPlayStatus.count),
      strength: snap.get(FireStoreMemberPlayStatus.strength),
      realtimeSpeed: speeds,
      realtimeCount: snap.get(FireStoreMemberPlayStatus.realtimeCount),
      realtimeStrength: strengths,
      workoutStatus: snap.get(FireStoreMemberPlayStatus.workoutStatus),
    );
  }
}
