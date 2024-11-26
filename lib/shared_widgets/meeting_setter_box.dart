import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';

final timePickerController = Get.find<TimePickerController>();

Widget buildReminderBox(BuildContext context) {
  return AlertDialog(
    title: const Text('Select Meeting Time'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildRemarksRow(),
        const SizedBox(height: 20),
        buildStartTimeInput(context),
        const SizedBox(height: 20),
        buildEndtimeInput(context),
        const SizedBox(height: 20),
        buildConfirmDeleteButton(),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget buildRemarksRow() {
  return Row(
    children: [
      Container(
          height: 20,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: Color.fromARGB(255, 218, 190, 117)),
          child: const Text(
            'Remarks',
            style: TextStyle(fontSize: 15),
          )),
      const SizedBox(
        width: 100,
      ),
      Container(
        width: 100,
        height: 50, // Set width of the container
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // Add padding inside the container
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black12, // Shadow color
              blurRadius: 8, // Blur effect
              offset: Offset(0, 4), // Shadow position
            ),
          ],
          border:
              Border.all(color: Colors.grey.shade300), // Border color and width
        ),
        child: TextField(
          controller: timePickerController.remarkController.value,
          decoration: InputDecoration(
            border: InputBorder.none, // Removes default TextField border
            hintText: 'Enter your text here',
            // Placeholder text
            hintStyle:
                TextStyle(color: Colors.grey.shade400), // Hint text styling
          ),
        ),
      ),
    ],
  );
}

Widget buildStartTimeInput(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {},
        child: Container(
            height: 20,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Color.fromARGB(255, 218, 190, 117)),
            child: const Text('Start Time:')),
      ),
      SizedBox(
        width: 100,
        child: Obx(() {
          return GestureDetector(
              onTap: () => timePickerController.meetingSetter(context, true),
              child: Container(
                  child: Text(timePickerController.startTime.value.isEmpty
                      ? 'select time'
                      : timePickerController.startTime.value)));
        }),
      ),
    ],
  );
}

Widget buildEndtimeInput(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {},
        child: Container(
            height: 20,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Color.fromARGB(255, 218, 190, 117)),
            child: const Text('End Time:')),
      ),
      SizedBox(
        width: 100,
        child: Obx(() {
          return GestureDetector(
              onTap: () => timePickerController.meetingSetter(context, false),
              child: Container(
                  child: Text(timePickerController.endTime.value.isEmpty
                      ? 'select time'
                      : timePickerController.endTime.value)));
        }),
      ),
    ],
  );
}

Widget buildConfirmDeleteButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ElevatedButton(
        onPressed: () {
          timePickerController.addMeeting(
              timePickerController.remarkController.value.text,
              timePickerController.startTime.value,
              timePickerController.endTime.value);
        },
        child: const Text('Confirm'),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Delete'),
      ),
    ],
  );
}
