import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/titleAppBar.dart';
import '/component/Button/toggleButton.dart';
import '/component/listView/NoticeListView.dart';

//通知一覧画面作成クラス
class Notice extends StatefulWidget {
  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final int index = 0; //BottomAppBarのIcon番号
  final String title = "通知"; //AppBarに表示する文字

  String content = "イベント開催期間が迫っています";

  List<List<Map<String, dynamic>>> noticeList = [
    [
      {
        "title": "【イベント開催間近1】",
        "subtitle": "開催間近",
      },
      {
        "title": "【イベント開催間近2】",
        "subtitle": "開催間近",
      },
    ],
    [
      {
        "title": "【求人期限間近1】",
        "subtitle": "期限間近",
      },
      {
        "title": "【求人期限間近2】",
        "subtitle": "期限間近",
      },
      {
        "title": "【求人期限間近3】",
        "subtitle": "期限間近",
      }
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
                  jedgeEJ: store.onButtonIndex,
                  noticeList: noticeList,
                  content: content,
                ),
              ],
            ),

            //ボトムナビゲーションバー
            bottomNavigationBar: BNB(index: index),
          );
        }));
  }
}
