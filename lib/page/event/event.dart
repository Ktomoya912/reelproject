import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';

class Event extends StatefulWidget {
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final int index = 1; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BNB(index: index),
    );
  }
}
