import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/meeting_counter.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';
import 'package:meetingreminder/models/container.dart';

class ContainerController extends GetxController {
  late Box containerBox;
  RxList<ContainerData> containerList = <ContainerData>[].obs;
  final contoller = Get.find<TimePickerController>();
  final controller = Get.find<MeetingCounter>();

  @override
  void onInit() async {
    super.onInit();
    try {
      containerBox = Hive.box('ContainerData');  // Changed from openBox to box since we open it in main
      await loadContainerData();
    } catch (e) {
      print('Error initializing Hive box: $e');
    }
  }

  void saveContainerData() async {
    try {
      // Save all items in containerList to Hive
      for (var i = 0; i < containerList.length; i++) {
        await containerBox.put(i, containerList[i]);
      }
      await loadContainerData();  // Refresh the list after saving
    } catch (e) {
      print('Error saving container data: $e');
    }
  }

  void storeContainerData(String time1, String remarks, String time2) async {
    try {
      final newData = ContainerData(
          key1: 'headline',
          value1: remarks,
          key2: 'Meeting Time',
          value2: '$time1-$time2',
          key3: 'Details',
          value3: time2);
      
      // Add to the list first
      containerList.add(newData);
      
      // Then save to Hive using the current size as the key
      await containerBox.put(containerList.length - 1, newData);
      
      // Update the counter
      controller.counter.value = containerList.length;
      await Hive.box('settings').put('counter', controller.counter.value);
      
    } catch (e) {
      print('Error storing container data: $e');
    }
  }

  Future<void> loadContainerData() async {
    try {
      final keys = containerBox.keys;
      containerList.clear();

      for (var key in keys) {
        final data = containerBox.get(key) as ContainerData;

        containerList.add(data);

        print('${data.key1} : ${data.value1}');
        print('${data.key2} : ${data.value2}');
        print('${data.key3} : ${data.value3}');
      }
    } catch (e) {
      print('Error loading container data: $e');
    }
  }

  void deleteContainerData() {}
}
