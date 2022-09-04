import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/model/member_exercise.dart';
import 'package:trainer/ui/common/util.dart';
import 'package:trainer/ui/memeber_play_status/member_play_status_view.dart';

class MemberPlayStatusListItem extends StatelessWidget {
  final MemberClassExercise memberPlayStatus;

  const MemberPlayStatusListItem({
    Key? key,
    required this.memberPlayStatus
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger();

    // orderMap(memberPlayStatus.strength);
    // _logger.d(memberPlayStatus.name);
    // _logger.d("${memberPlayStatus.strength.length}, ${memberPlayStatus.strength.keys.last}, ${memberPlayStatus.strength.values.last}");
    // _logger.d("${memberPlayStatus.strength[(memberPlayStatus.strength.length-1)]}");

    var lastCount = memberPlayStatus.count[(memberPlayStatus.count.length-1)];
    var lastSpeed = memberPlayStatus.speed[(memberPlayStatus.speed.length-1)];
    var lastStrength = memberPlayStatus.strength[(memberPlayStatus.strength.length-1)];

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          //TODO: Group Detail
          _logger.d("HERE");
          Get.toNamed(MemberPlayStatusView.routeName, arguments: memberPlayStatus.memberClassExerciseId);
          // Get.to(() => NextPage(), arguments: value);
        },
        child: Container(
          decoration: BoxDecoration(
            //TODO: Group Status
            color: workoutStatusColor[memberPlayStatus.exerciseStatus],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    "${memberPlayStatus.name}: ${memberPlayStatus.exerciseStatus.toUpperCase()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "count: ${
                            memberPlayStatus.count.isEmpty ? 0: lastCount
                        }",
                        style: const TextStyle(
                            fontSize: 17
                        ),
                      ),
                      Text(
                        "speed: ${
                            memberPlayStatus.speed.isEmpty ? 0: lastSpeed
                        }",
                        style: const TextStyle(
                            fontSize: 17
                        ),
                      ),
                      Text(
                        "strength: ${
                            memberPlayStatus.strength.isEmpty ? 0: lastStrength
                        }",
                        style: const TextStyle(
                            fontSize: 17
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void orderMap(Map<int, int> map) {
    return map.entries.toList().sort((a, b) => a.key.compareTo(b.key));
  }

}