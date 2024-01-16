import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/mypage/apply_conf.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostMemList extends StatefulWidget {
  const PostMemList({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<PostMemList> createState() => _PostMemListState();
}

class _PostMemListState extends State<PostMemList> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static Map<String, dynamic> postMemList = {"users": []};

  void changeAdvertisementList(Map<String, dynamic> e) {
    setState(() {
      postMemList = e;
      print(postMemList);
    });
  }

  //応募者一覧取得
  Future getApplyList(int id, ChangeGeneralCorporation store) async {
    Uri url =
        Uri.parse('${ChangeGeneralCorporation.apiUrl}/jobs/${id}/application');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${store.accessToken}'
    });

    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeAdvertisementList(json.decode(data));
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
      getApplyList(widget.id, store);
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context, listen: false);

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
          child: SizedBox(
            width: mediaQueryData.size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // ここを追加

                children: [
                  for (int index = 0;
                      index < postMemList["users"].length;
                      index++)
                    SizedBox(
                      width: mediaQueryData.size.width - addWidth * 2,
                      child: EventAdvertisementList(
                        id: widget.id,
                        advertisementList: postMemList,
                        mediaQueryData: mediaQueryData,
                        index: index,
                        onTap: () async {
                          await Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      ApplyConf(
                                        advertisementList: postMemList["users"]
                                            [index],
                                        jobID: postMemList["job_id"],
                                      )));
                          getApplyList(widget.id, store);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}

//イベント広告リストコンポーネント
class EventAdvertisementList extends StatelessWidget {
  const EventAdvertisementList({
    super.key,
    required this.id,
    required this.advertisementList,
    required this.mediaQueryData,
    required this.index,
    required this.onTap,
  });

  final int id;
  final Map<String, dynamic> advertisementList;
  final MediaQueryData mediaQueryData;
  final int index; //何番目の要素か
  final VoidCallback onTap;

  static double lineWidth = 1.3; //線の太さ定数

  static String dayString = "開催日     : ";
  static String timeString = "開催時間 : ";
  static String placeString = "開催場所 : ";

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          //色
          color: advertisementList["users"][index]["status"] == "p"
              ? Colors.white
              : Color.fromARGB(255, 238, 238, 238),
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
                    child: ClipRRect(
                      // これを追加
                      borderRadius: BorderRadius.circular(50), // これを追加
                      child: Image.network(
                          advertisementList["users"][index]["user"]["image_url"]
                              .toString(),
                          fit: BoxFit.cover),
                    )),
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
                        "ユーザー名         :   ${advertisementList["users"][index]["user"]["username"]}"),
                    Text(
                        "メールアドレス  :   ${advertisementList["users"][index]["user"]["email"]}"),
                    Text(
                        "確認状態            :   ${advertisementList["users"][index]["status"] == "p" ? '未確認' : advertisementList["users"][index]["status"] == "a" ? '確認済み' : '不採用'}"),
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
