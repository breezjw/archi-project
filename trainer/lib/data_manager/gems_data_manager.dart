
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
    getGemsList();
    super.onInit();
  }

   void getGemsList() async {
    gemsService.getGemsListMock().then((value) {
      listGems.value = value;
    });

  }
}C