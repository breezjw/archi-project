import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/model/trainer_class.dart';

class MemberPlayStatusService {
  final _logger = Logger();
  CollectionReference memberPlayStatusRef =
    FirebaseFirestore.instance.collection(FireStoreMemberPlayStatus.collection);

  Stream<List<Member>> listMemberPlayStatusStream(String classId) {
    return memberPlayStatusRef.where(FireStoreMemberPlayStatus.classId, isEqualTo: classId).snapshots()
    .map((query) => query.docs.map((doc) {
      _logger.d(doc.id);
      var memberPlayStatus =  Member.fromSnapshot(doc);
      memberPlayStatus.docId = doc.id;

      return memberPlayStatus;
    }).toList());
  }

  Future<List<Member>> listMemberPlayStatus(String classId) {
    return memberPlayStatusRef
        .where(FireStoreMemberPlayStatus.classId, isEqualTo: classId)
        .get()
        .then((value) => value.docs.map((e) => Member.fromSnapshot(e)).toList());
  }

  Member _dataFromSnapshot(
      DocumentSnapshot snapshot,
      ) {
    var memberPlayStatus =  Member.fromJson(snapshot.data() as Map<String, dynamic>);
    memberPlayStatus.docId = snapshot.id;

    return memberPlayStatus;
  }

  Stream<Member> getMemberPlayStatusStream(String id) {
    return memberPlayStatusRef
        .doc(id)
        .snapshots()
        .map(_dataFromSnapshot);
  }
  
  updateMemberPlayStatus(Member memberPlayStatus) {
    memberPlayStatusRef
      .doc(memberPlayStatus.docId)
      .update(
        memberPlayStatus.toJson()
    );
  }
}