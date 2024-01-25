import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/component/appbar/event_job_appbar.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
    "屋台",
    "学際",
    "大学",
    "神社"
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

  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> advertisementList = [];
  void changeAdvertisementList(List<dynamic> e) {
    setState(() {
      advertisementList = e;
    });
  }

  Future getEventList() async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/events/?${ChangeGeneralCorporation.sortRecent}&order=asc&offset=0&limit=20&${ChangeGeneralCorporation.typeActive}');

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store =
          Provider.of<ChangeGeneralCorporation>(context, listen: false);

      getEventList();
      //一定間隔毎に更新
      //Timer.periodic(Duration(minutes: 1), (Timer t) => getEventList());
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    //final store = Provider.of<ChangeGeneralCorporation>(context);

    //Home画面リロード用の関数
    void reloadHome() async {
      //reloadHomeJedgeがtrueの場合、Home画面をリロードする
      if (store.reloadEventJedge) {
        getEventList();
        store.changeReloadEventJedgeOn(false); //リロード後、falseに戻す
        store.changeReloadEventScrollOn(true);
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
          title: "おすすめイベント",
          mediaQueryData: mediaQueryData,
          functionCall: () => getEventList(),
        ),
        body: ShaderMaskComponent(
          child: Column(
            children: [
              EventAdvertisementList(
                advertisementList: advertisementList,
                mediaQueryData: mediaQueryData,
                notPostJedge: false,
                functionCall: () => getEventList(),
              ),
            ],
          ),
        ));
  }
}
