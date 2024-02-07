import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'Calender.dart';
import 'Reminder.dart';

class CalenderAddEvent extends StatefulWidget {
  final List<String> eventList;
  final List<String> timeList;
  final List<String> dateList;
  final void Function(List<String>, List<String>, List<String>)
      onEventAdded; // 修改回調函數參數類型

  CalenderAddEvent(
      {required this.eventList,
      required this.onEventAdded,
      required this.timeList,
      required this.dateList});

  @override
  _CalenderAddEventState createState() => _CalenderAddEventState();
}

class _CalenderAddEventState extends State<CalenderAddEvent> {
  TextEditingController eventController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: eventController,
                style: TextStyle(
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  hintText: 'ADD Event',
                  hintStyle: TextStyle(color: Color(0xFFA9A9A9)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    iconSize: 28,
                    color: Color(0xFF828282),
                    onPressed: () {
                      String event = eventController.text;
                      String startTimeString = _startTime.format(context);
                      String endTimeString = _endTime.format(context);
                      String time = " $startTimeString - $endTimeString ";
                      String date =
                          "${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}";
                      if (event.isNotEmpty) {
                        setState(() {
                          widget.eventList.add(event); // 將事件添加到外部事件列表
                          widget.timeList.add(time);
                          widget.dateList.add(date);
                        });
                        widget.onEventAdded(
                            widget.eventList, widget.timeList, widget.dateList);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  filled: true,
                  fillColor: Color(0xFFF1F1F1),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {},
                      iconSize: 30,
                      color: Color(0xFF828282),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Date",
                        style:
                            TextStyle(color: Color(0xFF828282), fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              showDateRangePicker(
                                context: context,
                                initialDateRange: DateTimeRange(
                                  start: DateTime.now(),
                                  end: DateTime.now().add(Duration(days: 7)),
                                ),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2024, 12, 31),
                              ).then((dateRange) {
                                if (dateRange != null) {
                                  setState(() {
                                    selectedDateRange = dateRange;
                                  });
                                }
                              });
                            },
                            child: Container(
                              width: 93,
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  selectedDateRange != null
                                      ? " ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)}"
                                      : "",
                                  style: TextStyle(
                                    color: Color(0xFF828282),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: Text(
                            "-",
                            style: TextStyle(
                                color: Color(0xFF828282), fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDateRangePicker(
                              context: context,
                              initialDateRange: DateTimeRange(
                                start: DateTime.now(),
                                end: DateTime.now().add(Duration(days: 7)),
                              ),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2024, 12, 31),
                            ).then((dateRange) {
                              if (dateRange != null) {
                                setState(() {
                                  selectedDateRange = dateRange;
                                });
                              }
                            });
                          },
                          child: Container(
                            width: 93,
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                selectedDateRange != null
                                    ? " ${DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)}"
                                    : "",
                                style: TextStyle(
                                  color: Color(0xFF828282),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.access_alarms_sharp),
                      onPressed: () {},
                      iconSize: 30,
                      color: Color(0xFF828282),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Time",
                        style:
                            TextStyle(color: Color(0xFF828282), fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 19.0),
                          child: IconButton(
                            icon: const Icon(Icons.more_time),
                            onPressed: () {
                              showTimeRangePicker(
                                context: context,
                                start: _startTime,
                                end: _endTime,
                                onStartChange: (start) {
                                  setState(() {
                                    _startTime = start;
                                  });
                                },
                                onEndChange: (end) {
                                  setState(() {
                                    _endTime = end;
                                  });
                                },
                              );
                            },
                            iconSize: 30,
                            color: Color(0xFF828282),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: GestureDetector(
                            onTap: () {
                              showTimeRangePicker(
                                context: context,
                                start: _startTime,
                                end: _endTime,
                                onStartChange: (start) {
                                  setState(() {
                                    _startTime = start;
                                  });
                                },
                                onEndChange: (end) {
                                  setState(() {
                                    _endTime = end;
                                  });
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  " ${_startTime.format(context)}",
                                  style: TextStyle(
                                    color: Color(0xFF828282),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: Text(
                            "-",
                            style: TextStyle(
                                color: Color(0xFF828282), fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.0),
                          child: GestureDetector(
                            onTap: () {
                              showTimeRangePicker(
                                context: context,
                                start: _startTime,
                                end: _endTime,
                                onStartChange: (start) {
                                  setState(() {
                                    _startTime = start;
                                  });
                                },
                                onEndChange: (end) {
                                  setState(() {
                                    _endTime = end;
                                  });
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFD9D9D9),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  " ${_endTime.format(context)}",
                                  style: TextStyle(
                                    color: Color(0xFF828282),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0), // 調整左側間距
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_active_outlined),
                      onPressed: () {},
                      iconSize: 30,
                      color: Color(0xFF828282),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0), // 調整左側間距
                      child: Text(
                        "Reminder",
                        style:
                            TextStyle(color: Color(0xFF828282), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0), // 調整左側間距
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month_sharp),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarScreen()),
                        );
                      },
                      iconSize: 30,
                      color: Color(0xFF828282),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 105.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF0094FF),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('cancel'),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF0094FF),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('confirm'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
