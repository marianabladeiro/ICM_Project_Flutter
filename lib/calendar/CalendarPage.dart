import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _calendarController = CalendarController();

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  //get day selected
  void _onDaySelected(DateTime day, List events, List holidays) {

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Calendar"),
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(147, 172, 243, 1),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff8ACA91), Color(0xffB0E0B5)],
                  begin: FractionalOffset(0.5, 1)
              )
          ),
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: new TableCalendar(
                    calendarController: _calendarController,
                    calendarStyle: CalendarStyle(
                      selectedColor: Color.fromRGBO(147, 172, 243, 1),
                      todayColor: Color.fromRGBO(147, 172, 203, 1),
                      markersColor: Colors.brown[700],
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: _onDaySelected,
                  ),

                ),

                SizedBox(height: 10.0,),
                Expanded(
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),

                        ),
                        child: Padding(
                            padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                            child: Column(
                                children: <Widget>[
                                  Expanded(
                                      child: Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        "Day",
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10.0,),
                                                    ]
                                                )
                                            ),

                                          ]
                                      )
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical: 28.0),
                                      child: RaisedButton(
                                          color: Color(0xffB0E0B5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(80.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                                "Add Event",
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
      ),
    );
  }
}