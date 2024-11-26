import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/meeting_counter.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';

import '../controllers/timeline_controller.dart';

class TimelineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimelineController>(
      () => TimelineController(),
    );

    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<MeetingCounter>(() => MeetingCounter());
    Get.lazyPut<TimePickerController>(() => TimePickerController());
  }
}
