
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerClass {
  final String docId;
  final String trainerId;
  final String name;

  TrainerClass({
    required this.docId,
    required this.trainerId,
    required this.name,
  });

  factory TrainerClass.fromSnapshot(DocumentSnapshot snap) {
    return TrainerClass(
        docId: snap.id,
        trainerId: snap.get(FireStoreClass.name),
        name: snap.get(FireStoreClass.name),
    );
  }
}

class FireStoreClass {
  static const String collection = "team_group";
  static const String trainerId = "trainerId";
  static const String name = "name";
}