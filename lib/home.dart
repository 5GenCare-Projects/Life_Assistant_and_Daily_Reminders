import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AddEventScreen.dart';
import 'Calender.dart';
import 'Message.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime currentTime;
  late Timer timer;
  List<Map<dynamic, dynamic>> events = [];
  String closestEvent = '';
  String closestTime = '';

  void listenToEvents() {
    DatabaseReference eventRef =
        FirebaseDatabase.instance.reference().child('events');

    eventRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> map =
            Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        List<Map<dynamic, dynamic>> tempList = [];

        map.forEach((key, value) {
          tempList.add({
            'event': value['event'],
            'time': value['time'],
          });
          setState(() {
            events = tempList;
            closestEvent = value['event'];
            closestTime = value['time'];
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateTime.now();
      });
    });
    listenToEvents();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('dd MMMM').format(now);

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF2F2F2), Color(0xFF71CFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 16.0,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, 0.6),
                child: Image.asset(
                  'images/subtract.png',
                  width: 440,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(2.3, 5),
                child: Text(
                  "One Week",
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(-2, 5),
                child: Text(
                  "One Month",
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, -0.2),
                child: SizedBox(
                  width: 263,
                  height: 263,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF71CFFF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF71CFFF).withOpacity(0.5),
                              offset: const Offset(-6, 6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, -0.25),
                child: SizedBox(
                  width: 207,
                  height: 207,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: const Offset(10, 10),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, -3),
                child: Text(
                  formattedTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, -1.7),
                child: Text(
                  closestEvent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, -1),
                child: Text(
                  closestTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
            Stack(children: [
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Text(
                  "Today is $formattedDate",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ]),
            Stack(children: [
              Positioned(
                top: 75,
                left: 0,
                right: 0,
                child: Text(
                  "Daily Reminders",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ]),
            Center(
              child: FractionalTranslation(
                translation: const Offset(-5, 10),
                child: Text(
                  "Today:",
                  style: TextStyle(color: Color(0xFF676767), fontSize: 10),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(0, 1.8),
                child: Container(
                  width: 500,
                  height: 120,
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding:
                            EdgeInsets.only(bottom: 110, left: 20, right: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                width: 53,
                                height: 60,
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
                                          Container(
                                            width: 100,
                                            child: Text(
                                              events[index]['time'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  events[index]['event'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
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
                            childCount: events.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF8FD9FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 5,
              child: SizedBox(
                width: 58,
                height: 58,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF8FD9FF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        builder: (context) => StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return FractionallySizedBox(
                              child: AddEventScreen(),
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
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.assignment_outlined),
                    onPressed: () {},
                    iconSize: 28,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(10, 1.8),
                child: Text(
                  "0",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            Center(
              child: FractionalTranslation(
                translation: const Offset(-10, 1.8),
                child: Text(
                  "0",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              right: 16.0,
              child: IconButton(
                icon: Icon(Icons.edit_calendar),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
