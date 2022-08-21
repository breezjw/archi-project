
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class MemberBackendRepository {
  final Logger logger = Logger();

  Future<List<Member>> getMemberList() async {
    List<Member> retMembers= [];
    final url = Uri.parse(BACKEND_URL + LIST_MEMBER_API);

    var response = await http.get(url);
    if (response.statusCode == 200) {

      logger.d(response.body);

      // var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
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

      logger.d(retMembers);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retMembers;
  }

  Future<Member?> getMember(String id) async {
    Member? retMember;
    final url = Uri.parse(BACKEND_URL + GET_MEMBER_API + "/" + id);

    var response = await http.get(url);
    if (response.statusCode == 200) {

      logger.d(response.body);

      var member = convert.jsonDecode(response.body) as Map<String, dynamic>;
      retMember = Member(
          memberId: member[ApiMember.memberId].toString(),
          name: member[ApiMember.name],
          email: member[ApiMember.email],
          age: member[ApiMember.age],
          nickName: member[ApiMember.nickName],
          gender: member[ApiMember.gender]);

      logger.d(retMember);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retMember;
  }
}