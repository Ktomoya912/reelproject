import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';

class Job extends StatefulWidget {
  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  final int index = 2; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ボトムナビゲーションバー
      bottomNavigationBar: BNB(index: index),
    );
  }
}
