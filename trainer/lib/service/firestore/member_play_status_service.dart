import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/model/trainer_class.dart';

class MemberPlayStatusService {
  final _logger = Logger();
  CollectionReference memberPlayStatusRef =
    FirebaseFirestore.instance.collection(FireStoreMemberPlayStatus.collection);

  Stream<List<MemberPlayStatus>> listMemberPlayStatusStream(String classId) {
    return memberPlayStatusRef.where(FireStoreMemberPlayStatus.classId, isEqualTo: classId).snapshots()
    .map((query) => query.docs.map((doc) {
      _logger.d(doc.id);
      var memberPlayStatus =  MemberPlayStatus.fromSnapshot(doc);
      memberPlayStatus.docId = doc.id;

      return memberPlayStatus;
    }).toList());
  }

  Future<List<MemberPlayStatus>> listMemberPlayStatus(String classId) {
    return memberPlayStatusRef
        .where(FireStoreMemberPlayStatus.classId, isEqualTo: classId)
        .get()
        .then((value) => value.docs.map((e) => MemberPlayStatus.fromSnapshot(e)).toList());
  }

  MemberPlayStatus _dataFromSnapshot(
      DocumentSnapshot snapshot,
      ) {
    var memberPlayStatus =  MemberPlayStatus.fromJson(snapshot.data() as Map<String, dynamic>);
    memberPlayStatus.docId = snapshot.id;

    return memberPlayStatus;
  }

  Stream<MemberPlayStatus> getMemberPlayStatusStream(String id) {
    return memberPlayStatusRef
        .doc(id)
        .snapshots()
        .map(_dataFromSnapshot);
  }
  
  updateMemberPlayStatus(MemberPlayStatus memberPlayStatus) {
    memberPlayStatusRef
      .doc(memberPlayStatus.docId)
      .update(
        memberPlayStatus.toJson()
    );
  }
}