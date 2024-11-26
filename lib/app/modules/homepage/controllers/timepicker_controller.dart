
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingreminder/app/services/notification_services.dart';


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
    if (remarks.isEmpty || time1.isEmpty || time2.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    meeting.add({
      'headline': remarks,
      'Meeting Time': '$time1-$time2',
      'details': time2
    });

    // Parse startTime (e.g., "12:30 AM" or "1:45 PM")
    final startTimeParts = time1.split(":");
    final hour = int.parse(startTimeParts[0]);
    final minute = int.parse(startTimeParts[1].split(" ")[0]); // Extract hour and minute
    
    // For 12-hour format to 24-hour conversion
    final isPM = time1.contains("PM");
    final adjustedHour = isPM && hour != 12
        ? hour + 12
        : (!isPM && hour == 12)
            ? 0
            : hour;

    // Now, pass these extracted hours and minutes to schedule the daily notification
    scheduleDailyNotification(
      remarks: remarks,
      hour: adjustedHour,    // Pass hour here
      minute: minute,        // Pass minute here
    );
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
  void deleteMeeting(int index) {
    meeting.removeAt(index);
  }
}