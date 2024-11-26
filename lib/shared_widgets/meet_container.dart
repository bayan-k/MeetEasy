import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/container_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';

Widget buildContainer(BuildContext context) {
  final TimePickerController timePickerController =
      Get.put(TimePickerController());
  final ContainerController containerController = Get.put(ContainerController());

  return Positioned(
    bottom: 70,
    left: 30,
    child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width - 60,
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: containerController.containerList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final meeting = containerController.containerList[index];
                return Container(
                    height: 240,
                    width: 200,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(children: [
                      Positioned(
                        right: -20,
                        top: 0,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'Delete') {
                              // Perform delete action
                              timePickerController.deleteMeeting(index);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Text('Delete'),
                              ),
                            ];
                          },
                          icon: const Icon(Icons.more_vert), // Three dots icon
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Meeting Type : '${meeting.value1} ",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Meeting Time : ${meeting.value2}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 39, 36, 36)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Details : ${meeting.value3}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 26, 25, 25)),
                            ),
                          ],
                        ),
                      ),
                    ]));
              },
            ),
          );
        })),
  );
}
