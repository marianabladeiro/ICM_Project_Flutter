import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  double percent = 0;
  static int TimeInMinut = 25;
  int TimeInSec = TimeInMinut * 60;

  Timer timer;

  final study_time_controller = TextEditingController(text: "25");

  _StartTimer(){
    //print(study_time_Controller.text);
    String study_time_t = study_time_controller.text;
    log('study_time: study_time_t');
    TimeInMinut = 25;
    int Time = TimeInMinut * 60;
    double SecPercent = (Time/100);
    timer = Timer.periodic(Duration(seconds:1), (timer) {
      setState((){
        if (Time > 0) {
          Time --;
          if (Time % 60 == 0) {
            TimeInMinut --;
          } if(Time % SecPercent == 0) {
            if (percent < 1) {
              percent += 0.01;
            } else {
              percent = 1;
            }
          }
        } else {
          percent = 0;
          TimeInMinut = 25;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Timer"),
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(147, 172, 243, 1),
        ),
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
                      fontSize: 25.0
                  ),
                ),
              ),

              Expanded(
                child: CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: percent,
                  animation: true,
                  animateFromLastPercent: true,
                  radius: 250.0,
                  lineWidth: 20.0,
                  backgroundColor: Colors.white24,
                  progressColor: Colors.white,
                  center: Text(
                    "$TimeInMinut",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80.0
                    ),
                  ),
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
                                      "Study Time",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
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
                                    SizedBox(height: 10.0),
                                    TextFormField(
                                      initialValue: "5",
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 28.0),
                          child: RaisedButton(
                            onPressed: _StartTimer,
                            color: Color(0xffCCA4D8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Start Studying",
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