
import 'dart:convert' as convert;
import 'package:logger/logger.dart';
import 'package:trainer/model/gems.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class GemsBackendRepository {
  final Logger logger = Logger();

  Future<List<Gems>> getGemsList(String trainerId) async {
    List<Gems> retGems= [];
    final url = Uri.parse(BACKEND_URL + LIST_TRAINER_GEMS(trainerId));

    var response = await http.get(url);
    if (response.statusCode == 200) {

      logger.d(response.body);

      // var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var gems = convert.jsonDecode(response.body) as List<dynamic>;
      gems.forEach((element) {
        var gems = element as Map<String, dynamic>;
        retGems.add(Gems(
            gemsId: gems["gemsId"].toString(),
            name: "GEMS #${gems["gemsId"]}",
            isAssigned: gems["assignStatus"] !="N"), );
      });

      logger.d(retGems);
    } else {
      logger.e('Request failed with status: ${response.statusCode}.');
    }

    return retGems;
  }

  Future<void> assignGems ({
    required String trainerId,
    required String memberId,
    required String gemsId,
  }) async {
    final url = Uri.parse(BACKEND_URL + ASSIGN_TRAINER_GEMS(trainerId));
    logger.d(url);
    final body = convert.jsonEncode({
      "member_id": memberId,
      "gems_id": gemsId
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

  Future<void> unassignGems ({
    required String trainerId,
    required String gemsId,
  }) async {
    final url = Uri.parse(BACKEND_URL + UNASSIGN_TRAINER_GEMS(trainerId));
    logger.d(url);
    final body = convert.jsonEncode({
      "gems_id": gemsId
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

  Future<List<Gems>> getGemsListMock() async {

    List<Gems> retGems= [];

    retGems.add(Gems(gemsId: "1111", name: "GEMS #1", isAssigned: false));
    retGems.add(Gems(gemsId: "2222", name: "GEMS #2", isAssigned: false));
    retGems.add(Gems(gemsId: "3333", name: "GEMS #3", isAssigned: false));

    return retGems;
  }
}