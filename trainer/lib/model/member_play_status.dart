
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_play_status.g.dart';

@JsonSerializable()
class MemberPlayStatus {
  //TODO: docId
  String docId = "";
  String classId;
  String name;
  int speed;
  int count;
  int strength;

  MemberPlayStatus({
    docId,
    required this.classId,
    required this.name,
    required this.speed,
    required this.count,
    required this.strength,
  });

  factory MemberPlayStatus.fromJson(Map<String, dynamic> json) => _$MemberPlayStatusFromJson(json);
  Map<String, dynamic> toJson() => _$MemberPlayStatusToJson(this);

  factory MemberPlayStatus.fromSnapshot(DocumentSnapshot snap) {
      return MemberPlayStatus(
      docId: snap.id,
      classId: snap.get(FireStoreMemberPlayStatus.classId),
      name: snap.get(FireStoreMemberPlayStatus.name),
      speed: snap.get(FireStoreMemberPlayStatus.speed),
      count: snap.get(FireStoreMemberPlayStatus.count),
      strength: snap.get(FireStoreMemberPlayStatus.strength),
    );
  }
}

class FireStoreMemberPlayStatus {
  static const String collection = "member_play_status";
  static const String classId = "classId";
  static const String name = "name";
  static const String speed = "speed";
  static const String count = "count";
  static const String strength = "strength";
}