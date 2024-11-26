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
                      child: GetBuilder<ContainerController>(
                        builder: (controller) => TableCalendar(
                          firstDay: DateTime.utc(2023, 1, 1),
                          lastDay: DateTime.utc(2025, 12, 31),
                          focusedDay: _focusedDay.value,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: const TextStyle(color: Colors.red),
                            holidayTextStyle: const TextStyle(color: Colors.red),
                            todayDecoration: BoxDecoration(
                              color: Colors.blue[200],
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue[600],
                              shape: BoxShape.circle,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              final count = controller.getMeetingCountForDate(date);
                              if (count > 0) {
                                return Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.purple[400],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '$count',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                            todayBuilder: (context, date, _) {
                              return Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronMargin: EdgeInsets.zero,
                            rightChevronMargin: EdgeInsets.zero,
                            headerPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay.value = focusedDay;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay.value = focusedDay;
                          },
                        ),
                      ),
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
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple[100]!,
                                Colors.purple[50]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Meeting Type with Overflow Protection
                                    Text(
                                      containerController.containerList[index].value1,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E3147),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Meeting Details with Overflow Protection
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Start Time
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: Colors.purple,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      'Start: ${containerController.containerList[index].value2}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[700],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              
                                              // End Time
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time_filled,
                                                    size: 16,
                                                    color: Colors.purple,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      'End: ${containerController.containerList[index].value3}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[700],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        // Date Display
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.purple[50],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.purple[200]!,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            containerController
                                                .containerList[index]
                                                .formattedDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.purple[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                          timePickerController.handleDelete(index);
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
