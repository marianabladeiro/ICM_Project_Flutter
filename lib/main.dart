import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pomodoroua_flutter/timer/TimerPage.dart';
import 'HomePage.dart';
import 'calendar/CalendarPage.dart';
import 'notes/NotesPage.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{
  int _selectedPage = 0;
  final _pageOptions = [
    HomePage(),
    TimerPage(),
    CalendarPage(),
    NotesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromRGBO(147, 172, 243, 1),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon:Icon(Icons.home),
              title: Text('Home')
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.av_timer),
                title: Text('Timer')
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.calendar_today),
                title: Text('Calendar')
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.notes),
                title: Text('ToDo')
            ),
          ],
        ),
      ),
    );
  }
}



