import 'package:flutter/material.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/container_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';
import 'package:meetingreminder/shared_widgets/meeting_setter_box.dart';
import 'package:meetingreminder/shared_widgets/confirm_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final Rx<DateTime> _focusedDay = Rx<DateTime>(DateTime.now());
  DateTime? _selectedDay;
  final BottomNavController controller = Get.find<BottomNavController>();
  final TimePickerController timePickerController = Get.find<TimePickerController>();
  final ContainerController containerController = Get.find<ContainerController>();

  TextEditingController controller1 = TextEditingController();
  List<String> imageItems = [
    'assets/images/icons/home-page.png',
    'assets/images/icons/clock(1).png',
  ];

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[50]!,
                  Colors.grey[50]!,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meeting Planner',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, MMMM d').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      // Month Picker
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Obx(() => DropdownButton<String>(
                          value: DateFormat.MMMM().format(_focusedDay.value),
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
                          underline: Container(),
                          items: _months.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              int monthIndex = _months.indexOf(newValue) + 1;
                              _focusedDay.value = DateTime(_focusedDay.value.year, monthIndex);
                            }
                          },
                        )),
                      ),
                    ],
                  ),
                ),
                
                // Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Obx(() => TableCalendar(
                        focusedDay: _focusedDay.value,
                        firstDay: DateTime(2000),
                        lastDay: DateTime(2100),
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay.value = focusedDay;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          weekendTextStyle: const TextStyle(color: Colors.red),
                          holidayTextStyle: const TextStyle(color: Colors.red),
                          todayDecoration: BoxDecoration(
                            color: Colors.blue[400],
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.orange[400],
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: const TextStyle(fontWeight: FontWeight.w500),
                          weekendDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red[100]!),
                          ),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronVisible: false,
                          rightChevronVisible: false,
                          headerPadding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.red[300],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Today's Meetings Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Meetings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.blue[700], size: 16),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM d').format(DateTime.now()),
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Today's Meetings List
                Expanded(
                  child: Obx(() {
                    final todayMeetings = containerController.getTodayMeetings();
                    if (todayMeetings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_available,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No meetings scheduled for today',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: todayMeetings.length,
                      itemBuilder: (context, index) {
                        final meeting = todayMeetings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Meeting Type
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.event_note,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            meeting.value1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Time
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.orange[200]!),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.access_time, color: Colors.orange[700]),
                                          const SizedBox(width: 8),
                                          Text(
                                            meeting.value2,
                                            style: TextStyle(
                                              color: Colors.orange[700],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Delete Button
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Material(
                                  color: Colors.transparent,
                                  child: PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'Delete') {
                                        bool confirm = await ConfirmDialog.show(context);
                                        if (confirm) {
                                          containerController.deleteContainerData(index);
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'Delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red[400], size: 20),
                                              const SizedBox(width: 8),
                                              Text('Delete',
                                                  style: TextStyle(color: Colors.red[400])),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(imageItems.length, (index) {
                    final isSelected = controller.selectedIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.changeIndex(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              imageItems[index],
                              width: 24,
                              height: 24,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              Text(
                                index == 0 ? 'Home' : 'Timeline',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          
          // Floating Action Button
          Positioned(
            bottom: 80,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Get.dialog(buildReminderBox(context));
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
