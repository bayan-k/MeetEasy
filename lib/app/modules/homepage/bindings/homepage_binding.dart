import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';
import 'package:meetingreminder/app/services/notification_services.dart';


class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    // Binding controllers and services to the Get instance

    Get.lazyPut<TimePickerController>(() => TimePickerController());
    Get.lazyPut<NotificationService>(() => NotificationService());
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    
  }
}
