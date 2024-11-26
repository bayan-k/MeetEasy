import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meetingreminder/shared_widgets/custom_snackbar.dart';
import 'package:meetingreminder/models/container.dart';

class ContainerController extends GetxController {
  var containerList = <ContainerData>[].obs;
  final String boxName = 'meetingBox';

  @override
  void onInit() {
    super.onInit();
    loadContainerData();
  }

  Future<void> storeContainerData(String time1, String remarks, String time2, DateTime date, String formattedDate) async {
    try {
      final box = await Hive.openBox<ContainerData>(boxName);
      final data = ContainerData(
        key1: 'headline',
        value1: remarks,
        key2: 'Meeting Time',
        value2: time1,
        key3: 'Details',
        value3: time2,
        date: date,
        formattedDate: formattedDate,
      );
      
      await box.add(data);
      await loadContainerData();
      CustomSnackbar.showSuccess('Meeting saved successfully');
    } catch (e) {
      CustomSnackbar.showError('Failed to save meeting: ${e.toString()}');
    }
  }

  Future<void> loadContainerData() async {
    try {
      final box = await Hive.openBox<ContainerData>(boxName);
      final loadedData = box.values.toList();
      
      // Sort meetings by date and time
      loadedData.sort((a, b) => a.date.compareTo(b.date));
      
      containerList.value = loadedData;
    } catch (e) {
      CustomSnackbar.showError('Failed to load meetings: ${e.toString()}');
    }
  }

  Future<void> deleteContainerData(int index) async {
    try {
      final box = await Hive.openBox<ContainerData>(boxName);
      await box.deleteAt(index);
      await loadContainerData();
      CustomSnackbar.showSuccess('Meeting deleted successfully');
    } catch (e) {
      CustomSnackbar.showError('Failed to delete meeting: ${e.toString()}');
    }
  }

  List<ContainerData> getTodayMeetings() {
    final now = DateTime.now();
    return containerList.where((meeting) {
      return meeting.date.year == now.year &&
             meeting.date.month == now.month &&
             meeting.date.day == now.day;
    }).toList();
  }
}
