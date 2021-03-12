import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String subject;
  bool completed;

  Todo(this.subject);

  Todo.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        subject = snapshot.value["subject"],
        completed = snapshot.value["completed"];

  toString() {
    return subject;
  }
}