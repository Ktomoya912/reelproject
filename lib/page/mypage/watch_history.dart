import 'package:flutter/material.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/button/toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WatchHistory extends StatefulWidget {
  const WatchHistory({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  State<WatchHistory> createState() => _WatchHistoryState();
}

class _WatchHistoryState extends State<WatchHistory> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> jobList = [];
  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> eventList = [];

  void changeEventList(List<dynamic> e) {
    setState(() {
      eventList = e;
    });
  }

  Future getEventList(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/events/?${ChangeGeneralCorporation.sortLastWatched}&order=asc&offset=0&limit=50&${ChangeGeneralCorporation.typeActive}&user_id=${store.myID}&target=history');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeEventList(json.decode(data));
    } else {
      throw Exception("Failed");
    }
  }

  void changeJobList(List<dynamic> e) {
    setState(() {
      jobList = e;
    });
  }

  Future getJobList(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.sortLastWatched}&order=asc&offset=0&limit=50&${ChangeGeneralCorporation.typeActive}&user_id=${store.myID}&target=history');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeJobList(json.decode(data));
    } else {
      throw Exception("Failed");
    }
  }

  //初期化
  @override
  void initState() {
    getEventList(widget.store);
    getJobList(widget.store);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ChangeNotifierProvider(
        create: (context) => ChangeToggleButton(),
        child: Builder(builder: (BuildContext context) {
          final store = Provider.of<ChangeToggleButton>(context); //プロバイダ

          // String title = "投稿イベント広告一覧";
          // if (store.onButtonIndex == 0) {
          //   title = "投稿イベント広告一覧";
          // } else {
          //   title = "投稿求人広告一覧";
          // }
          return Scaffold(
            //アップバー
            appBar: const TitleAppBar(
              title: "閲覧履歴",
              jedgeBuck: true,
            ),

            body: ShaderMaskComponent(
              child: Column(
                children: [
                  //イベント、求人切り替えボタン
                  //四角で囲む(上ボタンの幅選択)
                  ToggleButton(
                    mediaQueryData: mediaQueryData,
                    leftTitle: "イベント",
                    rightTitle: "求人",
                    height: 50,
                  ),

                  if (store.onButtonIndex == 0)
                    //イベント広告一覧
                    EventAdvertisementList(
                      advertisementList: eventList,
                      mediaQueryData: mediaQueryData,
                      notPostJedge: false,
                      functionCall: () => getEventList(widget.store),
                    )
                  else
                    //求人広告一覧
                    JobAdvertisementList(
                      advertisementList: jobList,
                      mediaQueryData: mediaQueryData,
                      notPostJedge: false,
                      functionCall: () => getJobList(widget.store),
                    ),
                ],
              ),
            ),
          );
        }));
  }
}
