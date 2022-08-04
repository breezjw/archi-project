
import 'package:cloud_firestore/cloud_firestore.dart';

class Gems {
  final String id;
  final String name;

  Gems({
    required this.id,
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