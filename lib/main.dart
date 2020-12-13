import 'dart:async';

import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Login.dart';
import 'CoursePage.dart';

void main() => runApp(MaterialApp(
  home: Login(),
));


class Home extends StatefulWidget {
  int tab;
  Home(int i) {
    this.tab = i;
  }

  State<StatefulWidget> createState() {
    return _HomeState(this.tab);
  }
}

class _HomeState extends State<Home> {
  int currentTabIndex = 0;
  int _tabIndex = 0;

  _HomeState(int tab) {
    this._tabIndex = tab;
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  List<Widget> tabs = [
    HomePage(),
    CoursePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _tabIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _tabIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Color.fromRGBO(147, 172, 243, 1),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text("Timer"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            title: Text("Notes"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text("Calendar"),
          )
        ],
      ),
    );
  }
}
