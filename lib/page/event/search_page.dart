import 'package:flutter/material.dart';
//import 'package:auto_route/auto_route.dart';
//import 'package:reelproject/component/appbar/event_job_appbar.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';
import 'package:reelproject/component/appbar/search_appbar.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.text,
    required this.eventJobJedge,
    required this.sort,
  });

  final String text;
  final String eventJobJedge;
  final String sort;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final int index = 1; //BottomAppBarのIcon番号

  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> eventAdvertisementList = [
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

  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> jobAdvertisementList = [
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
        appBar: SearchAppbar(
          title: widget.text,
          mediaQueryData: mediaQueryData,
          eventJobJedge: widget.eventJobJedge,
        ),
        body: Column(
          children: [
            if (widget.eventJobJedge == "おすすめイベント")
              EventAdvertisementList(
                advertisementList: eventAdvertisementList,
                mediaQueryData: mediaQueryData,
              )
            else if (widget.eventJobJedge == "おすすめ求人")
              JobAdvertisementList(
                advertisementList: jobAdvertisementList,
                mediaQueryData: mediaQueryData,
              )
          ],
        ));
  }
}
