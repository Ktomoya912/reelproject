import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/component/appbar/event_job_appbar.dart';

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
    );
  }
}
