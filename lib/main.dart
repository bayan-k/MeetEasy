import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetingreminder/app/core/initial_binding.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/container_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/meeting_counter.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';
import 'package:meetingreminder/app/routes/app_pages.dart';
import 'package:meetingreminder/models/container.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInitSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await Hive.initFlutter();
  // Register the ContainerData adapter
  if (!Hive.isAdapterRegistered(1)) {
    // 1 is the typeId from your ContainerData class
    Hive.registerAdapter(ContainerDataAdapter());
  }

  // Open Hive boxes
  await Hive.openBox('ContainerData');
  await Hive.openBox('settings');

  // Initialize controllers
  Get.put(MeetingCounter(), permanent: true);
  Get.put(BottomNavController(), permanent: true);
  Get.put(TimePickerController(), permanent: true);

  Get.put(ContainerController(), permanent: true);

  runApp(
    GetMaterialApp(
      // home: const MyHomePage(title: 'Meeting Schedul initialBinding: InitialBinding(),er'),
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL, // Ensure it points to '/homepage'
      getPages: AppPages.routes,
    ),
  );
}
