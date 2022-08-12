import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:trainer/controller/class_controller.dart';
import 'package:trainer/controller/class_play_status_controller.dart';
import 'package:trainer/model/class_info.dart';
import 'package:trainer/model/class_play_status.dart';
import 'package:trainer/model/trainer_class.dart';
import 'package:trainer/view/class_detail/class_detail_view.dart';


class ClassListItem extends StatefulWidget {
  static const routeName = '/class_list';

  final ClassInfo classInfo;

  const ClassListItem({
    Key? key,
    required this.classInfo,
  }) : super(key: key);

  @override
  _ClassListItemState createState() => _ClassListItemState();
}

class _ClassListItemState extends State<ClassListItem> {

  ClassController classController = Get.find<ClassController>();

  late var _tapPosition;


  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger();
    ClassPlayStatusController classPlayStatusController = Get.find<ClassPlayStatusController>();

    _logger.d(widget.classInfo.name);

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          //TODO: Group Detail
          Get.toNamed(ClassDetailView.routeName, arguments: widget.classInfo.classId);
          // Get.to(() => NextPage(), arguments: value);
        },
        onTapDown: _storePosition,
        onLongPress: () {
          setState(() {
            _showContextMenu(context);
          });
        },
        child: Container(
          decoration: BoxDecoration(
            //TODO: Group Status
            // color: done ? Colors.grey : Colors.green[100],
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Text(
                    "${widget.classInfo.name} (ID: ${widget.classInfo.classId})",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  FutureBuilder(
                    future: classPlayStatusController.getClassPlayStatusByClassId(widget.classInfo.classId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return CircularProgressIndicator();
                      }
                      else if (snapshot.hasError) {
                        return const Text(
                          "Exercise Number: -",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        );
                      }
                      else {
                        final ClassPlayStatus classPlayStatus = snapshot.data;
                        return Text(
                            "Exercise Number: ${classPlayStatus.playCount} ",
                            style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          )
                        );
                      }
                    }
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),

        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete Class'),
          ),
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case 'delete':
        classController.deleteClassMember(widget.classInfo.trainerId, widget.classInfo.classId);
        classController.getClassList();
        break;
    }
  }
}