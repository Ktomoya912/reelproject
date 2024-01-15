import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/event/event_post_detail.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//イベント広告リストコンポーネント
class EventAdvertisementList extends StatefulWidget {
  const EventAdvertisementList({
    super.key,
    required this.advertisementList,
    required this.mediaQueryData,
  });

  final List<dynamic> advertisementList;
  final MediaQueryData mediaQueryData;

  static double lineWidth = 0.7; //線の太さ定数

  @override
  State<EventAdvertisementList> createState() => _EventAdvertisementListState();
}

class _EventAdvertisementListState extends State<EventAdvertisementList> {
  //static String dayString = "開催日     : ";
  //static String timeString = "開催時間 : ";
  static String placeString = "開催場所 : ";

// データベースと連携させていないので現在はここでイベント詳細内容を設定
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    double buttonWidthPower = widget.mediaQueryData.size.width / 4; //ボタンの縦横幅
    //画像の縦横幅の最大、最小値
    if (buttonWidthPower > 230) {
      buttonWidthPower = 230;
    } else if (buttonWidthPower < 170) {
      buttonWidthPower = 170;
    }
    double imageWidthPower =
        buttonWidthPower - widget.mediaQueryData.size.width / 40; //画像の縦横幅
    //横幅が想定より大きくなった場合、横の幅を広げる
    //その時足し加える値
    double addWidth = 0;
    //横のほうが広くなった場合
    if (widget.mediaQueryData.size.width > widget.mediaQueryData.size.height) {
      addWidth = (widget.mediaQueryData.size.width -
              widget.mediaQueryData.size.height) /
          3;
    }

    return Expanded(
      child: ListView.builder(
        itemCount: widget.advertisementList.length, //要素数
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              //ボタン
              InkWell(
                onTap: () async {
                  //print(eventDetailList["title"]);
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  EventPostDetail(
                                      id: widget.advertisementList
                                          .elementAt(index)["id"],
                                      tStore: store)));
                  //タップ処理
                },
                child:
                    //ボタン全体のサイズ
                    SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //横方向真ん中寄寄せ
                    children: [
                      SizedBox(
                          width: (widget.mediaQueryData.size.width / 100) +
                              addWidth),
                      //左の文
                      SizedBox(
                        width: (widget.mediaQueryData.size.width / 12 * 6) -
                            (addWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
                          mainAxisSize: MainAxisSize.min, //縦方向真ん中寄せ
                          children: [
                            //タイトル
                            Text(
                              widget.advertisementList.elementAt(index)["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, //左寄せ
                              children: [
                                //後で修正
                                //開催日
                                Text(
                                    "開催日     : ${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(0, 4)}年${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(5, 7)}月${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(8, 10)}日",
                                    style: const TextStyle(fontSize: 18)),
                                //開催時
                                Text(
                                    "開催時間 : ${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(11, 13)}時${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(14, 16)}分",
                                    style: const TextStyle(fontSize: 18)),
                                //開催場所
                                Text(
                                    placeString +
                                        widget.advertisementList
                                            .elementAt(index)["prefecture"] +
                                        widget.advertisementList
                                            .elementAt(index)["city"] +
                                        widget.advertisementList
                                            .elementAt(index)["address"],
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //画像
                      SizedBox(
                        height: buttonWidthPower + 10, //ボタン全体の高さ,
                        width: (widget.mediaQueryData.size.width / 12 * 5) -
                            (addWidth),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, //右寄せ
                          children: [
                            Container(
                                height: imageWidthPower,
                                width: imageWidthPower,
                                decoration: BoxDecoration(
                                  color: store.mainColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.network(
                                    widget.advertisementList
                                        .elementAt(index)["image_url"]
                                        .toString(),
                                    fit: BoxFit.cover)),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: (widget.mediaQueryData.size.width / 100) +
                              addWidth),
                    ],
                  ),
                ),
              ),
              //下線
              Container(
                width: widget.mediaQueryData.size.width -
                    (widget.mediaQueryData.size.width / 20) -
                    addWidth * 2,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: store.greyColor,
                        width: EventAdvertisementList.lineWidth),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
