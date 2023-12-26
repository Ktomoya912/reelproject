import 'package:flutter/material.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';

//まだアプリと合体しない。
class PostMemberList extends StatefulWidget {
  const PostMemberList({super.key});

  @override
  State<PostMemberList> createState() => _PostMemberListState();
}

class _PostMemberListState extends State<PostMemberList> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> PostMemberListList = [
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
        appBar: const TitleAppBar(
          title: "応募者一覧",
          jedgeBuck: true,
        ),
        body: Column(
          children: [
            JobAdvertisementList(
              advertisementList: PostMemberListList,
              mediaQueryData: mediaQueryData,
            ),
          ],
        ));
  }
}
