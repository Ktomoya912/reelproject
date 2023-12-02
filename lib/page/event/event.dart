import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/loginAppBar.dart';

class Event extends StatefulWidget {
  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final int index = 1; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ボトムナビゲーションバー
      appBar: LoginAppBar(),
      bottomNavigationBar: BNB(index: index),
    );
  }
}
