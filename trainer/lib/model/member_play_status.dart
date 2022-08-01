
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'member_play_status.g.dart';

final Logger logger = Logger();

class FireStoreMemberPlayStatus {
  static const String collection = "memberPlayStatus";
  static const String classId = "classId";
  static const String playCount = "playCount";
  static const String name = "name";
  static const String controlSpeed = "controlSpeed";
  static const String controlCount = "controlCount";
  static const String controlStrength = "controlStrength";
  static const String speed = "speed";
  static const String count = "count";
  static const String strength = "strength";
  static const String workoutStatus = "workoutStatus";
}

@JsonSerializable()
class MemberPlayStatus {
  //TODO: docId
  String docId = "";
  String classId;
  int playCount;
  String name;
  int controlSpeed;
  int controlCount;
  int controlStrength;
  Map<int, int> speed;
  Map<int, int> count;
  Map<int, int> strength;
  String workoutStatus;

  MemberPlayStatus({
    docId,
    required this.classId,
    required this.playCount,
    required this.name,
    required this.controlSpeed,
    required this.controlCount,
    required this.controlStrength,
    required this.speed,
    required this.count,
    required this.strength,
    required this.workoutStatus,
  });

  static List<Map<int, int>> convertListMap(List<dynamic> listFirestore) {
    return listFirestore.map((e) {
      var test = e as Map<String, dynamic>;
      return test.map((key, value) =>MapEntry(int.parse(key), value as int));
    }).toList();
  }

  static Map<int, int> convertMap(Map<String, dynamic> mapFirestore) {
    return mapFirestore.map((key, value) => MapEntry(int.parse(key), value as int));
  }

  factory MemberPlayStatus.fromJson(Map<String, dynamic> json) => _$MemberPlayStatusFromJson(json);
  Map<String, dynamic> toJson() => _$MemberPlayStatusToJson(this);

  factory MemberPlayStatus.fromSnapshot(DocumentSnapshot snap) {
      return MemberPlayStatus(
      docId: snap.id,
      classId: snap.get(FireStoreMemberPlayStatus.classId),
      playCount: snap.get(FireStoreMemberPlayStatus.playCount),
      name: snap.get(FireStoreMemberPlayStatus.name),
      controlSpeed: snap.get(FireStoreMemberPlayStatus.controlSpeed),
      controlCount: snap.get(FireStoreMemberPlayStatus.controlCount),
      controlStrength: snap.get(FireStoreMemberPlayStatus.controlStrength),
      speed: convertMap(snap.get(FireStoreMemberPlayStatus.speed)),
      count: convertMap(snap.get(FireStoreMemberPlayStatus.count)),
      strength: convertMap(snap.get(FireStoreMemberPlayStatus.count)),
      workoutStatus: snap.get(FireStoreMemberPlayStatus.workoutStatus),
    );
  }
}
