import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

//do not save it here
const kGoogleApiKey = "AIzaSyAV_-H_czn19ZhokNcdGC0MJ6iqxaKkasI";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class NewEventPage extends StatefulWidget {

  String dayCalendar;
  NewEventPage({this.dayCalendar});

  @override
  State<StatefulWidget> createState() {
    return _NewEventPage(dayCalendar);
  }
}


class _NewEventPage extends State<NewEventPage> {
  String dayCalendar;
  _NewEventPage(this.dayCalendar);

  FocusNode myFocusNode = new FocusNode();
  final _controllerLocation = TextEditingController();
  final _controllerTitle = TextEditingController();
  final _controllerContext = TextEditingController();

  //validation
  bool _validate = false;

  //map to keep event info and send it to calendar page
  HashMap eventDetails = new HashMap<String, String>();

  //firebase
  User user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();
  List<String> innitials = [];

  String selected;

  @override
  void initState() {
    super.initState();
    _getInnitialsCourses();
  }


  @override
  void dispose() {
    _controllerLocation.dispose();
    _controllerTitle.dispose();
    _controllerContext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xffB5E9BA),

        ),
      body: SingleChildScrollView(
        child: Column(
        children: [
        Container(
          width: double.infinity,
          height: 140,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffB5E9BA),
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(30.0),
                bottomRight: const Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                //alignment: Alignment(-0.86, 0),
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Text(
                                    "Add Event",
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                                  child: Text(
                                    dayCalendar,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
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
              width: 400.0,
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
              child: TextField(
                controller: _controllerTitle,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(147, 172, 243, 1),
                          width: 2.5,
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(147, 172, 243, 1),
                      width: 2.5,
                    ),
                  ),
                  labelText: 'Title',
                  errorText: _validate ? 'This value can\'t be empty' : null,
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  ),
                ),
              )
          ),
          Container(
              width: 400.0,
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: TextFormField(
                controller: _controllerLocation,
                decoration: InputDecoration(
                    labelText: 'Location (optional)',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(147, 172, 243, 1),
                          width: 2.5,
                        )
                    ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide()
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(147, 172, 243, 1),
                      width: 2.5,
                    ),
                  ),
                ),
                onTap: () async {
                  Prediction p = await PlacesAutocomplete.show(
                      context: context, apiKey: kGoogleApiKey);
                  displayPrediction(p);
                  }
                ),
              ),
          Container(
            width: 400.0,
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: DropdownButtonFormField(
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
              decoration: InputDecoration(
                labelText: 'Context (optional)',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(147, 172, 243, 1),
                      width: 2.5,
                    )
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide()
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(147, 172, 243, 1),
                    width: 2.5,
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: SizedBox(
                  height:50,
                  child: RaisedButton(
                    child: Text("Add", style: TextStyle(fontSize: 23.0, color: Colors.white)),
                    color: Color(0xffB5E9BA),
                    onPressed: () {
                      setState(() {
                        if (_controllerTitle.text.isEmpty) {
                          _validate = true;
                        }
                        else {
                          _validate = false;
                          databaseReference.child("users").child(user.uid).child("events").child(dayCalendar).child(_controllerTitle.text).set({
                            'title': _controllerTitle.text,
                            'location': _controllerLocation.text.isEmpty ? null : _controllerLocation.text,
                            'context' : selected == null ? null : selected
                          });
                          Navigator.pop(context);
                          setState(() {});
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
    ),
    );
  }

  //get innitials of the courses a user has
  Future<List<String>> _getInnitialsCourses() async {
    FirebaseDatabase.instance.reference().child("Courses").once().then((DataSnapshot ds) {

      Map<dynamic,dynamic> map = ds.value; //map that contains full course data from firebase
      map.forEach((key, value) {
        if (value['students'] != null) {
          value['students'].forEach((key1, value1) {
            if (value1.toString() == user.uid) {
              //lets add the courses names to a list in order to get it into the listview
              innitials.add(value['innitials']);
            }
          });
        }
        setState(() {});
      });
    });
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
      print(address);
    }
  }
}