import 'dart:collection';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoroua_flutter/profile/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'CoursePage.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}
class _HomePage extends State<HomePage> {

  //firebase
  User user = FirebaseAuth.instance.currentUser;
  String user_uid;
  String greetings = '...';
  List<String> dataList = []; //for users name TODO change approach
  List<Map<String, String>> courseInfo = []; //list that contains a map for each course
  int fullTimeSpent = 0;
  var timeSpent;
  int tsSP;

  HashMap courseDetails = new HashMap<String, String>(); //TODO remove

  List<String> courseName = []; //list with course name for list view

  //for events
  var todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  Map<String, String> nextEvents = Map();
  Map<dynamic,dynamic> allInfo = Map();

  @override
  void initState() {
    if (user != null) {
      user_uid = user.uid;
    }
    if (user_uid == null) {
      greetings = 'Guest';
    }
    super.initState();
    //get value from shared preferences
    getIntValuesSF();
    //firebase info
    _firebaseInfo();
    setState(() {});

  }
  @override
  void dispose() {
    super.dispose();
    user_uid;
  }

  @override
  Widget build(BuildContext context) {
    //date
    var  months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    String dayYear = DateFormat("dd, yyyy").format(DateTime.now());
    String month = DateFormat("MM").format(DateTime.now());
    int o = int.parse(month) - 1;
    String m = months[o];

    //user first name
    String lastName;
    String innitials;
    if (dataList.length != 0) {
      String name = dataList[0];
      var names = name.split(' ');
      greetings = names[0];
      lastName = names[1];
      innitials = greetings[0] + lastName[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xffC1E8BC),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffC1E8BC),
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(30.0),
                      bottomRight: const Radius.circular(30.0),
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 5.0, right: 20.0),
                //greetings
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
                                    padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
                                    child: Text(
                                      "Hello, $greetings",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 33,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                    ),
                                  Container(
                                      //alignment: Alignment(-0.86, 0),
                                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Text("$m $dayYear",
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: 19.0))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () {
                                        if (user != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProfilePage()
                                            ),
                                          );
                                        }
                                        else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()
                                            ),
                                          );
                                        }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                                        child: CircleAvatar(
                                          radius: 40.0,
                                          backgroundColor: Colors.blueGrey,
                                          child: user_uid == null ? Text(
                                              'GU',
                                              style: TextStyle(
                                                  fontSize:25.0
                                              ))
                                              :
                                          Text(
                                              '$innitials',
                                              style: TextStyle(
                                                  fontSize:25.0
                                              ))
                                        )
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
            //upcoming
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
              //alignment: Alignment(-0.85, 0),
              width: 400,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff9ADCE2),
              ),
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Container( margin: EdgeInsets.only(top: 20.0, left: 25.0),
                        child:Text(
                          "Upcoming",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),)),
                    Container(
                      height: 100,
                      width: 380,
                        margin: EdgeInsets.only(top: 5.0, left: 25.0),
                      child: nextEvents.length == 0 ? Padding(padding: const EdgeInsets.all(10.0), child: Text("No events coming up!", style: TextStyle(fontSize: 22),))
                          :
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: nextEvents.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = nextEvents.keys.elementAt(index);
                          return new Column(
                            children: <Widget>[
                              new ListTile(
                                title: new Text("Event: ${nextEvents[key]}" , style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),),
                                subtitle: new Text("$key", style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),),
                              ),
                              new Divider(
                                height: 1.0,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ]
                ),
              ),
            ),
            //subjects
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 225, 0),
              child: Text(
                "Your subjects",
                style: TextStyle(
                    fontSize: 25.0,
                    letterSpacing: 1.0,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, right: 5),
              height: 290,
              width: 400,
              child: courseName.length == 0 ? Padding(padding: const EdgeInsets.all(80.0), child: Text("No courses to show yet!", style: TextStyle(fontSize: 22),))
                  :
              ListView.builder(
                itemCount: courseName.length,
                itemBuilder: (context, index) {
                  return Align( // wrap card with Align
                    child: SizedBox(
                      height: 95,
                      child: Card(
                        color: Colors.white54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.school, size:55, color: Colors.blueGrey),
                            title: Text(courseName[index], style: TextStyle(fontSize: 21.0),),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CoursePage(courseName: courseName[index])),
                              );
                            },
                          ),
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
            //statistics
            Container(
              margin: EdgeInsets.only(top: 35.0, bottom: 10.0),
              //alignment: Alignment(-0.85, 0),
              width: 400,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xffDFCBEA),
              ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Container(
                        margin: EdgeInsets.only(top: 20.0, left: 25.0),
                        child: Text(
                          "Statistics",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 25.0),
                        child: timeSpent != null ? Text(
                          "You have used the timer for a total amount of ${_printDuration(timeSpent)}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        )
                            :
                            Text("Loading",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            )
                      ),
                    ]
                  )
            ),
          ],
        )
      ),
    );
  }

  Future<Null> _firebaseInfo() async {
    if (user != null) {
      //get timespent from firebase and sharedprefs
      await FirebaseDatabase.instance.reference().child("users").child(user.uid).child('timespent').once().then((DataSnapshot ds) {
        Map<dynamic,dynamic> timeS = ds.value; //map with all the info of that user
        timeS.forEach((key, value) {
          fullTimeSpent = fullTimeSpent + value;
        });
        if (tsSP != null) {
          fullTimeSpent = fullTimeSpent + tsSP;
        }
        timeSpent = fullTimeSpent.toString();
        if (fullTimeSpent != null) {
          timeSpent = Duration(seconds: int.parse(timeSpent));
        }

      });
      setState(() {});
      //get name and events
      await FirebaseDatabase.instance.reference().child("users").child(user.uid).once().then((DataSnapshot ds) {
        allInfo = ds.value;
        dataList.clear();
        dataList.add(allInfo['name']);
        Map<dynamic, dynamic> map1 = allInfo["events"];
           if (map1 != null) {
             map1.forEach((k, v) {
               Map<dynamic, dynamic> map2 = v;
               map2.forEach((key, value) {
                 if ((DateFormat("dd-MM-yyyy").parse(k)).isAfter(
                     (DateFormat("dd-MM-yyyy").parse(todayDate))) ||
                     todayDate.toString() == k) {
                   nextEvents.putIfAbsent(k, () => value['title']);
                 }
               });
             });
           }
          setState(() {});
      });

      //get courses that a user has
      await FirebaseDatabase.instance.reference().child("Courses").once().then((DataSnapshot ds) {
        Map<dynamic,dynamic> map = ds.value;
        map.forEach((key, value) {
          if (value['students'] != null) {
            value['students'].forEach((key1, value1) {
              if (value1.toString() == user.uid) {
                //lets add the courses names to a list in order to get it into the listview
                courseName.add(value['name']);
              }
            });
            setState(() {});
          }
        });
      });
    }
  }

  //seconds to hour:min:sec
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(1, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)} hours, $twoDigitMinutes minutes and $twoDigitSeconds seconds.";
  }

  //get value of timespent from sharedprefs
  getIntValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    tsSP = prefs.getInt(user.uid);
  }
}



