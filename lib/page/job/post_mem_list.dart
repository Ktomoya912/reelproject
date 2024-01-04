import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/mypage/apply_conf.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';

class PostMemList extends StatefulWidget {
  const PostMemList({super.key});

  @override
  State<PostMemList> createState() => _PostMemListState();
}

class _PostMemListState extends State<PostMemList> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<Map<String, dynamic>> postMemList = [
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
    {
      "userName": "山田太郎",
      "usereMail": "info@gmail.com",
    },
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得

    double buttonWidthPower = mediaQueryData.size.width / 4; //ボタンの縦横幅
    //画像の縦横幅の最大、最小値
    if (buttonWidthPower > 230) {
      buttonWidthPower = 230;
    } else if (buttonWidthPower < 170) {
      buttonWidthPower = 170;
    }
    //横幅が想定より大きくなった場合、横の幅を広げる
    //その時足し加える値
    double addWidth = 0;
    //横のほうが広くなった場合
    if (mediaQueryData.size.width > mediaQueryData.size.height) {
      addWidth = (mediaQueryData.size.width - mediaQueryData.size.height) / 3;
    }

    return Scaffold(
        appBar: const TitleAppBar(
          title: "応募者一覧",
          jedgeBuck: true,
        ),
        body: ShaderMaskComponent(
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              //真ん中
              //mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(
                  width: mediaQueryData.size.width - addWidth * 2,
                  child: Column(
                    children: [
                      for (int index = 0; index < postMemList.length; index++)
                        EventAdvertisementList(
                          advertisementList: postMemList,
                          mediaQueryData: mediaQueryData,
                          index: index,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}

//イベント広告リストコンポーネント
class EventAdvertisementList extends StatelessWidget {
  const EventAdvertisementList({
    super.key,
    required this.advertisementList,
    required this.mediaQueryData,
    required this.index,
  });

  final List<Map<String, dynamic>> advertisementList;
  final MediaQueryData mediaQueryData;
  final int index; //何番目の要素か

  static double lineWidth = 1.3; //線の太さ定数

  static String dayString = "開催日     : ";
  static String timeString = "開催時間 : ";
  static String placeString = "開催場所 : ";

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ApplyConf()));
        //タップ処理
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: store.greyColor),
          ),
        ),
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //左右寄せ
          //mainAxisAlignment: MainAxisAlignment.center, //横方向真ん中寄寄せ
          children: [
            //画像(円)
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  //真ん中詰め
                  mainAxisSize: MainAxisSize.min,
                  //左詰め
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "ユーザー名         :   ${advertisementList[index]["userName"]}"),
                    Text(
                        "メールアドレス :   ${advertisementList[index]["usereMail"]}"),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: store.greyColor,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
