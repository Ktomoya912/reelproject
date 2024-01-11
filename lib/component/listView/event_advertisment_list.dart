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

  Map<String, dynamic> eventDetailList = {
    //id
    "id": 1,
    //必須
    "title": "川上神社夏祭り", //タイトル
    //詳細
    "detail":
        "川上様夏祭りは香北の夏の風物詩ともいえるお祭で、ビアガーデンや各種団体による模擬店、ステージイベントなどが行われ、毎年市内外から多くの見物客が訪れます。\n \n ステージイベント、宝さがし、鎮守の杜のびらふマルシェなど、子どもから大人まで誰でも楽しめるイベント内容が盛りだくさん！",
    "day": ["2021年8月1日", "2021年8月2日", "2021年8月2日"], //日付
    "time": ["10時00分~20時00分", "10時00分~20時00分", "10時00分~20時00分"], //時間
    //開催場所
    "postalNumber": "781-5101", //郵便番号
    "prefecture": "高知県", //都道府県
    "city": "香美市", //市町村
    "houseNumber": "川上町", //番地・建物名

    //その他(任意)
    "tag": [
      {
        "name": "夏祭り",
        "id": 1,
      },
    ], //ハッシュタグ
    "phone": "0887-00-0000", //電話番号
    "mail": "conf@gmai.com", //メールアドレス
    "url": "https://www.city.kami.lg.jp/", //URL
    "fee": "1000", //参加費
    "Capacity": "100", //定員
    "notes": "", //注意事項
    "addMessage": "test", //追加メッセージ

    //レビュー
    "reviewPoint": 0, //評価
    //星の割合(前から1,2,3,4,5)
    "ratioStarReviews": [0, 0, 0, 0, 0],
    //レビュー数
    "reviewNumber": 0,
    //投稿ID
    "reviewId": 0,
    //レビュー内容
    "review": [
      {
        "reviewerName": "名前aiueo",
        //"reviewerImage" : "test"   //予定
        "reviewPoint": 3, //レビュー点数
        "reviewDetail": "testfffff\n\n\n\n\n\n\nfffff", //レビュー内容
        "reviewDate": "2021年8月1日", //レビュー日時
      },
      {
        "reviewerName": "名前kakikukeko",
        //"reviewerImage" : "test"   //予定
        "reviewPoint": 3, //レビュー点数
        "reviewDetail": "test", //レビュー内容
        "reviewDate": "2021年8月1日", //レビュー日時
      },
      {
        "reviewerName": "名前sasisuseso",
        //"reviewerImage" : "test"   //予定
        "reviewPoint": 3, //レビュー点数
        "reviewDetail": "test", //レビュー内容
        "reviewDate": "2021年8月1日", //レビュー日時
      }
    ],

    //この広告を投稿したか
    "postJedge": true,

    //未投稿か否か(true:未投稿,false:投稿済み)
    "notPost": false,

    //掲載期間
    "postTerm": "2023年12月10日",

    //お気に入りか否か
    "favoriteJedge": false,
  };

  changeEventList(dynamic data, int id, ChangeGeneralCorporation store) {
    setState(() {
      eventDetailList["id"] = id; //id
      eventDetailList["title"] = data["name"]; //タイトル
      eventDetailList["detail"] = data["description"]; //詳細

      //タグ
      eventDetailList["tag"] = data["tags"];

      //住所
      eventDetailList["postalNumber"] = data["postal_code"]; //郵便番号
      eventDetailList["prefecture"] = data["prefecture"]; //都道府県
      eventDetailList["city"] = data["city"]; //市町村
      eventDetailList["houseNumber"] = data["address"]; //番地・建物名
      //任意
      eventDetailList["phone"] = data["phone_number"]; //電話番号
      eventDetailList["mail"] = data["email"]; //メールアドレス
      eventDetailList["url"] = data["homepage"]; //URL
      eventDetailList["fee"] = data["participation_fee"]; //参加費
      eventDetailList["Capacity"] = data["capacity"]; //定員
      eventDetailList["addMessage"] = data["description"]; //追加メッセージ
      eventDetailList["notes"] = data["caution"]; //注意事項

      //レビュー
      eventDetailList["review"] = data["reviews"]; //評価
      if (eventDetailList["review"].length != 0) {
        //初期化
        eventDetailList["reviewPoint"] = 0; //平均点
        eventDetailList["ratioStarReviews"] = [
          0,
          0,
          0,
          0,
          0
        ]; //星の割合(前から1,2,3,4,5)
        eventDetailList["reviewNumber"] = 0; //レビュー数
        //平均点
        for (int i = 0; i < data["reviews"].length; i++) {
          eventDetailList["reviewPoint"] +=
              data["reviews"][i]["review_point"]; //平均点
          eventDetailList["ratioStarReviews"]
              [data["reviews"][i]["review_point"] - 1]++; //星の割合(前から1,2,3,4,5)
          //自分のレビューか否か
          if (store.myID == data["reviews"][i]["user"]["id"]) {
            eventDetailList["reviewId"] = data["reviews"][i]["id"];
          }
        }
        //平均を出す
        eventDetailList["reviewPoint"] =
            eventDetailList["reviewPoint"] / data["reviews"].length;

        //レビュー数
        eventDetailList["reviewNumber"] = data["reviews"].length;

        //割合計算
        for (int i = 0; i < 5; i++) {
          eventDetailList["ratioStarReviews"][i] =
              eventDetailList["ratioStarReviews"][i] / data["reviews"].length;
        }
      }

      eventDetailList["favoriteJedge"] = data["is_favorite"]; //お気に入りか否か
    });
  }

  Future getEventList(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/events/$id');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTcwNzYxODE0NX0.wtF4bgEe6F9Oa2IpE5nWWQ_O2pzTOrhkPrCAmMwA1Xg'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeEventList(data, id, store);
    } else {
      print("error");
      throw Exception("Failed");
    }
  }

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
                  await getEventList(
                      widget.advertisementList[index]["id"], store);
                  //print(eventDetailList["title"]);
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  EventPostDetail(eventList: eventDetailList)));
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
                            ),
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
