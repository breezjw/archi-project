
import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String memberId;
  final String name;
  final String email;
  final int age;
  final String nickName;
  final String gender;

  Member({
    required this.memberId,
    required this.name,
    this.email = "",
    this.age = 0,
    this.nickName = "",
    this.gender = "",
  });
}

class ApiMember {
  static const String memberId = "memberId";
  static const String name = "name";
  static const String email = "email";
  static const String age = "age";
  static const String nickName = "nickName";
  static const String gender= "gender";
}