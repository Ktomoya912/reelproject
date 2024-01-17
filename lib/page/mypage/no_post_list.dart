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
//import 'package:reelproject/page/event/event.dart';

class NoPostList extends StatefulWidget {
  const NoPostList({
    super.key,
  });

  @override
  State<NoPostList> createState() => _NoPostListState();
}

class _NoPostListState extends State<NoPostList> {
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
        '${ChangeGeneralCorporation.apiUrl}/users/event-postings?${ChangeGeneralCorporation.typeDraft}');

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
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/users/job-postings?${ChangeGeneralCorporation.typeDraft}');
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store =
          Provider.of<ChangeGeneralCorporation>(context, listen: false);
      getEventList(store);
      getJobList(store);
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final tstore =
        Provider.of<ChangeGeneralCorporation>(context, listen: false);
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
              title: "未振り込み投稿一覧",
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
                      notPostJedge: true, //未投稿一覧なのでtrue
                      functionCall: () => getEventList(tstore),
                    )
                  else
                    //求人広告一覧
                    JobAdvertisementList(
                      advertisementList: jobList,
                      mediaQueryData: mediaQueryData,
                      notPostJedge: true, //未投稿一覧なのでtrue
                      functionCall: () => getJobList(tstore),
                    ),
                ],
              ),
            ),
          );
        }));
  }
}
