import 'package:flutter/material.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/button/toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';

class PostedList extends StatefulWidget {
  const PostedList({super.key});

  @override
  State<PostedList> createState() => _PostedListState();
}

class _PostedListState extends State<PostedList> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> jobList = [
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
  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> eventList = [
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
