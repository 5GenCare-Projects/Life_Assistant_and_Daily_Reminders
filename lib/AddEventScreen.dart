import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'Calender.dart';
import 'Message.dart';
import 'Reminder.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController eventController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
  String selectedTime = '';
  @override
  void initState() {
    super.initState();
  }

  void saveEventToFirebase(String event, String time, String reminder) {
    final databaseReference = FirebaseDatabase.instance.reference();

    var newEventRef = databaseReference.child('events').push();

    newEventRef.set({
      'event': event,
      'time': time,
      'reminder': reminder,
    }).then((_) {
      print('Event and time saved successfully.');
    }).catchError((error) {
      print('Failed to save event and time: $error');
    });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selected != null) {
      setState(() {
        selectedTime = selected.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
// 初始值為一年的時間跨度

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
                      FocusScope.of(context).requestFocus(FocusNode());
                      String event = eventController.text;
                      String startTimeString = _startTime.format(context);
                      String endTimeString = _endTime.format(context);
                      String time = " $startTimeString - $endTimeString ";
                      String reminder = "reminder";
                      if (event.isNotEmpty) {
                        setState(() {
                          saveEventToFirebase(event, time, reminder);
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                  filled: true,
                  fillColor: Color(0xFFF1F1F1),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.access_alarms_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                      addEventtime(context);
                    },
                    iconSize: 30,
                    color: Color(0xFF828282),
                  ),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addEventtime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FractionallySizedBox(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                            String reminder = "reminder";
                            if (event.isNotEmpty) {
                              setState(() {
                                saveEventToFirebase(event, time, reminder);
                              });
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
                            icon: const Icon(Icons.access_alarms_sharp),
                            onPressed: () {},
                            iconSize: 30,
                            color: Color(0xFF828282),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Text(
                              "Time",
                              style: TextStyle(
                                  color: Color(0xFF828282), fontSize: 20),
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
                                    child: Center(
                                      child: FractionalTranslation(
                                        translation: const Offset(0, -4),
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
                            icon:
                                const Icon(Icons.notifications_active_outlined),
                            onPressed: () {},
                            iconSize: 30,
                            color: Color(0xFF828282),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0), // 調整左側間距
                            child: Text(
                              "Reminder",
                              style: TextStyle(
                                  color: Color(0xFF828282), fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: GestureDetector(
                              onTap: () {
                                _showTimePicker(context);
                              },
                              child: Container(
                                width: 85,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    selectedTime,
                                    style: TextStyle(
                                      color: Color(0xFF828282),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
