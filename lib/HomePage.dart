import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'CoursePage.dart';

/*
TODO
Profile pic
 */
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}
class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    final List<Widget> _children = [];
    /*
    TODO
    Remove titles,
     */
    final titles = ['ia', 'sio', 'icm', 'ies',
      'cbd'];

    //date
    var  months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    String dayYear = DateFormat("dd, yyyy").format(DateTime.now());
    String month = DateFormat("MM").format(DateTime.now());
    int o = int.parse(month) - 1;
    String m = months[o];

    return Scaffold(

      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(147, 172, 243, 1),
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
                    color: Color(0xffdfecec),
                    borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(30.0),
                      bottomRight: const Radius.circular(30.0),
                    )
                ),
                child: Container(
                //greetings
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment(-0.86, 0),
                        padding: const EdgeInsets.fromLTRB(0.1, 45, 0, 0),
                        child: Text(
                          "Hello, Guest", //add user first name
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),

                      //date
                      Container(
                          margin: EdgeInsets.only(top: 8.0, bottom: 10.0),
                          alignment: Alignment(-0.85, 0),
                          child: Text("$m $dayYear",
                              style: TextStyle(
                                  fontSize: 19.0))),

                    ],
                  ),
                ),
              ),
            ),

            //upcoming
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
              alignment: Alignment(-0.85, 0),
              width: 400,
              height: 150,
              color:Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color:Colors.white,
                  //TODO fix borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: ExactAssetImage(
                        'images/ua_pic.png'),
                    fit: BoxFit.cover,
                  ),
                ),


              //TODO activities according to calendar
                child: ClipRRect( // make sure we apply clip it properly
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      //alignment: Alignment.topLeft,
                      alignment: Alignment(-0.85, -0.7),
                      color: Colors.grey.withOpacity(0.1),
                      child: Text(
                        "Upcoming",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
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
              height: 300,
              width: 400,
              child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return Align( // wrap card with Align
                      child: SizedBox(
                        height: 100,
                        child: Card(
                          child: ListTile(
                            leading: Icon(Icons.school, size:60, color: Colors.lightGreen),
                            title: Text(titles[index]),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CoursePage()),
                              );
                            },
                          ),
                        ),
                      ),
                  );
                },
              ),
            ),

            //statistics - TODO add date
            Container(
              margin: EdgeInsets.only(top: 35.0, bottom: 10.0),
              //alignment: Alignment(-0.85, 0),
              width: 400,
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(
                      'images/statistics.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),


              child: ClipRRect( // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    //alignment: Alignment.topLeft,
                    alignment: Alignment(-0.85, -0.7),
                    color: Colors.grey.withOpacity(0.45),
                    child: Text(
                      "Statistics",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),


    );
  }
}

