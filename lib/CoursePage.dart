import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoursePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CoursePage();
  }
}
class _CoursePage extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Color.fromRGBO(147, 172, 243, 1),
        ),
        body: Text(
          "course page",
        ),
    );
  }
}