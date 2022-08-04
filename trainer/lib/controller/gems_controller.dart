
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/gems.dart';
import 'package:trainer/model/member.dart';
import 'package:trainer/service/backend/gems_service.dart';
import 'package:trainer/setting/config.dart';
import 'package:http/http.dart' as http;

class GemsController extends GetxController {
  final Logger logger = Logger();

  final GemsService gemsService;
  GemsController({required this.gemsService});

  final RxList<Gems> listGems = RxList<Gems>();

  @override
  void onInit() {
    getMemberList();
    super.onInit();
  }

   void getMemberList() async {
    gemsService.getGemsListMock().then((value) {
      listGems.value = value;
    });

  }
}