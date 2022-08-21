
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/class_exercise.dart';

class ClassExerciseDataAgent {
  final logger = Logger();
  CollectionReference classPlayStatusRef = FirebaseFirestore.instance.collection(FireStoreClassPlayStatus.collection);

  ClassExercise _dataFromSnapshot(DocumentSnapshot snapshot,) {
    logger.d(snapshot.data());

    var classPlayStatus =  ClassExercise.fromJson(snapshot.data() as Map<String, dynamic>);
    classPlayStatus.classExerciseId = snapshot.id;

    return classPlayStatus;
  }

  Future<ClassExercise> getClassExerciseByClassId(String classId) {

    return classPlayStatusRef
        .where(FireStoreClassPlayStatus.trainerClassId, isEqualTo: classId)
        .get()
        .then((value) => value.docs.map((doc) {
          var classPlayStatus =  ClassExercise.fromSnapshot(doc);
          classPlayStatus.classExerciseId = doc.id;

          return classPlayStatus;
        }).toList()[0]);
  }

  Stream<ClassExercise> getClassExerciseStreamByClassId(String classId) {
    return classPlayStatusRef
      .where(FireStoreClassPlayStatus.trainerClassId, isEqualTo: classId)
      .snapshots()
      .map((query) => query.docs.map((doc) {
        logger.d(doc.id);
        var classPlayStatus =  ClassExercise.fromSnapshot(doc);
        classPlayStatus.classExerciseId = doc.id;

      return classPlayStatus;
    }).toList()[0]);
  }

  Future<String?> addClassExercise(String classId) async {
    String? docId;

    await classPlayStatusRef.add({
      FireStoreClassPlayStatus.trainerClassId: classId,
      FireStoreClassPlayStatus.status: "stop",
      FireStoreClassPlayStatus.startDate: DateTime.now(),
      FireStoreClassPlayStatus.endDate: DateTime.now(),
      FireStoreClassPlayStatus.playCount: 0
    })
    .then((value) {
      logger.d("ClassPlayStatus added: ${value.id}");
      docId = value.id;

    })
    .catchError((error) {
      logger.e("Failed to add ClassPlayStatus: $error");
    });

    if(docId != null) {
      return docId;
    }
    return null;
  }

  Future<void> updateClassExercise(String docId,
      {String? status, DateTime? startDate, DateTime? endDate, int? playCount}) async {

    Map<String, dynamic> updateData = {};

    if (status != null) updateData[FireStoreClassPlayStatus.status] = status;
    if (startDate != null) updateData[FireStoreClassPlayStatus.startDate] = startDate;
    if (endDate != null) updateData[FireStoreClassPlayStatus.endDate] = endDate;
    if (playCount != null) updateData[FireStoreClassPlayStatus.playCount] = playCount;

    classPlayStatusRef
      .doc(docId)
      .update(updateData)
      .then((_) => logger.d('Success'))
      .catchError((error) => logger.e('Failed: $error'));
  }
}