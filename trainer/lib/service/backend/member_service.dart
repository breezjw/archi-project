
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class MemberService {
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
        retMembers.add(Member(memberId: member["memberId"], name: member["name"]), );
      });

      logger.d(retMembers);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retMembers;
  }

  Future<List<Member>> getMemberListMock() async {

    List<Member> retMembers= [];

    retMembers.add(Member(memberId: "", name: "AAA"));
    retMembers.add(Member(memberId: "", name: "BBB"));
    retMembers.add(Member(memberId: "", name: "CCC"));

    return retMembers;
  }
}