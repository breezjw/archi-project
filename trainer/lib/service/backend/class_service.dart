
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class ClassService {
  final Logger logger = Logger();

  Future<List<ClassInfo>> getClassList(String trainerId) async {
    List<ClassInfo> retClasses = [];
    final url = Uri.parse(BACKEND_URL + LIST_TRAINER_CLASS_LIST(trainerId));

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

  Future<Member?> getMember(String id) async {
    Member? retMember;
    final url = Uri.parse(BACKEND_URL + GET_MEMBER_API + "/" + id);

    var response = await http.get(url);
    if (response.statusCode == 200) {

      logger.d(response.body);

      var member = convert.jsonDecode(response.body) as Map<String, dynamic>;
      retMember = Member(memberId: member["memberId"], name: member["name"]);

      logger.d(retMember);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retMember;
  }

  Future<List<Member>> getMemberListMock() async {

    List<Member> retMembers= [];

    retMembers.add(Member(memberId: "aaa", name: "AAA"));
    retMembers.add(Member(memberId: "bbb", name: "BBB"));
    retMembers.add(Member(memberId: "ccc", name: "CCC"));

    return retMembers;
  }
}