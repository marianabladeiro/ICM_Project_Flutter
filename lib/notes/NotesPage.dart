import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pomodoroua_flutter/model/ToDo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login.dart';
import 'TaskDetailPage.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => new _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TickerProviderStateMixin{

  //firebase
  User user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();
  Map<String, String> notesTodos = Map();
  int totalTodos = 0;

  //for notes colors
  var appColors = [Color(0xffA1D2D6),Color.fromRGBO(99, 138, 223, 1.0),Color.fromRGBO(111, 194, 173, 1.0)];

  var cardIndex = 0;
  List<String> notes = [];
  ScrollController scrollController;
  var currentColor = Color(0xffA1D2D6);

  var newNote;

  //animation
  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;
  int n = 0;
  var map2 = {};

  TextEditingController _code;
  var task;

  @override
  void initState()  {
    super.initState();
    scrollController = new ScrollController();
    _code = new TextEditingController();
    _readFromFirebase();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: currentColor,
      appBar: new AppBar(
        title: new Text("ToDo", style: TextStyle(fontSize: 20.0)),
        automaticallyImplyLeading: false,
        backgroundColor:  Color(0xffA1D2D6),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.note_add),
            onPressed: () {
              if (user != null) {
                addSharedNote();
              }
              else {
                dialogAddNote();
              }
            },
          ),
        ],

      ),
      body: SingleChildScrollView(child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 40.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Your ToDo's\n", style:TextStyle(color: Colors.white, fontSize: 28.0,fontWeight: FontWeight.bold,)),
                    totalTodos == 0 ?
                    Text("You have no tasks to do!", style:TextStyle(color: Colors.white, fontSize: 22.0,fontWeight: FontWeight.bold,))
                        :
                    Text("Almost there!\nYou have $totalTodos tasks to do left.", style:TextStyle(color: Colors.white, fontSize: 22.0,fontWeight: FontWeight.bold,)),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
                ),
                Container(
                  height: 350.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notes.length,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              width: 250.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[

                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          color: appColors[1],
                                          onPressed: () {
                                            _editNote(context, position);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          color: appColors[1],
                                          onPressed: () {
                                            _showDialog(notes[position]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          child: Text(notesTodos[notes[position]] + " tasks", style: TextStyle(color: Colors.grey),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          child: Text(notes[position], style: TextStyle(fontSize: 28.0),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          //TODO change to progress indicator
                                          child: LinearProgressIndicator(value: 1,),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                        ),
                        onHorizontalDragEnd: (details) {
                          animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                          curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
                          animationController.addListener(() {
                            setState(() {
                              //currentColor = colorTween.evaluate(curvedAnimation);
                            });
                          });

                          if(details.velocity.pixelsPerSecond.dx > 0) {
                            if(cardIndex>0) {
                              cardIndex--;
                              colorTween = ColorTween(begin:currentColor,end:appColors[cardIndex]);
                            }
                          }else {
                            if(cardIndex<2) {
                              cardIndex++;
                              colorTween = ColorTween(begin: currentColor,
                                  end: appColors[cardIndex]);
                            }
                          }
                          setState(() {
                            scrollController.animateTo((cardIndex)*256.0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                          });

                          colorTween.animate(curvedAnimation);
                          animationController.forward( );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Colors.black,),
        label: Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        onPressed: () {
          if (user != null) {
            _addNote(context);
          }
          else {
            dialogAddNote();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  //if add note
  _addNote(BuildContext context) async {
   await Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => TaskDetailPage()),
   );
   _readFromFirebase();

  }

  //if edit note
  _editNote(BuildContext context, int position) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(noteTitle: notes[position])),
    );
    //for note colors
    _readFromFirebase();

  }

  //read notes from firebase
   Future<List<String>> _readFromFirebase() async{
     if (user != null) {
        await FirebaseDatabase.instance.reference().child("users").child(user.uid)
           .child("notes").once()
           .then((DataSnapshot ds) {
         Map<dynamic,dynamic> map = ds.value;
         notes.clear();
         notesTodos.clear();
         totalTodos = 0;
         if (map != null) {
           map.forEach((key, value) {
             if (value['content'] != null) {
               totalTodos += value['content'].length;
             }
             notes.add(value['title']);
             if (value['content'] != null) {
               notesTodos.putIfAbsent(
                   value['title'], () => value['content'].length.toString());
             }
             else {
               notesTodos.putIfAbsent(value['title'], () => "0");
             }
           });
         }
        if (mounted) {
          setState(() {});
        }
       });
     }
   }

   //dialog to make sure user wants to delete note
  void _showDialog(String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete note"),
          content: new Text("Are you sure you want to delete this note?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Delete", style: TextStyle(fontSize: 18),),
              onPressed: () {
                databaseReference.child("users").child(user.uid).child("notes").child(key).remove();
                notes.remove(key);
                setState(() {});
                _readFromFirebase();
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

  //to add a shared note
  Future addToFB() async{
    //first lets get the task
    final List<dynamic> todo = [];
    String user_uid;
    String title;
    task = json.decode(task);

    Map<String, dynamic> myMap = new Map<String, dynamic>.from(task);
    myMap.forEach((key, value) {
      user_uid = key;
      title = value;
    });
    if (user != null && user.uid.toString() != user_uid) {
      await databaseReference.child("users").child(user_uid)
          .child("notes").child(title).once()
          .then((DataSnapshot ds) {
            Map<dynamic,dynamic> map = ds.value;
              if (map.length == 1) {
                title = map['title'];
              }
              else {
                title = map['title'];
                List<dynamic> cont = map['content'];
                print(cont);
                for(var i = 0; i < cont.length; i++){
                  todo.add(cont[i]);
                }
              }
      });
    }
    //add to current's user fb
    await databaseReference.child("users").child(user.uid).child("notes").child(title).set(
        {
          'title': title,
          'content': todo.length < 0 ? '' : todo
        });
    _readFromFirebase();
  }



  //warns user that they need to log in to continue
  void dialogAddNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Log in first!"),
          content: new Text("You need to be logged in to do this."),
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
              child: new Text("Back to Notes", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //dialog to add shared note
  void addSharedNote() {
    showDialog(context: context,child: Dialog(
        child: new Container ( width: 100, height: 120, child: new Column(
        children: <Widget>[
          new TextField(
        decoration: new InputDecoration(hintText: "Put the task code here"),
            keyboardType: TextInputType.number,
            controller: _code,
        ),
        new FlatButton(
          child: new Text("Add Shared Note"),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              task = prefs.getString(_code.text);
              print(task);
              Navigator.of(context, rootNavigator: true).pop(context);
              //Navigator.of(context).pop();
              addToFB();
              _code.clear();
            },
        ),
        ],
      ),
    ),

    ),
    );
  }

}