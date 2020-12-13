import 'package:flutter/material.dart';

class CardItem {

  String cardTitle;
  IconData icon;
  int tasksRemaining;
  double taskCompletion;

  CardItem(this.cardTitle, this.icon, this.tasksRemaining, this.taskCompletion);

}