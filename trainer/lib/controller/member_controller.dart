
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class MemberController extends GetxController {
  final Logger logger = Logger();

  final RxList<Member> listTrainerClass = RxList<Member>();

  @override
  void onInit() {
    getMemberList();
    super.onInit();
  }

  void getMemberList() async {
    final url = Uri.parse(backendUrl + "todos/1");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      
      logger.d(jsonResponse);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }
  }
}