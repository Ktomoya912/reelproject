import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final int index = 3; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ボトムナビゲーションバー
      bottomNavigationBar: BNB(index: index),
    );
  }
}
