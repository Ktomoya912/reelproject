import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/titleAppBar.dart';

class Notice extends StatefulWidget {
  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final int index = 0; //BottomAppBarのIcon番号
  final String title = "通知";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: TitleAppBar(title: title),
      //ボトムナビゲーションバー
      bottomNavigationBar: BNB(index: index),
    );
  }
}
