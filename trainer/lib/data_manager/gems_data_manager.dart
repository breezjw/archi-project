
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/gems.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/data_manager/repository/gems_backend_repository.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class GemsDataManager extends GetxController {
  final Logger logger = Logger();

  final GemsBackendRepository gemsService;
  GemsDataManager({required this.gemsService});

  final RxList<Gems> listGems = RxList<Gems>();

  @override
  void onInit() {
    getGemsList("6");
    super.onInit();
  }

  Future<void> getGemsList(String trainerId) async {
    return gemsService.getGemsList(trainerId).then((value) {
      listGems.value = value;
    });
  }

  Future<void> assignGems(String trainerId, String memberId, String gemsId) async {
    return gemsService.assignGems(trainerId: trainerId, memberId: memberId, gemsId: gemsId);
  }

  Future<void> unassignGems(String trainerId, String gemsId) async {
    return gemsService.unassignGems(trainerId: trainerId, gemsId: gemsId);
  }

}