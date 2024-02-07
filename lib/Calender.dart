import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'CalenderAddEvent.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  CalendarFormat format = CalendarFormat.month;
  double monthScale = 0.9;
  double weekScale = 0.7;
  List<String> events = [];
  List<String> eventList = [];
  List<String> timeList = [];
  List<String> dateList = [];

  void selectedDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;

      events.add(selectedDay.toString());
    });
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      today = focusedDay;
    });
  }

  void previousMonth() {
    setState(() {
      today = DateTime(today.year, today.month - 1, today.day);
    });
  }

  void nextMonth() {
    setState(() {
      today = DateTime(today.year, today.month + 1, today.day);
    });
  }

  void switchToMonthView() {
    setState(() {
      format = CalendarFormat.month;
    });
  }

  void switchToWeekView() {
    setState(() {
      format = CalendarFormat.week;
    });
  }

  void TelescopicView() {
    setState(() {
      format = format == CalendarFormat.month
          ? CalendarFormat.week
          : CalendarFormat.month;
    });
  }

  void addEvent(String event, time, date) {
    setState(() {
      eventList.add(event);
      timeList.add(time);
      dateList.add(date);
    });
  }

  Widget content() {
    return Column(
      children: [
        Container(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF60A9FF).withOpacity(0.5),
                  offset: const Offset(7, 7),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Color(0xFF4BC9FF).withOpacity(0.15),
                  offset: Offset(-10, -10),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.only(top: 15.0),
              width: 340,
              height: format == CalendarFormat.month
                  ? 330 * monthScale
                  : 180 * weekScale,
              child: Transform.scale(
                scale: 0.9,
                child: TableCalendar(
                  onPageChanged: onPageChanged,
                  locale: 'en_US',
                  rowHeight: 43,
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  focusedDay: today,
                  firstDay: DateTime.utc(2001, 1, 1),
                  lastDay: DateTime.utc(2099, 12, 31),
                  onDaySelected: selectedDay,
                  calendarFormat: format,
                  onFormatChanged: (newFormat) {
                    setState(() {
                      format = newFormat;
                    });
                  },
                  headerVisible: false,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: Stack(
            // 將 Positioned 移到 Stack 中
            children: [
              Positioned(
                left: 20,
                right: 20,
                child: Container(
                  width: 300,
                  height: 200,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            String event = eventList[index];
                            String time = timeList[index];
                            return Container(
                              width: 53,
                              height: 53,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Color(0xFF71CFFF).withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 60.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          event, // 顯示時間
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  time,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFF5B5B5B),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    bottom: 3,
                                    child: IconButton(
                                      icon: const Icon(
                                          Icons.check_circle_outline),
                                      onPressed: () {},
                                      iconSize: 28,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: eventList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: previousMonth,
                  iconSize: 38,
                  color: Color(0xFF979797),
                ),
                Text(
                  '${DateFormat.yMMM().format(today)}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: nextMonth,
                  iconSize: 38,
                  color: Color(0xFF979797),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 65, // Set the desired width
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF58B9FF),
                                      Color(0xFF58B9FF)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                textStyle: const TextStyle(fontSize: 10),
                              ),
                              onPressed: TelescopicView,
                              child: Text(format == CalendarFormat.month
                                  ? 'Month'
                                  : 'Week'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 38,
                  color: Color(0xFF00A3FF),
                  icon: Icon(Icons.home),
                )
              ],
            ),
          ),
          Expanded(child: content()),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF8FD9FF),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        // Add button functionality here
                      },
                      iconSize: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF8FD9FF),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                          ),
                          builder: (context) => StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return FractionallySizedBox(
                                child: CalenderAddEvent(
                                  eventList: eventList,
                                  timeList: timeList,
                                  dateList: dateList,
                                  onEventAdded: (event, time, date) {},
                                ),
                              );
                            },
                          ),
                        );
                      },
                      iconSize: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
