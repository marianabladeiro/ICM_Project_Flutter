import 'dart:collection';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../main.dart';
import 'TimeSpentData.dart';

//Profile Page when Signed In
class  ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}
class _ProfileState extends State<ProfilePage> {

  //firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;

  //dic to save user information
  HashMap hashMap = new HashMap<String, String>();

  @override
  void initState() {
    super.initState();
    String user_uid;
    var values;
    _timeSpentInfo();

    //get firebase info
    if (user != null) {
      hashMap.clear();
      user_uid = user.uid.toString();
      FirebaseDatabase.instance.reference().child("users").child(user_uid).once().then((DataSnapshot ds){
        var keys = ds.value.keys;
        values = ds.value;

        //add to hashMap user's details
        hashMap.putIfAbsent('name', () => values["name"].toString());
        hashMap.putIfAbsent('degree', () => values["degree"].toString());
        hashMap.putIfAbsent('nmec', () => values["nmec"].toString());
        hashMap.putIfAbsent('email', () => values["email"].toString());
        if (mounted) {
          setState(() {});
        }
      });

    }

  }




  @override
  Widget build(BuildContext context) {
    String name, firstName, lastName, innitials;
    String degree, nmec, email;

    //put in a function
    if (hashMap.length != null || hashMap.length != 0) {
      name = hashMap['name'];
      if (name != null) {
        var names = name.split(' ');
        firstName = names[0];
        lastName = names[1];
        innitials = firstName[0] + lastName[0];
      }
      degree = hashMap['degree'];
      nmec = hashMap['nmec'];
      email = hashMap['email'];
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://img.freepik.com/vetores-gratis/aquarela-design-volta-para-o-fundo-da-escola_23-2148593945.jpg?size=626&ext=jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect( // make sure we apply clip it properly
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
            child: Container(
              //alignment: Alignment.topLeft,
              alignment: Alignment(-0.85, -0.7),
              color: Colors.grey.withOpacity(0.1),
              child: Expanded(
                child: Column(
                  children: <Widget>[

                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget> [
                        Expanded (
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundColor: Colors.blueGrey,
                                child: Text(
                                    '$innitials',
                                    style: TextStyle(
                                        fontSize:40.0
                                    )),
                              ),
                          ),
                        ),
                      ],
                    ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "$name",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                  ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
                          child: Center(
                            child: Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                          child: Center(
                            child: Text(
                              "Nmec: $nmec",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                          child: Center(
                            child: Text(
                              "Degree: $degree",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                          child: Center(
                            child: Text(
                              "Email: $email",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Center(
                            child: Text(
                              "Statistics - Time Spent with each Course",
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      height: 210,
                      width: 230,
                      child:Expanded(
                      child: new charts.PieChart(
                        _getSeriesData(),
                        animate: true,
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 50,
                            arcRendererDecorators: [new charts.ArcLabelDecorator()]
                        ),
                      ),
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: SizedBox(
                            height:50,
                            child: RaisedButton(
                              child: Text("Logout", style: TextStyle(fontSize: 23.0, color: Colors.white)),
                              color: Colors.grey,
                              onPressed: () async {
                                await _firebaseAuth.signOut();
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                )
              )
            ),
          ),
        ),
      ),
    );
  }

  List<TimeSpentData> data = [];

//get timespent info
  Future<Null> _timeSpentInfo() async {
    if (user != null) {
      //get timespent
      await FirebaseDatabase.instance.reference().child("users").child(user.uid)
          .child('timespent').once()
          .then((DataSnapshot ds) {
        Map<dynamic, dynamic> timeS = ds.value;
        timeS.forEach((key, value) {
          data.add(TimeSpentData(key, value));
        });
        setState(() { });
      });
    }
  }

  //timespent graph
  _getSeriesData() {
    List<charts.Series<TimeSpentData, String>> series = [
      charts.Series(
          id: "Time Spent",
          data: data,
          labelAccessorFn: (TimeSpentData row, _) => '${row.innitials}: ${row.timespent}',
          domainFn: (TimeSpentData grades, _) => grades.innitials,
          measureFn: (TimeSpentData grades, _) => grades.timespent
      )
    ];
    return series;
  }
}