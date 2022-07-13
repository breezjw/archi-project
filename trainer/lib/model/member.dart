
import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String docId;
  final String name;

  Member({
    required this.docId,
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