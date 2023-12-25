import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/component/appbar/event_job_appbar.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';

//求人ページ
@RoutePage()
class JobRouterPage extends AutoRouter {
  const JobRouterPage({super.key});
}

@RoutePage()
class Job extends StatefulWidget {
  const Job({super.key});

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  final int index = 2; //BottomAppBarのIcon番号

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
      "title": "求人閲覧履歴",
    },
    {
      "icon": Icons.favorite,
      "title": "お気に入り求人リスト",
    },
  ];

  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> advertisementList = [
    {
      "title": "居酒屋新谷スタッフ募集", //タイトル
      "pay": "900", //時給
      "time": null, //時間
      "place": "香美市土佐山田町000", //場所
    },
    {
      "title": "川上神社夏祭り2",
      "pay": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    },
    {
      "title": "川上神社夏祭り3",
      "pay": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    },
    {
      "title": "川上神社夏祭り4",
      "pay": "2021/8/1",
      "time": "10:00~20:00",
      "place": "香美市川上町",
    },
    {
      "title": "川上神社夏祭り5",
      "pay": "2021/8/1",
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
          title: "おすすめ求人",
          mediaQueryData: mediaQueryData,
        ),
        body: Column(
          children: [
            JobAdvertisementList(
              advertisementList: advertisementList,
              mediaQueryData: mediaQueryData,
            ),
          ],
        ));
  }
}
