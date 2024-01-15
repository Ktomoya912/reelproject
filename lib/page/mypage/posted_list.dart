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

class PostedList extends StatefulWidget {
  const PostedList({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  State<PostedList> createState() => _PostedListState();
}

class _PostedListState extends State<PostedList> {
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
        '${ChangeGeneralCorporation.apiUrl}/users/event-postings?type=posted');

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
        '${ChangeGeneralCorporation.apiUrl}/users/job-postings?type=posted');
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

          return Scaffold(
            //アップバー
            appBar: const TitleAppBar(
              title: "投稿一覧",
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
                    )
                  else
                    //求人広告一覧
                    JobAdvertisementList(
                      advertisementList: jobList,
                      mediaQueryData: mediaQueryData,
                      notPostJedge: false,
                    ),
                ],
              ),
            ),
          );
        }));
  }
}
