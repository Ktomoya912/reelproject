//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import '../../page/mypage/impression.dart';
import '../../page/Job/post_mem_list.dart';
import 'package:reelproject/overlay/rule/screen/delete_conf.dart';
import 'package:reelproject/overlay/rule/screen/job_app.dart';
import 'package:reelproject/overlay/rule/screen/notpost_delete_conf.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:reelproject/page/create_ad/fee_watch.dart';

class DetailAppbar extends StatefulWidget implements PreferredSizeWidget {
  const DetailAppbar({
    super.key,
    required this.eventJobDetail,
    required this.postJedge,
    required this.eventJobJedge,
    required this.postTerm,
    required this.mediaQueryData,
    required this.notPostJedge,
    required this.id,
    required this.callback,
  });

  final Map<String, dynamic> eventJobDetail; //イベント、求人詳細Map
  final bool postJedge;
  final String eventJobJedge;
  final String postTerm;
  final MediaQueryData mediaQueryData;
  final bool notPostJedge;
  final int id;
  final Function callback;

  static Color greyColor = Colors.grey[500]!;

  @override
  Size get preferredSize {
    return const Size(double.infinity, 50.0);
  }

  @override
  State<DetailAppbar> createState() => _DetailAppbarState();
}

class _DetailAppbarState extends State<DetailAppbar> {
  //インプレッションデータ
  Map<String, dynamic> impressionData = {
    "favorite_user_count": 0,
    "pv": 8,
    "review_count": 0,
    "sex": {
      "all": {
        "20際未満": 0.0,
        "20-24歳": 0.0,
        "25-29歳": 0.0,
        "30-34際": 0.0,
        "35-39際": 0.0,
        "40際以上": 0.0
      },
      //総合計
      "allJedge": 0,
      "o": {
        "20際未満": 0.0,
        "20-24歳": 0.0,
        "25-29歳": 0.0,
        "30-34際": 0.0,
        "35-39際": 0.0,
        "40際以上": 0.0
      },
      "oJedge": 0,
      "m": {
        "20際未満": 0.0,
        "20-24歳": 0.0,
        "25-29歳": 0.0,
        "30-34際": 0.0,
        "35-39際": 0.0,
        "40際以上": 0.0
      },
      "mJedge": 0,
      "f": {
        "20際未満": 0.0,
        "20-24歳": 0.0,
        "25-29歳": 0.0,
        "30-34際": 0.0,
        "35-39際": 0.0,
        "40際以上": 0.0
      },
      "fJedge": 0,
    }
  };

  //インプレッションデータ更新
  void changeImpressionData(Map<String, dynamic> data) {
    setState(() {
      impressionData["favorite_user_count"] = data["favorite_user_count"];
      impressionData["pv"] = data["pv"];
      impressionData["review_count"] = data["review_count"];
      //性別
      List<String> sex = ["o", "m", "f"];
      List<String> jedge = ["oJedge", "mJedge", "fJedge"];
      List<String> age = [
        "20際未満",
        "20-24歳",
        "25-29歳",
        "30-34際",
        "35-39際",
        "40際以上"
      ];
      List<String> ageApi = [
        "under_20",
        "20-24",
        "25-29",
        "30-34",
        "35-39",
        "over_40"
      ];
      //all初期化
      impressionData["sex"]["all"] = {
        "20際未満": 0.0,
        "20-24歳": 0.0,
        "25-29歳": 0.0,
        "30-34際": 0.0,
        "35-39際": 0.0,
        "40際以上": 0.0
      };
      impressionData["sex"]["allJedge"] = 0;
      //代入 & all計算
      for (int sexIndex = 0; sexIndex < 3; sexIndex++) {
        //初期化
        impressionData["sex"][jedge[sexIndex]] = 0;
        for (int ageIndex = 0; ageIndex < 6; ageIndex++) {
          //初期化
          impressionData["sex"][sex[sexIndex]][age[ageIndex]] = 0.0;
          //代入
          impressionData["sex"][sex[sexIndex]][age[ageIndex]] +=
              data["sex"][sex[sexIndex]][ageApi[ageIndex]];
          //all計算
          impressionData["sex"]["all"][age[ageIndex]] +=
              data["sex"][sex[sexIndex]][ageApi[ageIndex]];
          //対象の要素がすべて0でないかのジャッジ
          impressionData["sex"][jedge[sexIndex]] +=
              data["sex"][sex[sexIndex]][ageApi[ageIndex]];
        }
        impressionData["sex"]["allJedge"] +=
            impressionData["sex"][jedge[sexIndex]];
      }
    });
  }

  //インプレッションデータ取得
  Future getImpressiont(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/${widget.eventJobJedge}s/${widget.id}/impressions');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${store.accessToken}'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeImpressionData(data);
    } else {
      print("error");
      throw Exception("Failed");
    }
  }

  //プラン情報
  Map<String, dynamic> planData = {};

  //プラン情報更新
  void changePlanData(Map<String, dynamic> data) {
    setState(() {
      planData = data;
    });
  }

  //プラン情報取得
  Future getPlan(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/plans/${widget.eventJobDetail["parchase"]["plan_id"]}');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changePlanData(data);
    } else {
      print("error");
      throw Exception("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(
      //アップバー
      appBar: AppBar(
        backgroundColor: Colors.white, //背景
        iconTheme: IconThemeData(color: store.greyColor), //戻るボタン
        centerTitle: true, //中央揃え
        toolbarHeight: 50, //アップバーの高さ
        //影
        //elevation: 4,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        actions: [
          //法人の際に表示
          if (widget.postJedge && !store.jedgeGC)
            SizedBox(
              child: Row(
                children: [
                  TextButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '投稿詳細(投稿者限定)  ',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                          Icon(Icons.menu, color: Colors.grey[700], size: 30),
                        ],
                      ),
                      onPressed: () {
                        //投稿したユーザーである場合表示
                        showModalBottomSheet<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                child: SingleChildScrollView(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.bottomLeft,
                                        width:
                                            widget.mediaQueryData.size.width *
                                                10,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: DetailAppbar.greyColor,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: const Text("投稿情報")),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: DetailAppbar.greyColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        //右側の矢印アイコン
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: DetailAppbar.greyColor,
                                        ),
                                        tileColor: Colors.white, //背景
                                        leading: const Icon(
                                            Icons.signal_cellular_alt),
                                        title: const Text('インプレッション'),
                                        onTap: () async {
                                          await getImpressiont(store);
                                          Navigator.of(context).pop(1);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Impressions(
                                                impressionData: impressionData,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (widget.eventJobJedge == "job")
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: DetailAppbar.greyColor,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          //右側の矢印アイコン
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                            color: DetailAppbar.greyColor,
                                          ),
                                          tileColor: Colors.white, //背景
                                          leading: const Icon(Icons.fact_check),
                                          title: const Text('応募者確認'),
                                          onTap: () => {
                                            Navigator.of(context).pop(2),
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostMemList(id: widget.id),
                                              ),
                                            ),
                                          },
                                        ),
                                      ),
                                    Container(
                                        alignment: Alignment.bottomLeft,
                                        width:
                                            widget.mediaQueryData.size.width *
                                                10,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: DetailAppbar.greyColor,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: const Text("投稿内容編集・削除")),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: DetailAppbar.greyColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        //右側の矢印アイコン
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: DetailAppbar.greyColor,
                                        ),
                                        tileColor: Colors.white, //背景
                                        leading: const Icon(Icons.edit),
                                        title: const Text('投稿内容編集'),
                                        onTap: () {
                                          //Navigator.of(context).pop();
                                          //ポップアップ表示(編集)
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child: SingleChildScrollView(
                                                  child: AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10), // ここで角の丸みを調整します
                                                    ),
                                                    title: const Text('編集確認'),
                                                    content: const Text(
                                                        '本当に投稿を編集しますか？'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('編集'),
                                                        onPressed: () {
                                                          //こうた追加(widget.eventJobDetailがリスト)(widget.eventJobJedgeがイベントか求人かevent,jobが入っている)
                                                          Navigator.of(context)
                                                              .pop();
                                                          //ここに移動処理を書く
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //     builder: (context) =>
                                                          //         PostMemList(id: widget.id),
                                                          //   ),
                                                          // );
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('キャンセル'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         PostMemList(id: widget.id),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    ),
                                    //振込金額記入
                                    if (widget.notPostJedge)
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: DetailAppbar.greyColor,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: ListTile(
                                          //右側の矢印アイコン
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                            color: DetailAppbar.greyColor,
                                          ),
                                          tileColor: Colors.white, //背景
                                          leading: const Icon(Icons.money),
                                          title: const Text('振込金額確認'),
                                          onTap: () async {
                                            //await getPlan(store);
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              // MaterialPageRoute(builder: (context) => Home()),
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => JobFeeWatch(
                                                            planId: widget
                                                                        .eventJobDetail[
                                                                    "parchase"]
                                                                ["plan_id"],
                                                            planPeriod: ((DateTime.parse(widget
                                                                            .eventJobDetail["parchase"][
                                                                                "expiration_date"]
                                                                            .substring(0,
                                                                                10))
                                                                        .difference(DateTime.parse("${DateTime.now()}".substring(
                                                                            0,
                                                                            10)))
                                                                        .inDays) /
                                                                    30)
                                                                .ceil(),
                                                            eventJobJedge:
                                                                widget.eventJobJedge ==
                                                                        "event"
                                                                    ? true
                                                                    : false,
                                                            botommBarJedge:
                                                                false,
                                                          )),
                                            );
                                          },
                                        ),
                                      ),

                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: DetailAppbar.greyColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        //右側の矢印アイコン
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: DetailAppbar.greyColor,
                                        ),
                                        tileColor: Colors.white, //背景
                                        leading: const Icon(Icons.delete),
                                        title: const Text('投稿削除'),
                                        onTap: () => {
                                          //Navigator.of(context).pop(3),

                                          //投稿削除
                                          if (!widget.notPostJedge)
                                            {
                                              store.changeOverlay(true),
                                              DeleteConf().show(
                                                  context: context,
                                                  id: widget.id,
                                                  eventJobJedge:
                                                      widget.eventJobJedge)
                                            }
                                          //未投稿削除
                                          else
                                            {
                                              store.changeOverlay(true),
                                              NotpostDeleteConf().show(
                                                  context: context,
                                                  id: widget.id,
                                                  eventJobJedge:
                                                      widget.eventJobJedge)
                                            }
                                        },
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topRight,
                                      color: Colors.white,
                                      width:
                                          widget.mediaQueryData.size.width * 10,
                                      height: 40,
                                      child:
                                          Text("投稿期間 : ${widget.postTerm} まで"),
                                    ),
                                  ],
                                )),
                              );
                            });
                      }),
                ],
              ),
            )
          //応募ボタン
          else if (!widget.postJedge &&
              store.jedgeGC &&
              widget.eventJobJedge == "job")
            Row(
              children: [
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        store.changeOverlay(true);
                        JobApp().show(
                          //これでおーばーれい表示
                          context: context,
                          id: widget.id,
                          callback: widget.callback,
                        );
                      },

                      //色
                      style: ElevatedButton.styleFrom(
                        backgroundColor: store.mainColor,
                        //onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('求人に応募する',
                          style: TextStyle(color: Colors.white)),
                    )),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
        ],
      ),
    );
  }
}
