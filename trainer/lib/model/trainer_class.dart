
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
        trainerId: snap.get(FireStoreTrainerClass.name),
        name: snap.get(FireStoreTrainerClass.name),
    );
  }
}

class FireStoreTrainerClass {
  static const String collection = "trainerClass";
  static const String trainerId = "trainerId";
  static const String name = "name";
}