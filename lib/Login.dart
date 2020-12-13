import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoroua_flutter/timer/TimerPage.dart';
import 'main.dart';
import 'HomePage.dart';
import 'notes/NotesPage.dart';
import 'calendar/CalendarPage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController =
  new TextEditingController(text: "ua@ua.pt");
  final TextEditingController passwordController =
  new TextEditingController(text: "ua");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(

        child: ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection(),
          ],
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    const String email_fixed = 'ua@ua.pt';
    const String pass_fixed = 'ua';
    if (email == email_fixed && pass_fixed == pass) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      await new Future.delayed(new Duration(milliseconds: 500));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), //TODO change this
        );
      //Navigator.pushReplacement(context,
      //  MaterialPageRoute(builder: (BuildContext context) => MyHomePage(0)));
      //} else {}
    }
  }


  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        child: Text("Authenticate", style: TextStyle(color: Colors.white)),
        color: Colors.lightGreen,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.lightGreen),
              hintText: "Email",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.lightGreen),
              hintText: "Password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: new Image.asset('images/logo-combranco.png',
        width: 60,
        height: 60,
      )
    );
  }


  
}