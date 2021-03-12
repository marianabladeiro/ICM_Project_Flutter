import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pomodoroua_flutter/model/ToDo.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TaskDetailPage extends StatefulWidget {
  String noteTitle;
  TaskDetailPage({this.noteTitle});
  @override
  State<StatefulWidget> createState() {

    return _TaskDetailPage(noteTitle);
  }
}
class _TaskDetailPage extends State<TaskDetailPage> {
  List<Todo> _todosList;
  String noteTitle;
  _TaskDetailPage(this.noteTitle);

  //firebase
  User user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();


  File _image;
  var rNum;

  HashMap notesDetails = new HashMap<String, String>();
  TextEditingController  _controllerTitle = TextEditingController();

  final List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();
  final List<Widget> _todoWidgets = <Widget>[];

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;



  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 300, maxHeight: 420);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _controllerTitle.text = noteTitle;
    Query _todoQuery = databaseReference
        .child("users")
        .child(user.uid)
        .child('notes')
        .child(_controllerTitle.text)
        .child('content');
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);

    noteTitle != null ? _readFromFirebase() : "";

  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  //catches the event snapshot and converts from json to to do model format and adds to the list of todos.
  _onEntryChanged(Event event) {
    var oldEntry = _todosList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      _todosList[_todosList.indexOf(oldEntry)] =
          Todo.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _todosList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  addNewTodo(List<String> list) {
    List<String> allTodos = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i % list.length].length > 0) {
        print(list[i % list.length]);
        Todo todo = new Todo(list[i % list.length]); //just added
        allTodos.add(todo.toString());
      }
    }
    setState(() {

    });
    return allTodos;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Color(0xffA1D2D6),),
            //color: _color,
            onPressed: () {
              _displayDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.camera, color: Color(0xffA1D2D6),),
            //color: _color,
            onPressed: () {
              getImage();
            },
          ),

          IconButton(
            icon: Icon(Icons.save, color: Color(0xffA1D2D6),),
            //color: _color,
            onPressed: () {
              if (_controllerTitle.text == "") {
                final snackBar = SnackBar(content: Text('Make sure you add a title'));
                Scaffold.of(context).showSnackBar(snackBar);
              }
              //update
              if (noteTitle != null) {
                databaseReference.child("users").child(user.uid).child("notes").child(noteTitle).set(
                    {
                      'title': _controllerTitle.text,
                      'content': _todoList.length < 0 ? '' : addNewTodo(_todoList) // TODO change, its going to be a ToDo
                    });
              }
              //write note to firebase
              else if (noteTitle == null) {
                databaseReference.child("users").child(user.uid).child("notes").child(_controllerTitle.text).set(
                    {
                      'title': _controllerTitle.text,
                      'content': _todoList.length < 0 ? '' : addNewTodo(_todoList) // TODO change, its going to be a ToDo
                    });
              }

                setState(() {

                });

              Navigator.pop(context);

            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Color(0xffA1D2D6),),
            //color: _color,
            onPressed: () {
              dialogShare();
            },
          ),


        ],
      ),
      body: Container(
          child: _image == null ? Column(
            children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextFormField(
                controller: _controllerTitle,
                decoration: InputDecoration(
                    labelText: 'Title',

                ),
              ),
            ),
              Container(child: ListView(scrollDirection: Axis.vertical,
                  shrinkWrap: true, children: _getItems())),

            ]
          )
          : Container(
              child: Column (
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      controller: _controllerTitle,
                      decoration: InputDecoration(
                          labelText: 'Title'
                      ),
                    ),
                  ),
                  Container(
                      child: Image.file(_image),
                  ),
                 Container(child: ListView(scrollDirection: Axis.vertical,
                     shrinkWrap: true, children: _getItems()),
                  )
                ]
              )

          ),

      ),
      );

  }

  List<Widget>_getItems() {
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _todoList) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }

  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                },
              ),
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _addTodoItem(String title) {
    setState(() {
      _todoList.add(title);
    });
    _textFieldController.clear();
  }


  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }

  Future<List> _readFromFirebase() async {
    if (user != null && noteTitle != null) {
      await FirebaseDatabase.instance.reference().child("users").child(user.uid)
          .child("notes").child(noteTitle).child("content").once()
          .then((DataSnapshot ds) {
        List<dynamic> map = ds.value;
        if (map != null) {
          map.forEach((key) {
            _todoList.add(key);
          });
        }
        setState(() {});
      });



    }
    print(_todoWidgets);
    return  _todoWidgets;
  }

  //dialog for share
  void dialogShare() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Share Task"),
          content: new Text("You can share a task with someone by generating a code and then sharing it with who you want. The person you want to share the note with also needs to have the app."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Generate Code", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
                generateCode();
              },
            ),
            new FlatButton(
              child: new Text("Go Back", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),


          ],
        );
      },
    );
  }

  //send a request
  Widget sendRequest() {
    showDialog(
      context: context,
      builder: (BuildContext context)  {
        return AlertDialog(
          title: new Text("Share Task"),
          content: new Text("You can share a task with someone in two ways: sending a request or generating a code."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Generate Code", style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),


          ],
        );
      },
    );

  }

  //generate code
void generateCode() {
  int min = 1000;
  int max = 9999;
  var randomizer = new Random();
  rNum = min + randomizer.nextInt(max - min);
  addToSP();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Share Task by Code"),
        content: new Text("$rNum \n\nThe person you want to share the task with should place this code in their ToDo page."),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Ok", style: TextStyle(fontSize: 18),),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),


        ],
      );
    },
  );

}

  addToSP() async {
    Map<String, String> map = Map();
    map.putIfAbsent(user.uid, () =>  _controllerTitle.text);
    var s = json.encode(map);
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(rNum.toString(), s);
  }


}



