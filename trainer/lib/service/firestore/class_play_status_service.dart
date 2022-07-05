
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/class_play_status.dart';

class ClassPlayStatusService {
  final logger = Logger();
  CollectionReference classPlayStatusRef = FirebaseFirestore.instance.collection(FireStoreClassPlayStatus.collection);

  Future<ClassPlayStatus> getClassPlayStatus(String id) {
    // TODO: change id
    return classPlayStatusRef.doc(id).get().then((snapshot) {
      logger.d(snapshot);

      if (snapshot.exists) {
        return ClassPlayStatus.fromSnapshot(snapshot);
      }

      //TODO: define exception
      throw ("Not EXIST!!");
    });
  }

  ClassPlayStatus _dataFromSnapshot(DocumentSnapshot snapshot,) {
    logger.d(snapshot.data());

    var classPlayStatus =  ClassPlayStatus.fromJson(snapshot.data() as Map<String, dynamic>);
    classPlayStatus.docId = snapshot.id;

    return classPlayStatus;
  }

  Stream<ClassPlayStatus> getClassPlayStatusStream(String docId) {
    return classPlayStatusRef
        .doc(docId)
        .snapshots()
        .map(_dataFromSnapshot);
  }

  Future<String?> addClassPlayStatus(String classId) async {
    String? docId;

    await classPlayStatusRef.add({
      FireStoreClassPlayStatus.trainerClassId: classId,
      FireStoreClassPlayStatus.status: "play",
      FireStoreClassPlayStatus.startDate: DateTime.now(),
      FireStoreClassPlayStatus.endDate: DateTime.now(),
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

  Future<void> updateClassPlayStatus(String docId, {String? status, DateTime? endDate}) async {
    classPlayStatusRef
      .doc(docId)
      .update({
        FireStoreClassPlayStatus.status: status,
        FireStoreClassPlayStatus.endDate: endDate
      })
      .then((_) => logger.d('Success'))
      .catchError((error) => logger.e('Failed: $error'));
  }
}