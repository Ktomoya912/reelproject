import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/mainAppBar.dart';
import '/page/home/notice.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int index = 0; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: MainAppBar(nextPage: Notice()),
      //ボトムナビゲーションバー
      bottomNavigationBar: BNB(index: index),
    );
  }
}
