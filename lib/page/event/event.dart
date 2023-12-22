import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/component/appbar/event_job_appbar.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';

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

  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> advertisementList = [
    {
      "title": "３年ぶりに開催をする川上神社夏祭り", //タイトル
      "day": "2021/8/1", //日付
      "time": "10:00~20:00", //時間
      "place": "香美市川上町", //場所
    },
    {
      "title": "川上神社夏祭り2",
      "day": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    },
    {
      "title": "川上神社夏祭り3",
      "day": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    },
    {
      "title": "川上神社夏祭り4",
      "day": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    },
    {
      "title": "川上神社夏祭り5",
      "day": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    }
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    return Scaffold(
        appBar: EventJobSearchBar(
          tagList: tagList,
          favoriteHistoryList: favoriteHistoryList,
          title: "おすすめイベント",
          mediaQueryData: mediaQueryData,
        ),
        body: EventAdvertisementList(
          advertisementList: advertisementList,
          mediaQueryData: mediaQueryData,
        ));
  }
}
