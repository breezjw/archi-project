
import 'package:cloud_firestore/cloud_firestore.dart';

class Gems {
  final String gemsId;
  final String name;
  final bool isAssigned;

  Gems({
    required this.gemsId,
    required this.name,
    required this.isAssigned
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