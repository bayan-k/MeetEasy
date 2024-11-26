import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/container_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/meeting_counter.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // First, initialize controllers that don't have dependencies
    Get.put(MeetingCounter(), permanent: true);
    Get.put(BottomNavController(), permanent: true);

    // Initialize TimePickerController

    Get.put(TimePickerController(), permanent: true);

    // Then initialize controllers that depend on others
    Get.put(ContainerController(), permanent: true);
  }
}
