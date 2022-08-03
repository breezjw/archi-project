
import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String memberId;
  final String name;

  Member({
    required this.memberId,
    required this.name,
  });

  // factory Member.fromSnapshot(DocumentSnapshot snap) {
  //   return Member(
  //       docId: snap.id,
  //       name: snap.get(FireStoreClass.name),
  //   );
  // }
}

// class_list FireStoreClass {
//   static const String collection = "team_group";
//   static const String name = "name";
// }