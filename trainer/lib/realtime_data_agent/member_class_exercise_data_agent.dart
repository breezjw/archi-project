import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_exercise.dart';

class MemberClassExerciseDataAgent {
  final _logger = Logger();
  CollectionReference memberPlayStatusRef =
    FirebaseFirestore.instance.collection(FireStoreMemberPlayStatus.collection);

  Stream<List<MemberClassExercise>> listMemberClassExerciseStream(String classId, int exerciseCount) {
    return memberPlayStatusRef.where(FireStoreMemberPlayStatus.classId, isEqualTo: classId)
    .where(FireStoreMemberPlayStatus.playCount, isEqualTo: exerciseCount)
    .snapshots()
    .map((query) => query.docs.map((doc) {
      _logger.d(doc.id);
      var memberPlayStatus =  MemberClassExercise.fromSnapshot(doc);
      memberPlayStatus.memberClassExerciseId = doc.id;

      return memberPlayStatus;
    }).toList());
  }

  Future<List<MemberClassExercise>> listMemberClassExercise(String classId) {
    _logger.d(classId);

    return memberPlayStatusRef
        .where(FireStoreMemberPlayStatus.classId, isEqualTo: classId)
        .get()
        .then((value) => value.docs.map((e) => MemberClassExercise.fromSnapshot(e)).toList());
  }

  MemberClassExercise _dataFromSnapshot(
      DocumentSnapshot snapshot,
      ) {

    _logger.d(snapshot.data());

    var memberPlayStatus =  MemberClassExercise.fromJson(snapshot.data() as Map<String, dynamic>);
    memberPlayStatus.memberClassExerciseId = snapshot.id;

    return memberPlayStatus;
  }

  Stream<MemberClassExercise> getMemberClassExerciseStream(String id) {
    _logger.d(id);
    return memberPlayStatusRef
        .doc(id)
        .snapshots()
        .map(_dataFromSnapshot);
  }

  Future<String?> addMemberClassExercise(String classId, String memberId, String memberName) async {
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
  
  updateMembeClassrExercise(MemberClassExercise memberPlayStatus) {
    memberPlayStatusRef
      .doc(memberPlayStatus.memberClassExerciseId)
      .update(
        memberPlayStatus.toJson()
    );
  }
}