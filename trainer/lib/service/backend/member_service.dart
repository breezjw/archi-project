
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class MemberService {
  final Logger logger = Logger();

  Future<List<Member>> getMemberList() async {
    final url = Uri.parse(backendUrl + "todos/1");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;

      logger.d(jsonResponse);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return [];
  }
}