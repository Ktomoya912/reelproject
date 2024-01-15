import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/component/appbar/event_job_appbar.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      "title": "閲覧履歴",
    },
    {
      "icon": Icons.favorite,
      "title": "お気に入りリスト",
    },
  ];

  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> advertisementList = [];
  void changeAdvertisementList(List<dynamic> e) {
    setState(() {
      advertisementList = e;
    });
  }

  Future getJobList() async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.typeActive}&sort=recent&order=asc&offset=0&limit=20');
    final response =
        await http.get(url, headers: {'accept': 'application/json'});
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeAdvertisementList(json.decode(data));
    } else {
      throw Exception("Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    getJobList();
  }

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
        body: ShaderMaskComponent(
          child: Column(
            children: [
              JobAdvertisementList(
                advertisementList: advertisementList,
                mediaQueryData: mediaQueryData,
              ),
            ],
          ),
        ));
  }
}
