import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_play_status.dart';
import 'package:trainer/service/firestore/member_play_status_service.dart';

class MemberAllController extends GetxController {
  final Logger _logger = Logger();

  final MemberPlayStatusService memberPlayStatusService;

  MemberAllController({required this.memberPlayStatusService});

  final RxList<Member> listMemberPlayStatus = RxList<Member>();
  final Rx<Member?> _memberPlayStatus = Rx<Member?>(null);
  // final RxBool _isLoadingTestGroup = RxBool(false);

  Member? get memberPlayStatus => _memberPlayStatus.value;

  //for bluetooth
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
  RxString rxstr_workout_mode = 'Stop'.obs;
  RxInt rxint_local_workout_mode = 0.obs;
  var is_connected = 0.obs;

  int _speed = 0;
  int _count = 0;
  int _strength = 0;
  int _workout_mode = 0;

  late Timer _timer;

  @override
  void onInit() {
    // getMemberPlayStatus();
    loadListMemberPlayStatus();
    super.onInit();

    subscription_device_state =
        _stream_device_state.receiveBroadcastStream().listen((selectedDevice) {
      rxstr_selected_device(selectedDevice);

      if (rxstr_selected_device.contains("Connected")) {
        is_connected++;
      }
    });

    ever(is_connected, (_) {
      print('$_이 변경되었습니다.');
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

    _timer.cancel();

    super.dispose();
  }

  int _spent_sec = 0;
  List<Map> _workout_strength = [];
  List<Map> _workout_speed = [];

  void startRecording(Member memberPlayStatus) {
    _count = memberPlayStatus.count;
    _speed = memberPlayStatus.speed;
    _strength = memberPlayStatus.strength;

    _workout_strength.clear();
    _workout_speed.clear();

    memberPlayStatusService.deleteRealtimeStrength(memberPlayStatus);
    memberPlayStatusService.deleteRealtimeSpeed(memberPlayStatus);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _workout_strength.add({'${_spent_sec}': _strength});
      _workout_speed.add({'${_spent_sec}': _speed});

      print('[${_spent_sec}], ${_workout_strength}, ${_workout_speed}');
      _spent_sec++;
      //memberPlayStatusService.updateRealtimeStrength(memberPlayStatus, _workout_strength);
    });
  }

  void stopRecording(Member memberPlayStatus) {
    _timer.cancel();
    print("timer.cancel()");

    print(
        'stopRecording [${_spent_sec}], ${_workout_strength}, ${_workout_speed}');
    memberPlayStatusService.updateRealtimeStrength(
        memberPlayStatus, _workout_strength);
    memberPlayStatusService.updateRealtimeSpeed(
        memberPlayStatus, _workout_speed);
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

  //////////////////////
  Future<void> loadListMemberPlayStatus() async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    listMemberPlayStatus.bindStream(
        memberPlayStatusService.listMemberPlayStatusStream("class1"));
  }

  Future<void> getMemberPlayStatus(String docId) async {
    // _isLoadingTestGroup.value = true;
    // testGroups.value = await testGroupService.listTestGroup("aaa");
    // _isLoadingTestGroup.value = false;
    // testGroups.bindStream(testGroupService.loadTestGroup("aaa"));
    _memberPlayStatus
        .bindStream(memberPlayStatusService.getMemberPlayStatusStream(docId));
  }

  // TrainerClass? getArticle(String id) {
  //   final testGroup = testGroups.firstWhereOrNull((element) =>
  //   element.docId == id,
  //   );
  //
  //   return testGroup;
  // }

  Future<void> updateMemberPlayStatus(Member memberPlayStatus) async {
    _logger.d("memberPlayStatus");
    memberPlayStatusService.updateMemberPlayStatus(memberPlayStatus);

    _speed = memberPlayStatus.speed;
    _count = memberPlayStatus.count;
    _strength = memberPlayStatus.strength;
  }
}
