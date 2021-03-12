import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class CoursePage extends StatefulWidget {
  String courseName;
  CoursePage({this.courseName});

  @override
  State<StatefulWidget> createState() {
    return _CoursePage(courseName);
  }
}

class _CoursePage extends State<CoursePage> {
  String year, semester, responsible, exam, innitials, url;
  String timespent;

  //firebase
  User user = FirebaseAuth.instance.currentUser;
  HashMap courseDetails = new HashMap<String, String>();
  var now;
  Map<dynamic,dynamic> eventsInfo = Map();
  List<String> eventsTitle = List();
  String courseName;
  _CoursePage(this.courseName);

  @override
  void initState() {
    super.initState();
    _courseDetails();
    _getEvents();

    setState(() {});

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color(0xff9ADCE2),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff9ADCE2),
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(30.0),
                      bottomRight: const Radius.circular(30.0),
                    ),
                ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 20.0),
                    child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              //alignment: Alignment(-0.86, 0),
                                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                            child: Text(
                                              "$courseName",
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ),
                                          Container(
                                              padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                                              child: Text(
                                                "Year: $year",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                          ),
                                          Container(
                                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                              child: Text(
                                                "Semester: $semester",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                          ),
                                          Container(
                                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                              child: Text(
                                                "Responsible: $responsible",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                          ),
                                          Container(
                                              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                              child: Text(
                                                "Exam: $exam",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                          ),
                                        ],
                                    ),
                                  ),
                                  ],
                            ),
                          ),
                        ],
                    ),
                  ),
              ),
              ),
              Container(
                margin: EdgeInsets.only(top: 35.0, bottom: 10.0),
                //alignment: Alignment(-0.85, 0),
                width: 400,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffDFCBEA),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(15, 25, 130, 0),
                                    child: Text(
                                      "Events",
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    height: 90,
                                    child: eventsTitle.length == 0 ? Padding(padding: const EdgeInsets.all(15.0), child: Text("No events to show.", style: TextStyle(fontSize: 22),))
                                        :
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: eventsTitle.length,
                                      itemBuilder: (context, index) {
                                        return Align( // wrap card with Align
                                          child: SizedBox(
                                            height: 25,
                                              child: ListTile(
                                                title: Text(eventsTitle[index], style: TextStyle(fontSize: 20.0),),

                                              ),
                                            ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
                //alignment: Alignment(-0.85, 0),
                width: 400,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffC1E8BC),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 25, 150, 0),
                              child: Text(
                                "Total time spent",
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ]
                      ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(105, 0, 0, 0),
                                      child: now != null ? Text(
                                        "${_printDuration(now)}",
                                        style: TextStyle(
                                          fontSize: 40,
                                        ),
                                      )
                                          :
                                          Text("Loading"),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(child: Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                width: 400,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff9ADCE2),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "More information",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                onTap: () {
                  _launchURL();
                },
              ),
            ],
    ),
    ),
    );
  }

  //get course information
  Future<Null> _courseDetails() async {
    courseDetails.clear();
    await FirebaseDatabase.instance.reference().child("Courses").once().then((DataSnapshot ds) {
      //since there is no way to iterate through a datasnapshot in flutter we have to
      //do it through a map

      Map<dynamic,dynamic> map = ds.value; //map that contains full course data from firebase
      map.forEach((key, value) {
        if (value['name'] == courseName) {
          //add course details to Map courseDetails
          courseDetails.putIfAbsent('year', () => value["year"].toString());
          courseDetails.putIfAbsent('semester', () => value["semester"].toString());
          courseDetails.putIfAbsent('responsible', () => value["responsible"].toString());
          courseDetails.putIfAbsent('exam', () => value["exam"].toString());
          courseDetails.putIfAbsent('innitials', () => value["innitials"].toString());
          courseDetails.putIfAbsent('url', () => value["url"].toString());
        }
        setState(() { });

      });
    });
    if (courseDetails.length != null || courseDetails.length != 0) {
      year = courseDetails['year'];
      semester = courseDetails['semester'];
      responsible = courseDetails['responsible'];
      exam = courseDetails['exam'];
      innitials = courseDetails['innitials'];
      timespent = courseDetails['timespent'];
      url = courseDetails['url'];
    }

    await FirebaseDatabase.instance.reference().child("users").child(user.uid).child("timespent").child(courseName).once().then((DataSnapshot ds) {
      //since there is no way to iterate through a datasnapshot in flutter we have to
      //do it through a map
      String ts = ds.value.toString();
      courseDetails.putIfAbsent('timespent', () => ts);
      if (ts != null) {
        now = Duration(seconds: int.parse(ts));
      }
      setState(() {});
    });
  }

  //get events from user that have the context of the course
  _getEvents() async {
    await FirebaseDatabase.instance.reference().child("users").child(user.uid).child("events").once().then((DataSnapshot ds){
      eventsTitle.clear();
      eventsInfo = ds.value;
      eventsInfo.forEach((key, value) {
          Map<dynamic,dynamic> map2 = value;
          map2.forEach((k, v) {
            if (v['context'] != null && v['context'] == innitials) {
              eventsTitle.add(v['title']);
            }
          });
        setState(() {});

      });
      setState(() {});

    });
  }

  //seconds to hour:min:sec
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  //launch the url
  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}