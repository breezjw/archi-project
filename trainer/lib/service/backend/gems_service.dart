
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/gems.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class GemsService {
  final Logger logger = Logger();

  Future<List<Gems>> getGemsList() async {
    List<Gems> retGems= [];
    final url = Uri.parse(BACKEND_URL + LIST_MEMBER_API);

    var response = await http.get(url);
    if (response.statusCode == 200) {

      logger.d(response.body);

      // var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var gems = convert.jsonDecode(response.body) as List<dynamic>;
      gems.forEach((element) {
        var gems = element as Map<String, dynamic>;
        retGems.add(Gems(id: gems["memberId"], name: gems["name"]), );
      });

      logger.d(retGems);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retGems;
  }

  Future<List<Gems>> getGemsListMock() async {

    List<Gems> retGems= [];

    retGems.add(Gems(id: "1111", name: "GEMS #1"));
    retGems.add(Gems(id: "2222", name: "GEMS #2"));
    retGems.add(Gems(id: "3333", name: "GEMS #3"));

    return retGems;
  }
}