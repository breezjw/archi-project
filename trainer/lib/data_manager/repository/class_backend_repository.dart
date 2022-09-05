
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class ClassBackendRepository {
  final Logger logger = Logger();

  Future<List<ClassInfo>> getClassList(String trainerId) async {
    List<ClassInfo> retClasses = [];
    final url = Uri.parse(BACKEND_URL + LIST_TRAINER_CLASS(trainerId));

    var response = await http.get(url);
    if (response.statusCode == 200) {
      logger.d(response.body);
      var classes = convert.jsonDecode(response.body) as List<dynamic>;
      classes.forEach((element) {
        var classInfo = element as Map<String, dynamic>;
        retClasses.add(ClassInfo(
          classId: classInfo[ApiClassInfo.classId].toString(),
          trainerId: classInfo[ApiClassInfo.trainerId].toString(),
          name: classInfo[ApiClassInfo.className] ?? ""),
        );
      });

      logger.d(retClasses);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retClasses;
  }

  Future<void> addClass ({
    required String name,
    required String trainerId
  }) async {
    final url = Uri.parse(BACKEND_URL + ADD_TRAINER_CLASS(trainerId));
    logger.d(url);
    final body = convert.jsonEncode({
      "class_name": name,
      // "trainerId": int.parse(trainerId)
    });

    http.Response response = await http.post(
      url,
      headers:  { 'Content-type': 'application/json'},
      body: body
    );

    if (response.statusCode == 200) {
      logger.d(response.body);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return;
  }

  Future<List<Member>> getClassMemberList(String trainerId, String classId) async {
    List<Member> retMembers = [];
    final url = Uri.parse(BACKEND_URL + LIST_TRAINER_CLASS_MEMBER(trainerId, classId));

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var members = convert.jsonDecode(response.body) as List<dynamic>;
      members.forEach((element) {
        var member = element as Map<String, dynamic>;
        retMembers.add(Member(
          memberId: member[ApiMember.memberId].toString(),
          name: member[ApiMember.name],
          email: member[ApiMember.email],
          age: member[ApiMember.age],
          nickName: member[ApiMember.nickName],
          gender: member[ApiMember.gender]),
        );
      });
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retMembers;
  }

  Future<void> addClassMember ({
    required String trainerId,
    required String classId,
    required List<int> memberIds
  }) async {
    final url = Uri.parse(BACKEND_URL + ADD_TRAINER_CLASS_MEMBER(trainerId, classId));
    logger.d(url);
    final body = convert.jsonEncode(memberIds);

    http.Response response = await http.post(
        url,
        headers:  { 'Content-type': 'application/json'},
        body: body
    );

    if (response.statusCode == 200) {
      logger.d(response.body);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return;
  }

  Future<void> deleteClassMember ({
    required String trainerId,
    required String classId,s
  }) async {
    final url = Uri.parse(BACKEND_URL + DELETE_TRAINER_CLASS(trainerId, classId));

    http.Response response = await http.delete(url);

    if (response.statusCode == 200) {
      logger.d(response.body);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return;
  }
}