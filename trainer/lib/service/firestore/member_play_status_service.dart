import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/model/trainer_class.dart';

class MemberPlayStatusService {
  final _logger = Logger();
  CollectionReference memberPlayStatusRef =
    FirebaseFirestore.instance.collection(FireStoreMemberPlayStatus.collection);

  Stream<List<MemberPlayStatus>> listMemberPlayStatusStream(String classId, int playCount) {
    return memberPlayStatusRef.where(FireStoreMemberPlayStatus.classId, isEqualTo: classId)
    .where(FireStoreMemberPlayStatus.playCount, isEqualTo: playCount)
    .snapshots()
    .map((query) => query.docs.map((doc) {
      _logger.d(doc.id);
      var memberPlayStatus =  MemberPlayStatus.fromSnapshot(doc);
      memberPlayStatus.docId = doc.id;

      return memberPlayStatus;
    }).toList());
  }

  Future<List<MemberPlayStatus>> listMemberPlayStatus(String classId) {
    _logger.d(classId);

    return memberPlayStatusRef
        .where(FireStoreMemberPlayStatus.classId, isEqualTo: classId)
        .get()
        .then((value) => value.docs.map((e) => MemberPlayStatus.fromSnapshot(e)).toList());
  }

  MemberPlayStatus _dataFromSnapshot(
      DocumentSnapshot snapshot,
      ) {

    _logger.d(snapshot.data());

    var memberPlayStatus =  MemberPlayStatus.fromJson(snapshot.data() as Map<String, dynamic>);
    memberPlayStatus.docId = snapshot.id;

    return memberPlayStatus;
  }

  Stream<MemberPlayStatus> getMemberPlayStatusStream(String id) {
    _logger.d(id);
    return memberPlayStatusRef
        .doc(id)
        .snapshots()
        .map(_dataFromSnapshot);
  }

  Future<String?> addMemberPlayStatus(String classId, String memberId, String memberName) async {
    String? docId = "${classId}_$memberId";

    await memberPlayStatusRef.doc(docId).set({
      FireStoreMemberPlayStatus.classId: classId,
      FireStoreMemberPlayStatus.name: memberName,
      FireStoreMemberPlayStatus.playCount: 0,
      FireStoreMemberPlayStatus.workoutStatus: "normal",
      FireStoreMemberPlayStatus.controlCount: 0,
      FireStoreMemberPlayStatus.controlSpeed: 0,
      FireStoreMemberPlayStatus.controlStrength: 0,
      FireStoreMemberPlayStatus.count: {},
      FireStoreMemberPlayStatus.speed: {},
      FireStoreMemberPlayStatus.strength: {},
    })
    .then((value) {
      logger.d("MemberPlayStatus added");
    })
    .catchError((error) {
      logger.e("Failed to add MemberPlayStatus: $error");
      docId = null;
    });

    return docId;
  }
  
  updateMemberPlayStatus(MemberPlayStatus memberPlayStatus) {
    memberPlayStatusRef
      .doc(memberPlayStatus.docId)
      .update(
        memberPlayStatus.toJson()
    );
  }
}