import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoroua_flutter/timer/Pomodoro.dart';


class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin{
  final TextEditingController study_time_controller = TextEditingController(text: "25");
  final TextEditingController break_time_controller = TextEditingController(text: "5");

  FlutterLocalNotificationsPlugin localNotification;

  AnimationController controller;

  //timer
  int button = 0;

  var workTime = Duration(minutes: 25);
  var shortBreakTime = Duration(minutes: 5);

  Stopwatch _sw;
  Timer _timer;
  Duration _timeLeft = Duration();
  Duration _newTimeLeft = Duration();
  Pomodoro _pomodoro;

  //firebase
  User user = FirebaseAuth.instance.currentUser;
  List<String> innitials = [];
  String selected;
  Map<String, String> nameInnitials = Map();

  @override
  void initState() {
    //firebase
    getInnitialsCourses();
    //timer
    _pomodoro = Pomodoro(targetTime: workTime, status: Status.work);
    _pomodoro.targetTime = workTime;
    _sw = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 50), _callback);

    super.initState();

    //notifications
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Timer"),
          elevation: 0,
          backgroundColor: Color(0xffDBC6E2),
        ),
      resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffCCA4D8), Color(0xffDBC6E2)],
              begin: FractionalOffset(0.5, 1)
            )
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Text(
                  "Pomodoro Method Timer",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  //percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 250.0,
                  lineWidth: 20.0,
                  backgroundColor: Colors.white24,
                  progressColor: Colors.white,
                  center: displayTimeString(),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Study Time",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    //SizedBox(height: 5.0,),
                                    TextFormField(
                                      controller: study_time_controller,
                                      style: TextStyle(
                                        fontSize: 50.0,
                                      ),
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding:
                                          EdgeInsets.only(left: 70, bottom: 14, top: 1, right: 15),
                                          //hintText: "25",
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ]
                                )
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Break Time",
                                       style: TextStyle(
                                         fontSize: 20.0,
                                       ),
                                    ),
                                    TextFormField(
                                      controller: break_time_controller,
                                      style: TextStyle(
                                        fontSize: 50.0,
                                      ),
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding:
                                        EdgeInsets.only(left: 85, bottom: 14, top: 1, right: 15),
                                        //hintText: "25",
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ]
                                ),
                              ),
                            ]
                          )
                        ),
                        Container(
                          height: 60,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: DropdownButton(
                            value: selected,
                            items: innitials
                                .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selected = value);
                            },
                            hint: Text('Context (optional)'),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: RaisedButton(
                              onPressed: () {
                                _buttonPressed();
                              },
                            color: Color(0xffCCA4D8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: button == 0 ? Text(
                                "Start Studying",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                )
                              )
                                  :
                              Text(
                                  "Stop Studying",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  )
                              ),
                            )
                          )
                        )
                      ]
                    )
                  )
                  )
                )
            ]
          ),
        ),
    );
  }

  //timer logic
  void _callback(Timer timer) {
    if (_sw.elapsed > _pomodoro.targetTime) {
      setState(() {
        print("hello");
        _changeNextStatus();
      });
      return;
    }

    _newTimeLeft = _pomodoro.targetTime - _sw.elapsed;
    if (_newTimeLeft.inSeconds != _timeLeft.inSeconds) {
      setState(() {
        _timeLeft = _newTimeLeft;
      });
    }
  }

  void _changeNextStatus() {
    _sw.stop();
    _sw.reset();
    button = 0;
    print("timer done");
    //do notification
    showNotification();
    //add to firebase
    setState(() {
      if (_pomodoro.status == Status.work) {
        if (selected != null) {
          addToFB();
        }
        else {
          addToSP();
        }
        //change to break time
        shortBreakTime = Duration(minutes: int.parse(break_time_controller.text));
        _pomodoro.setParam(time: shortBreakTime, status: Status.shortBreak);
        _continue();
      } else {
        //change to study time
        _pomodoro.setParam(time: workTime, status: Status.work);
        _buttonPressed();
      }
    });
  }

  void _resetButtonPressed() {
      setState(() {
        button = 0;
        _sw.stop();
        _sw.reset();
    });
  }

  void _buttonPressed() {
    workTime = Duration(minutes: int.parse(study_time_controller.text));
    _pomodoro = Pomodoro(targetTime: workTime, status: Status.work);
    _pomodoro.targetTime = workTime;
    setState(() {
      if (_sw.isRunning) {
        _resetButtonPressed();
      } else {
        button = 1;
        _sw.start();
      }
    });
  }

  void _continue() {
    button = 1;
    _sw.start();
  }

  Widget displayTimeString() {
    String minutes = (_timeLeft.inMinutes % 60).toString().padLeft(1, '0');
    String seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');
    return Text("$minutes:$seconds", style: TextStyle(fontSize: 75.0));
  }

  //notification when timer is over
  Future showNotification() async {
    var android = new AndroidNotificationDetails(
        'channelId', 'Local Notification', 'description',
        importance: Importance.high);
    var iosDetails = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iosDetails);
    await localNotification.show(
        0, 'PomodoroUA - Timer', 'Your timer is over', platform);
  }

  //get innitials from firebase to add context
  Future<List<String>> getInnitialsCourses() async {
    FirebaseDatabase.instance.reference().child("Courses").once().then((DataSnapshot ds) {
      Map<dynamic,dynamic> map = ds.value;
      map.forEach((key, value) {
        if (value['students'] != null) {
          value['students'].forEach((key1, value1) {
            if (value1.toString() == user.uid) {
              innitials.add(value['innitials']);
              nameInnitials.putIfAbsent(value['innitials'], () => value['name']);
            }
          });
        }
      });
      if (mounted) {
        setState(() { });
      }
    });
  }

  //add time to firebase
  Future addToFB() async {
    String name = nameInnitials[selected];
    int value = 0;
    await FirebaseDatabase.instance.reference().child("users").child(user.uid).child('timespent').child(name).once().then((DataSnapshot ds) {
        value = ds.value;
        print(value);

    });
    setState(() {});
    value = value + (int.parse(study_time_controller.text) * 60);
    FirebaseDatabase.instance.reference().child("users").child(user.uid).child("timespent").child(name).set(value);
  }

  //add timespent to shared prefs
  addToSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int tsSP = prefs.getInt(user.uid);
    if (tsSP != null) {
      prefs.setInt(user.uid, tsSP + (int.parse(study_time_controller.text) * 60));
    }
    else {
      prefs.setInt(user.uid, (int.parse(study_time_controller.text) * 60));
    }
  }
}





