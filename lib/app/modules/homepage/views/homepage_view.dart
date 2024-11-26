import 'package:flutter/material.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/container_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/timepicker_controller.dart';
import 'package:meetingreminder/shared_widgets/meet_container.dart';
import 'package:meetingreminder/shared_widgets/meeting_setter_box.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final Rx<DateTime> _focusedDay = Rx<DateTime>(
      DateTime.now()); // Declare _focusedDay as a reactive variable
  DateTime? _selectedDay;
  final BottomNavController controller = Get.find<BottomNavController>();
  final TimePickerController timePickerController =
      Get.find<TimePickerController>();


  final ContainerController containerController =
      Get.find<ContainerController>();

  TextEditingController controller1 = TextEditingController();
  List<String> imageItems = [
    'assets/images/icons/home-page.png',
    'assets/images/icons/clock(1).png',
  ];

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        buildMonthPicker(),
        buildCalendar(),
        buildText(),
        buildContainer(context),
        buildBottomBar(),
        floatingButton(buildReminderBox(context))
      ]),
    );
  }

  Widget buildMonthPicker() {
    return Obx(
      () => Positioned(
        top: 46,
        right: 40,
        child: Container(
          height: 60,
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(45),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Text(
              //   DateFormat.y().format(_focusedDay), // Displays the year
              //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              DropdownButton<String>(
                value: DateFormat.MMMM().format(_focusedDay.value),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                underline: Container(),
                onChanged: (String? newValue) {
                  // Use Rx's .value to update _focusedDay
                  if (newValue != null) {
                    int monthIndex = _months.indexOf(newValue) + 1;
                    _focusedDay.value =
                        DateTime(_focusedDay.value.year, monthIndex);
                  }
                },
                items: _months.map<DropdownMenuItem<String>>((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return Obx(
      () => Positioned(
        left: 30,
        top: 130,
        child: Container(
          height: 380,
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TableCalendar(
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
                  todayDecoration: BoxDecoration(),
                  selectedDecoration: BoxDecoration()),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool isToday = isSameDay(day, _focusedDay.value);
                  bool isSelected = isSameDay(day, _selectedDay);
                  return Container(
                      width: 40,
                      height: 50,
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: isToday
                            ? const Color.fromARGB(255, 227, 84, 172)
                            : isSelected
                                ? Colors.deepOrange
                                : const Color.fromARGB(255, 42, 113, 160),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 12,
                              width: 15,
                              decoration:
                                  BoxDecoration(color: Colors.amberAccent),
                              alignment: Alignment.center,
                              child: Text(
                                '2',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 30, 30, 30),
                                    fontSize: 10),
                              ),
                            ),
                          ),
                        ],

                        //
                      ));
                },
              ),
              headerStyle: const HeaderStyle(
                headerMargin: EdgeInsets.zero,
                formatButtonVisible: false,
                titleCentered: false,
                titleTextStyle: TextStyle(fontSize: 0),
                leftChevronVisible: false, // Disable default chevron buttons
                rightChevronVisible: false,
                // Disable default chevron buttons
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Positioned(
      bottom: 320,
      left: 30,
      child: Text(
        'Today Meetings',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildBottomBar() {
    return Positioned(
      left: 50,
      bottom: 20,
      child: Obx(
        () => Row(
          children: [
            Container(
              height: 80,
              width: 200,
              // width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    220, 245, 173, 0.6), //background: rgba(220, 245, 173, 0.6);

                borderRadius: BorderRadius.circular(70),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(imageItems.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changeIndex(index); // Update selected index
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      // padding: const EdgeInsets.all(5), // Space between the icons
                      decoration: BoxDecoration(
                          shape:
                              BoxShape.circle, // Circular shape for each icon
                          color: controller.selectedIndex.value == index
                              ? Colors.white // Highlight the selected icon
                              : const Color.fromRGBO(255, 255, 255,
                                  0.3) //background: rgba(255, 255, 255, 0.3);

                          // Non-selected icons remain transparent
                          ),
                      child: Center(
                        child: Image.asset(
                          imageItems[index],
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget floatingButton(Widget name) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          Get.dialog(buildReminderBox(context));
        },
        child: Container(
          height: 80,
          width: 80,
          // width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
                220, 245, 173, 0.6), //background: rgba(220, 245, 173, 0.6);

            borderRadius: BorderRadius.circular(70),
          ),

          child: const Center(
              child: Text(
            '+',
            style: TextStyle(fontSize: 28),
          )),
        ),
      ),
    );
  }
}
