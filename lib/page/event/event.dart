import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
//import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/appbar/event_job_appbar.dart';

@RoutePage()
class EventRouterPage extends AutoRouter {
  const EventRouterPage({super.key});
}

@RoutePage()
class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final int index = 1; //BottomAppBarのIcon番号

  //タグリスト
  //検索結果画面が作成できたらここにpush先を追加する
  static List tagList = [
    "夏祭り",
    "花火",
    "香美市",
    "秋祭り",
    "イベント",
    "イベント",
    "イベント",
    "イ"
  ];

  //お気に入り、閲覧履歴リスト
  //それぞれのページができたらここにそれぞれのpush先を追加する
  static List<Map<String, dynamic>> favoriteHistoryList = [
    {
      "icon": Icons.history,
      "title": "イベント閲覧履歴",
    },
    {
      "icon": Icons.favorite,
      "title": "お気に入りイベントリスト",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventJobSearchBar(
          tagList: tagList,
          favoriteHistoryList: favoriteHistoryList,
          title: "おすすめイベント"),
    );
  }
}
