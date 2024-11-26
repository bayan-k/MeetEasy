import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meetingreminder/shared_widgets/custom_snackbar.dart';
import 'package:meetingreminder/models/container.dart';

class ContainerController extends GetxController {
  var containerList = <ContainerData>[].obs;
  final String boxName = 'ContainerData';
  late Box<ContainerData> _box;

  @override
  void onInit() {
    super.onInit();
    _initBox();
  }

  Future<void> _initBox() async {
    try {
      _box = Hive.box<ContainerData>(boxName);
      await loadContainerData();
    } catch (e) {
      print('Error initializing box: $e');
      CustomSnackbar.showError('Error initializing data storage');
    }
  }

  int getMeetingCountForDate(DateTime date) {
    return containerList.where((meeting) {
      return meeting.date.year == date.year &&
             meeting.date.month == date.month &&
             meeting.date.day == date.day;
    }).length;
  }

  Map<DateTime, int> getMeetingCountMap() {
    final countMap = <DateTime, int>{};
    for (var meeting in containerList) {
      final date = DateTime(
        meeting.date.year,
        meeting.date.month,
        meeting.date.day,
      );
      countMap[date] = (countMap[date] ?? 0) + 1;
    }
    return countMap;
  }

  Future<void> storeContainerData(
    String key1,
    String value1,
    String key2,
    String value2,
    String key3,
    String value3,
    DateTime date,
    String formattedDate,
  ) async {
    try {
      final data = ContainerData(
        key1: key1,
        value1: value1,
        key2: key2,
        value2: value2,
        key3: key3,
        value3: value3,
        date: date,
        formattedDate: formattedDate,
      );
      
      await _box.add(data);
      await loadContainerData();
      update(); // Force UI update
      CustomSnackbar.showSuccess('Meeting saved successfully');
    } catch (e) {
      print('Error storing data: $e');
      CustomSnackbar.showError('Failed to save meeting: ${e.toString()}');
    }
  }

  Future<void> loadContainerData() async {
    try {
      final loadedData = _box.values.toList();
      
      // Sort meetings by date and time
      loadedData.sort((a, b) => a.date.compareTo(b.date));
      
      containerList.assignAll(loadedData); // Use assignAll instead of value
      update(); // Force UI update
    } catch (e) {
      print('Error loading data: $e');
      CustomSnackbar.showError('Failed to load meetings');
    }
  }

  Future<void> deleteContainerData(int index) async {
    try {
      await _box.deleteAt(index);
      await loadContainerData();
      update(); // Force UI update
      CustomSnackbar.showSuccess('Meeting deleted successfully');
    } catch (e) {
      print('Error deleting data: $e');
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

  @override
  void onClose() {
    _box.close();
    super.onClose();
  }
}
