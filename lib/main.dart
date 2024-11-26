import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetingreminder/app/core/initial_binding.dart';
import 'package:meetingreminder/app/routes/app_pages.dart';
import 'package:meetingreminder/models/container.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initHive() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ContainerDataAdapter());
  }
  await Hive.openBox<ContainerData>('ContainerData');
  await Hive.openBox('settings');
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Hive first
    await initHive();
    
    // Initialize other services
    await AndroidAlarmManager.initialize();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meeting Reminder',
        initialBinding: InitialBinding(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  } catch (e) {
    print('Error during initialization: $e');
    rethrow;
  }
}
