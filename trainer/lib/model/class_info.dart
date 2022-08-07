
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassInfo {
  final String classId;
  final String trainerId;
  final String name;

  ClassInfo({
    required this.classId,
    required this.trainerId,
    required this.name,
  });
}

class ApiClassInfo {
  static const String classId= "classId";
  static const String trainerId = "trainerId";
  static const String className = "className";
}