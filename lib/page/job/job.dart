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
import 'dart:async';

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
        '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.sortRecent}&order=asc&offset=0&limit=20&${ChangeGeneralCorporation.typeActive}');
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
    //一定間隔毎に更新
    //Timer.periodic(Duration(minutes: 1), (Timer t) => getJobList());
  }

  //スクロール位置を取得するためのコントローラー

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    //スクロール位置をリセットする関数

    // void changeScrollController() async {
    //   //reloadEventJedgeがtrueの場合、Home画面をリロードする
    //   if (store.reloadJobJedge) {
    //     await getJobList();
    //     store.changeReloadJobJedgeOn(false); //リロード後、falseに戻す
    //     //0.5秒待つ
    //     await Future.delayed(
    //         const Duration(milliseconds: ChangeGeneralCorporation.waitTime));
    //     //ローディングをpop
    //     Navigator.of(context, rootNavigator: true).pop();
    //   }
    // }

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => changeScrollController());

    //Home画面リロード用の関数
    void reloadHome() async {
      //reloadHomeJedgeがtrueの場合、Home画面をリロードする
      if (store.reloadJobJedge) {
        //getJobList();
        store.changeReloadJobJedgeOn(false); //リロード後、falseに戻す
        //0.5秒待つ
        await Future.delayed(
            const Duration(milliseconds: ChangeGeneralCorporation.waitTime));
        //ローディングをpop
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    //ビルド後に実行
    WidgetsBinding.instance.addPostFrameCallback((_) => reloadHome());

    return Scaffold(
        appBar: EventJobSearchBar(
          tagList: tagList,
          favoriteHistoryList: favoriteHistoryList,
          title: "おすすめ求人",
          mediaQueryData: mediaQueryData,
          functionCall: () => getJobList(),
        ),
        body: ShaderMaskComponent(
          child: Column(
            children: [
              JobAdvertisementList(
                advertisementList: advertisementList,
                mediaQueryData: mediaQueryData,
                notPostJedge: false,
                functionCall: () => getJobList(),
              ),
            ],
          ),
        ));
  }
}
