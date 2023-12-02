import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/titleAppBar.dart';
import '/component/Button/toggleButton.dart';
import '/component/listView/NoticeListView.dart';

class Notice extends StatefulWidget {
  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final int index = 0; //BottomAppBarのIcon番号
  final String title = "通知"; //AppBarに表示する文字

  List<List<Map<String, dynamic>>> noticeList = [
    [
      {"title": "【イベント開催間近】", "subtitle": "開催間近"},
      {"title": "【イベント開催間近】", "subtitle": "開催間近"},
    ],
    [
      {"title": "【イベント開催間近】", "subtitle": "開催間近"},
      {"title": "【イベント開催間近】", "subtitle": "開催間近"},
      {"title": "【イベント開催間近】", "subtitle": "開催間近"},
    ]
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return ChangeNotifierProvider(
        create: (context) => ChangeToggleButton(),
        child: Builder(builder: (BuildContext context) {
          final store = Provider.of<ChangeToggleButton>(context); //プロバイダ
          return Scaffold(
            //アップバー
            appBar: TitleAppBar(title: title),

            body: Column(
              children: [
                //イベント、求人切り替えボタン
                //四角で囲む(上ボタンの幅選択)

                ToggleButton(
                  mediaQueryData: _mediaQueryData,
                  leftTitle: "イベント",
                  rightTitle: "求人",
                  height: 50,
                ),

                //リスト
                NoticeListView(
                    jedgeEJ: store.onButtonIndex, noticeList: noticeList),
              ],
            ),

            //ボトムナビゲーションバー
            bottomNavigationBar: BNB(index: index),
          );
        }));
  }
}
