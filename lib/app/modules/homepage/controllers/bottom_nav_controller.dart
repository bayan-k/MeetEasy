
import 'package:get/get.dart';
import 'package:meetingreminder/app/routes/app_pages.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0
      .obs; //observable index for // Observable index for the currently selected tab
  void changeIndex(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOMEPAGE);
        break;
      case 1:
        Get.toNamed(Routes.TIMELINE);
        break;

      //   Get.offAllNamed('/itView');
      //   break;
      default:
        Get.toNamed(Routes.HOMEPAGE);

        break;
    }
  }
}