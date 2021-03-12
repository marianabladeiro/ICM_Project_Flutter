import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../Login.dart';
import 'NewEventPage.dart';


class CalendarPage extends StatefulWidget {

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _calendarController = CalendarController();
  String dayCalendar = DateFormat("dd-MM-yyyy").format(DateTime.now());

  Map<String, List> _events = new Map();
  List<dynamic> _selectedEvents = List();
  DateTime day;
  //firebase
  User user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();
    _selectedEvents = [];
    _readFromFirebase();

  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  //get day selected
  void _onDaySelected(DateTime day, List events, List holidays) {
    _selectedEvents = [];
    dayCalendar = DateFormat("dd-MM-yyyy").format(day);
    if (_events[dayCalendar] != null) {
      _selectedEvents = _events[dayCalendar];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Calendar"),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffB5E9BA),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff9EF0A6), Color(0xffB5E9BA)],
                  begin: FractionalOffset(1, 1)
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
                      selectedColor: Colors.blueGrey,
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
                            padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                            child: Column(
                                children: <Widget>[
                                  Expanded(
                                      child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        "Events",
                                                        style: TextStyle(
                                                          fontSize: 26.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromRGBO(147, 173, 203, 1),
                                                        ),
                                                      ),
                                                      //SizedBox(height: 10.0,),
                                                      Row (
                                                        children: <Widget> [
                                                          Container(
                                                            height: 110,
                                                            width: 380,
                                                            child: _selectedEvents.length == 0 ? Padding(padding: const EdgeInsets.fromLTRB(90, 20, 0, 0), child: Text("No events to show yet!", style: TextStyle(fontSize: 21),))
                                                                :
                                                            ListView.builder(
                                                              itemCount: _selectedEvents.length,
                                                              itemBuilder: (context, index) {
                                                                return Align( // wrap card with Align
                                                                  child: SizedBox(
                                                                    height: 75,
                                                                    child: Card(
                                                                      color: Colors.white70,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(15),
                                                                      ),
                                                                      child: ListTile(
                                                                        title: Text(_selectedEvents[index], style: TextStyle(fontSize: 20.0),),
                                                                        onTap: () {
                                                                          moreInfoEvent(_selectedEvents[index].toString());

                                                                        },
                                                                        trailing: new Column(
                                                                          children: <Widget>[
                                                                            new IconButton(
                                                                                icon: new Icon(Icons.delete),
                                                                                onPressed: () {
                                                                                  _showDialog(_selectedEvents[index].trim(), dayCalendar.toString().trim());
                                                                                }),

                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        ]
                                                      )
                                                    ]
                                                )
                                            ),
                                          ]
                                      )
                                  ),

                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(340, 0, 0, 10),
                                          child: IconButton (
                                              icon: new Icon(Icons.add, size:45, color: Colors.blueGrey),
                                              onPressed: () {
                                                if (user != null) {
                                                  _navigateAndDisplaySelection(context);
                                                }
                                                else {
                                                  dialogAddNote();
                                                }
                                              }
                                          ),
                                        )
                                      ),
                                    ],
                                  ),
                                ]
                            )
                        )
                    )
                ),
              ]
          ),
        ),
      ),
    );
  }

  //wait for a response from NewEventPage
  _navigateAndDisplaySelection(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEventPage(dayCalendar: dayCalendar)));
    _readFromFirebase();

  }

  //read notes from firebase
  Future<Map<String, List>> _readFromFirebase() async{
    _events.clear();
    if (user != null) {
      await FirebaseDatabase.instance.reference().child("users").child(user.uid)
          .child("events").once()
          .then((DataSnapshot ds) {
        Map<dynamic,dynamic> map = ds.value;
        if (map != null) {
          map.forEach((key, value) {
            Map<dynamic, dynamic> map2 = value;
            map2.forEach((k, v) {
              if (_events[key] != null) {
                _events[key].add(v['title']);
              }
              else {
                _events[key] = [v['title']];
              }
            });
          });
        }
        _onDaySelected(DateFormat("dd-MM-yyyy").parse(dayCalendar), [], []);
        setState(() { });
      });
    }
  }


  //dialog to make sure user wants to delete note
  void  _showDialog (String title, String day){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete event"),
          content: new Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Delete", style: TextStyle(fontSize: 18),),
              onPressed: () async {
                databaseReference.child("users").child(user.uid).child("events").child(day).child(title).remove();
                _selectedEvents.remove(title);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Cancel", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //warns user that they need to log in to continue operation
  void dialogAddNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add new event"),
          content: new Text("You need to be logged in to add an event!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Log In", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login()
                  ),
                );
              },
            ),
            new FlatButton(
              child: new Text("Back to Calendar", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //when we click on a certain event we can see more information about it
  moreInfoEvent(String event) async {
    String location, contextCourse;
    await FirebaseDatabase.instance.reference().child("users").child(user.uid)
        .child("events").child(dayCalendar).child(event).once()
        .then((DataSnapshot ds) {
        Map<dynamic,dynamic> map = ds.value;
        location = map['location'];
        contextCourse = map['context'];

    });
    //dialog to show event info
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(event, style: TextStyle(fontSize: 24),),
          content: new Text("Location: $location \nContext: $contextCourse", style: TextStyle(fontSize: 20), ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}