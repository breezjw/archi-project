import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';

class BluetoothController extends GetxController {
  final Logger _logger = Logger();

  static const MethodChannel _channel =
      const MethodChannel('com.archi.team.gems.user');
  static const _stream_device_state =
      const EventChannel('com.archi.team.gems.user/eventSelectedDevice');
  static const _stream_receive_msg =
      const EventChannel('com.archi.team.gems.user/eventReciveMsg');
  static const _stream_receive_strength =
      const EventChannel('com.archi.team.gems.user/eventReciveStrength');
  static const _stream_receive_speed =
      const EventChannel('com.archi.team.gems.user/eventReciveSpeed');
  static const _stream_receive_count =
      const EventChannel('com.archi.team.gems.user/eventReciveCount');
  static const _stream_receive_total_time =
      const EventChannel('com.archi.team.gems.user/eventReciveTotalTime');
  late StreamSubscription subscription_device_state;
  late StreamSubscription subscription_receive_msg;
  late StreamSubscription subscription_receive_strength;
  late StreamSubscription subscription_receive_speed;
  late StreamSubscription subscription_receive_count;
  late StreamSubscription subscription_receive_total_time;

  //final str_selected_device = Rx<String>('selected device');
  RxString rxstr_selected_device = 'Not connected GEMS device.'.obs;
  RxString rxstr_received_data = ''.obs;

  final MemberPlayStatusService memberPlayStatusService;

  BluetoothController({required this.memberPlayStatusService});

  // final RxList<MemberPlayStatus> listMemberPlayStatus = RxList<MemberPlayStatus>();
  final Rx<Member?> _memberPlayStatus = Rx<Member?>(null);
  // // final RxBool _isLoadingTestGroup = RxBool(false);
  //
  Member? get memberPlayStatus => _memberPlayStatus.value;

  @override
  void onInit() {
    super.onInit();

    subscription_device_state =
        _stream_device_state.receiveBroadcastStream().listen((selectedDevice) {
          rxstr_selected_device(selectedDevice);
    });

    subscription_receive_msg =
        _stream_receive_msg.receiveBroadcastStream().listen((receiveMsg) {
          rxstr_received_data(receiveMsg);
    });

    subscription_receive_strength = _stream_receive_strength
        .receiveBroadcastStream()
        .listen((receiveStrength) {
      memberPlayStatus!.strength = int.parse(receiveStrength);
    });

    subscription_receive_speed =
        _stream_receive_speed.receiveBroadcastStream().listen((receiveSpeed) {
      memberPlayStatus!.speed = int.parse(receiveSpeed);
    });

    subscription_receive_count =
        _stream_receive_count.receiveBroadcastStream().listen((receiveCount) {
      memberPlayStatus!.count = int.parse(receiveCount);
      //_str_count = "Count : $_count";
    });

    subscription_receive_total_time = _stream_receive_total_time
        .receiveBroadcastStream()
        .listen((receiveTotalTime) {
      // _total_time = int.parse(receive_total_time);
      // int hour, min, sec;
      // hour = (_total_time / 360).toInt();
      // min = (_total_time / 60).toInt();
      // sec = (_total_time % 60).toInt();
      // _str_total_time = "Total Time : $hour" + "h $min" + "m $sec" + "s";
    });
  }

  @override
  void dispose() {
    subscription_device_state.cancel();
    subscription_receive_msg.cancel();
    subscription_receive_strength.cancel();
    subscription_receive_speed.cancel();
    super.dispose();
  }

  // Future<void> getClassPlayStatus(String docId) async {
  //   // _isLoadingTestGroup.value = true;
  //   // testGroups.value = await testGroupService.listTestGroup("aaa");
  //   // _isLoadingTestGroup.value = false;
  //   // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
  //   str_selected_device.bindStream(Stream<String>('selected device'));
  //   //_classPlayStatus.bindStream(classPlayStatusService.getClassPlayStatusStream(docId));
  // }

  Future<bool?> showDevicePicker() async =>
      await _channel.invokeMethod("showDevicePicker");

  Future<bool?> setStrength(int strength) async =>
      await _channel.invokeMethod("setStrength", {"strength": strength});

  Future<bool?> setSpeed(int speed) async =>
      await _channel.invokeMethod("setSpeed", {"speed": speed});

  Future<bool?> setWorkoutMode(int mode) async =>
      await _channel.invokeMethod("setWorkoutMode", {"mode": mode});

  Future<void> updateMemberPlayStatus(Member memberPlayStatus) async {
    _logger.d("memberPlayStatus");
    memberPlayStatusService.updateMemberPlayStatus(memberPlayStatus);
  }
}
