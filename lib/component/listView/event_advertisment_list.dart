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
    required this.notPostJedge,
    required this.functionCall,
  });

  final List<dynamic> advertisementList;
  final MediaQueryData mediaQueryData;
  final bool notPostJedge;
  final Function functionCall;

  static double lineWidth = 0.7; //線の太さ定数

  @override
  State<EventAdvertisementList> createState() => _EventAdvertisementListState();
}

class _EventAdvertisementListState extends State<EventAdvertisementList> {
  //static String dayString = "開催日     : ";
  //static String timeString = "開催時間 : ";
  static String placeString = "開催場所 : ";

  late Map<String, dynamic> eventDetailList = {
    //id
    "id": 1,
    //必須
    //画像
    "image_url": "",
    //タイトル
    "title": "",
    //詳細
    "detail": "",
    "eventTimes": [
      {
        "start_time": "2024-01-18T15:21:23",
        "end_time": "2024-01-18T16:21:23",
        "id": 10
      }
    ], //開催日時
    //開催場所
    "postalNumber": "", //郵便番号
    "prefecture": "", //都道府県
    "city": "", //市町村
    "houseNumber": "", //番地・建物名

    //その他(任意)
    "tag": [], //ハッシュタグ
    "phone": "", //電話番号
    "mail": "", //メールアドレス
    "url": "", //URL
    "fee": "", //参加費
    "Capacity": "", //定員
    "notes": "", //注意事項
    "addMessage": "", //追加メッセージ

    //レビュー
    "reviewPoint": 0, //評価
    //星の割合(前から1,2,3,4,5)
    "ratioStarReviews": [0.0, 0.0, 0.0, 0.0, 0.0],
    //レビュー数
    "reviewNumber": 0,
    //投稿ID
    "reviewId": 0,
    //レビュー内容
    "review": [],

    //この広告を投稿したか
    "postJedge": false,

    //未投稿か否か(true:未投稿,false:投稿済み)
    "notPost": false,

    //掲載期間
    "postTerm": "2023年12月10日",

    //お気に入りか否か
    "favoriteJedge": false,
  };

  bool notEventJedge = false; //イベント広告がないか否か

  //late bool favoriteJedge = eventDetailList["favoriteJedge"]; //お気に入り判定

  changeEventList(dynamic data, int id, ChangeGeneralCorporation store) {
    setState(() {
      eventDetailList["id"] = id; //id
      eventDetailList["image_url"] = data["image_url"]; //画像
      eventDetailList["title"] = data["name"]; //タイトル
      eventDetailList["detail"] = data["description"]; //詳細

      //タグ
      eventDetailList["tag"] = data["tags"];

      //開催日時
      eventDetailList["eventTimes"] = data["event_times"];

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
      eventDetailList["addMessage"] = data["additional_message"]; //追加メッセージ
      eventDetailList["notes"] = data["caution"]; //注意事項

      //レビュー
      eventDetailList["review"] = data["reviews"]; //評価
      //初期化
      eventDetailList["reviewPoint"] = 0; //平均点
      eventDetailList["ratioStarReviews"] = [
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
      ]; //星の割合(前から1,2,3,4,5)
      eventDetailList["reviewNumber"] = 0; //レビュー数
      eventDetailList["reviewId"] = 0; //投稿ID
      if (eventDetailList["review"].length != 0) {
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
              eventDetailList["ratioStarReviews"][i] /
                  eventDetailList["reviewNumber"];
        }
      }

      eventDetailList["favoriteJedge"] = data["is_favorite"]; //お気に入りか否か

      //この広告を投稿したか
      if (data["author"]["id"] == store.myID) {
        eventDetailList["postJedge"] = true;
      } else {
        eventDetailList["postJedge"] = false;
      }

      //未投稿か否か(true:未投稿,false:投稿済み)
      eventDetailList["notPost"] = widget.notPostJedge;
    });
  }

  Future getEventList(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/events/$id');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeEventList(data, id, store);
    } else {
      setState(() {
        notEventJedge = true;
      });
      // print("error");
      // throw Exception("Failed");
    }
  }

  //スクロール位置を取得するためのコントローラー
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notEventJedge = false;
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

    //スクロール位置をリセットする関数

    void changeScrollController() async {
      //reloadEventJedgeがtrueの場合、Home画面をリロードする
      if (store.reloadEventJedge) {
        widget.functionCall();
        //リロード後、falseに戻す
        //await Future.delayed(Duration(microseconds: 1));

        //ここにHome画面リロードの処理を記述
        // スクロール位置をリセットします。
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        // store.changeReloadEventJedgeOn(false); //リロード後、falseに戻す
        // //0.5秒待つ
        // await Future.delayed(
        //     const Duration(milliseconds: ChangeGeneralCorporation.waitTime));
        // //ローディングをpopする
        // Navigator.of(context, rootNavigator: true).pop();
      }
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => changeScrollController());

    //changeScrollController();

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.advertisementList.length, //要素数
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              //ボタン
              InkWell(
                onTap: () async {
                  //print(eventDetailList["title"]);
                  await getEventList(
                      widget.advertisementList.elementAt(index)["id"], store);
                  await Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  EventPostDetail(
                                    id: widget.advertisementList
                                        .elementAt(index)["id"],
                                    tStore: store,
                                    notPostJedge: widget.notPostJedge,
                                    eventDetailList: eventDetailList,
                                    notEventJedge: notEventJedge,
                                  )));
                  widget.functionCall();
                  notEventJedge = false;
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
                                    style: const TextStyle(fontSize: 14)),
                                //開催時
                                Text(
                                    "開催時間 : ${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(11, 13)}時${widget.advertisementList.elementAt(index)["event_times"][0]["start_time"].substring(14, 16)}分",
                                    style: const TextStyle(fontSize: 14)),
                                //開催場所
                                Text(
                                    placeString +
                                        widget.advertisementList
                                            .elementAt(index)["prefecture"] +
                                        widget.advertisementList
                                            .elementAt(index)["city"] +
                                        widget.advertisementList
                                            .elementAt(index)["address"],
                                    style: const TextStyle(fontSize: 14)),
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
                                child: ClipRRect(
                                  // これを追加
                                  borderRadius:
                                      BorderRadius.circular(10), // これを追加
                                  child: Image.network(
                                      widget.advertisementList
                                          .elementAt(index)["image_url"]
                                          .toString(),
                                      fit: BoxFit.cover),
                                )),
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
