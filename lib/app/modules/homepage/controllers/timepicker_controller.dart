import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/container_controller.dart';
import 'package:meetingreminder/app/services/notification_services.dart';
import 'package:meetingreminder/shared_widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

void alarmCallback() {
  print("Alarm Triggered!");

  // Optional: Show a notification here if you want to alert the user.
}

class TimePickerController extends GetxController {
  // Observables for start and end time
  TimeOfDay selectedTime = TimeOfDay.now();
  
  Future<void> meetingSetter(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final String formattedTime = formatToAmPm(pickedTime);

      if (isStartTime) {
        startTime.value = formattedTime;
        DateTime now = DateTime.now();
        DateTime alarmTime = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // If the time is in the past, schedule for the next day
        if (alarmTime.isBefore(now)) {
          alarmTime = alarmTime.add(const Duration(days: 1));
        }

        // Set the alarm
        await AndroidAlarmManager.oneShotAt(
          alarmTime, // Time to trigger
          0, // Unique alarm ID
          alarmCallback,
          exact: true,
          wakeup: true,
        );

        // Set up a notification for 30 seconds before the meeting
        final notificationTime = alarmTime.subtract(Duration(seconds: 30));
        _notificationService.scheduleNotification(
          id: meetingID,
          title: remarks.value,
          body: 'Your meeting starts in 30 seconds.',
          scheduledDate: notificationTime,
        );
      } else {
        endTime.value = formattedTime;
      }
    }
  }

  String formatToAmPm(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final String formattedHour = (hour % 12 == 0 ? 12 : hour % 12).toString();
    final String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute $period';
  }

  var startTime = ''.obs;
  var endTime = ''.obs;
  var remarks = ''.obs;
  int meetingID = 0;
  final NotificationService _notificationService = NotificationService();

  var meeting = <Map<String, String>>[].obs;
  var remarkController = TextEditingController().obs;
  var selectedDate = DateTime.now().obs;
  var formattedDate = ''.obs;

  Future<void> dateSetter(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.purple[400]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      formattedDate.value = DateFormat('MMM d, y').format(picked);
      update();
    }
  }

  // Clear the time values
  void clearTimes() {
    startTime.value = '';
    endTime.value = '';
    remarks.value = '';

    Get.back();
  }

  // Confirm the time selection
  void confirmTimes() {
    Get.back(); // Close the dialog
  }

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  // New method - initialize notifications
  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
  }

  // Function to add a meeting and schedule daily notifications
  void addMeeting(String remarks, String time1, String time2) {
    if (remarks.isEmpty || time1.isEmpty || time2.isEmpty || formattedDate.value.isEmpty) {
      CustomSnackbar.showError("Please fill all fields including date");
      return;
    }

    meeting.add({
      'headline': remarks,
      'meetingTime': '$time1-$time2',
      'details': time2,
      'date': selectedDate.value.toString(),
      'formattedDate': formattedDate.value
    });

    final containerController = Get.find<ContainerController>();
    containerController.storeContainerData(
      time1, 
      remarks, 
      time2,
      selectedDate.value,
      formattedDate.value
    );

    final startTimeParts = time1.split(":");
    final hour = int.parse(startTimeParts[0]);
    final minute = int.parse(startTimeParts[1].split(" ")[0]);
    
    final isPM = time1.contains("PM");
    final adjustedHour = isPM && hour != 12
        ? hour + 12
        : (!isPM && hour == 12)
            ? 0
            : hour;

    scheduleDailyNotification(
      remarks: remarks,
      hour: adjustedHour,
      minute: minute,
    );

    remarkController.value.clear();
    startTime.value = '';
    endTime.value = '';
    formattedDate.value = DateFormat('MMM d, y').format(DateTime.now());
    selectedDate.value = DateTime.now();
    
    CustomSnackbar.showSuccess("Meeting scheduled successfully");
    Get.back();
  }

  // Function for scheduling a one-time notification
  Future<void> scheduleNotification({required String title, required String body, required DateTime scheduledDate}) async {
    await _notificationService.scheduleNotification(
      id: meetingID,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );
  }

  // Function for scheduling daily notifications
  Future<void> scheduleDailyNotification({required String remarks, required int hour, required int minute}) async {
    await _notificationService.scheduleDailyNotification(
      id: meetingID,
      title: remarks,
      body: remarks,
      hour: hour,
      minute: minute,
    );
  }

  // Function to delete a meeting
  void deleteMeeting(int index) async {
    final containerController = Get.find<ContainerController>();
    await containerController.deleteContainerData(index);
    
    // Clear the current meeting data
    startTime.value = '';
    endTime.value = '';
    remarks.value = '';
    remarkController.value.clear();
  }
}