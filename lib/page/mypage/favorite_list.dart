import 'package:flutter/material.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/button/toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteList extends StatefulWidget {
  const FavoriteList({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> jobList = [
    {
      "name": "strinqesswrg",
      "image_url": "https://example.com",
      "salary": "時給1000円",
      "postal_code": "782-8502",
      "prefecture": "高知県",
      "city": "香美市",
      "address": "土佐山田町宮ノ口185",
      "description": "説明",
      "is_one_day": true,
      "additional_message": "追加メッセージ",
      "tags": [
        {"name": "タグ名", "id": 1}
      ],
      "job_times": [
        {
          "start_time": "2024-01-24T14:51:29",
          "end_time": "2024-01-24T15:51:29",
          "id": 2
        }
      ],
      "id": 3,
      "status": null
    },
  ];
  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> eventList = [
    {
      "name": "イベントaaaaa名",
      "image_url": "https://example.com",
      "postal_code": "782-8502",
      "prefecture": "高知県",
      "city": "香美市",
      "address": "土佐山田町宮ノ口185",
      "phone_number": "0887-53-1111",
      "email": "sample@ugs.ac.jp",
      "homepage": "https://kochi-tech.ac.jp/",
      "participation_fee": "無料",
      "capacity": 100,
      "additional_message": "",
      "description": "",
      "caution": "",
      "tags": [
        {"name": "タグ名", "id": 1}
      ],
      "event_times": [
        {
          "start_time": "2024-01-23T14:51:29",
          "end_time": "2024-01-23T15:51:29",
          "id": 4
        }
      ],
      "id": 6,
      "status": null
    },
  ];

  void changeEventList(List<dynamic> e) {
    setState(() {
      eventList = e;
    });
  }

  Future getEventList(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/users/event-bookmarks');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${store.accessToken}'
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
    Uri url = Uri.parse('http://localhost:8000/api/v1/users/job-bookmarks');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${store.accessToken}'
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
              title: "お気に入りリスト",
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
                    )
                  else
                    //求人広告一覧
                    JobAdvertisementList(
                      advertisementList: jobList,
                      mediaQueryData: mediaQueryData,
                    ),
                ],
              ),
            ),
          );
        }));
  }
}
