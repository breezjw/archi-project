import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/trainer_class.dart';

class ClassService {
  final _logger = Logger();
  CollectionReference classRef = FirebaseFirestore.instance.collection(FireStoreClass.collection);

  Stream<List<TrainerClass>> listClassSnapshot(String trainerId) {
    return classRef.where(FireStoreClass.trainerId, isEqualTo: trainerId).snapshots()
    .map((query) => query.docs.map((doc) {
      _logger.d(doc.id);
      return TrainerClass.fromSnapshot(doc);
    }).toList());
  }

  Future<List<TrainerClass>> listClass(String trainerId) {
    return classRef
        .where(FireStoreClass.trainerId, isEqualTo: trainerId)
        .get()
        .then((value) => value.docs.map((e) => TrainerClass.fromSnapshot(e)).toList());
  }

  Future<TrainerClass> getClass(String id) {
    return classRef.doc(id).get().then((snapshot) {
      if (snapshot.exists) {
        return TrainerClass.fromSnapshot(snapshot);
      }

      //TODO: define exception
      throw ("Not EXIST!!");
    });
  }
}