import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/component/appbar/detail_appbar.dart';
//import 'package:reelproject/page/event/event.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/listView/carousel.dart';
import 'package:reelproject/page/event/search_page.dart'; //イベント検索
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//タイトルアップバー
import 'package:reelproject/component/appbar/title_appbar.dart';

class EventPostDetail extends StatefulWidget {
  const EventPostDetail({
    super.key,
    required this.id,
    required this.tStore,
    required this.notPostJedge,
    required this.eventDetailList,
    required this.notEventJedge,
  });

  final int id;
  final tStore;
  final bool notPostJedge;
  final Map<String, dynamic> eventDetailList;
  final bool notEventJedge; //イベントが存在しない場合true

  @override
  State<EventPostDetail> createState() => _EventPostDetailState();
}

class _EventPostDetailState extends State<EventPostDetail> {
  late Map<String, dynamic> eventDetailList = widget.eventDetailList;

  late bool notEventJedge = widget.notEventJedge;

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

  //イベント詳細取得
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
    }
  }

  @override
  void initState() {
    super.initState();
    notEventJedge = false;
    getEventList(widget.id, widget.tStore);
  }

  //お気に入り登録
  Future boobkmark(int id, ChangeGeneralCorporation store) async {
    Uri url =
        Uri.parse('${ChangeGeneralCorporation.apiUrl}/events/$id/bookmark');
    final response = await put(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    if (response.statusCode == 200) {
      getEventList(widget.id, widget.tStore);
    } else {
      setState(() {
        notEventJedge = true;
      });
    }
  }

  //求人広告のリスト
  //titleに文字数制限を設ける

  //二度同じ場所を表示しないように制御する関数
  Widget generateWidgets(int i, double height) {
    if (i == 0) {
      return Text(
          "〒${eventDetailList["postalNumber"]}  ${eventDetailList["prefecture"]}${eventDetailList["city"]}${eventDetailList["houseNumber"]}",
          // "〒" +
          //     eventDetailList["postalNumber"][i] +
          //     "   " +
          //     eventDetailList["prefecture"][i] +
          //     eventDetailList["city"][i] +
          //     eventDetailList["houseNumber"][i],
          style: const TextStyle(fontWeight: FontWeight.bold)); //太文字);
    }

    for (int n = 0; n < i; n++) {
      if (eventDetailList["postalNumber"][i] +
              eventDetailList["prefecture"][i] +
              eventDetailList["city"][i] +
              eventDetailList["houseNumber"][i] !=
          eventDetailList["postalNumber"][n] +
              eventDetailList["prefecture"][n] +
              eventDetailList["city"][n] +
              eventDetailList["houseNumber"][n]) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
          children: [
            SizedBox(
              height: height,
            ),
            Text(
                eventDetailList["postalNumber"][i] +
                    "〒" +
                    "   " +
                    eventDetailList["prefecture"][i] +
                    eventDetailList["city"][i] +
                    eventDetailList["houseNumber"][i],
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      }
    }

    return const SizedBox();
  }

  int review_point = 1;
  String title = "";
  String detail = "";

  //タイトル入力時の処理
  void titleWrite(text) {
    setState(() {
      if (text != "") {
        title = text;
      }
    });
  }

  //詳細入力時の処理
  void detailWrite(text) {
    setState(() {
      if (text != "") {
        detail = text;
      }
    });
  }

  //レビュー
  Future reviewWrite(int id, ChangeGeneralCorporation store) async {
    Uri url =
        Uri.parse('${ChangeGeneralCorporation.apiUrl}/events/${id}/review');
    final response = await post(url,
        headers: {
          'accept': 'application/json',

          //'Authorization': 'Bearer ${store.accessToken}'
          'authorization': 'Bearer ${store.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'review': detail,
          'review_point': review_point,
        }));
    if (response.statusCode == 200) {
      getEventList(widget.id, widget.tStore);
    } else {
      setState(() {
        notEventJedge = true;
      });
    }
  }

  //レビュー削除
  Future reviewDelite(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/events/${id}/review?user_id=${store.myID}');
    final response = await delete(url, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${store.accessToken}',
    });
    if (response.statusCode == 200) {
      getEventList(widget.id, widget.tStore);
    } else {
      setState(() {
        notEventJedge = true;
      });
    }
  }

  //レビュー編集
  Future reviewEdit(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/events/${id}/review?user_id=${store.myID}');
    final response = await put(url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${store.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'review': detail,
          'review_point': review_point,
        }));
    if (response.statusCode == 200) {
      getEventList(widget.id, widget.tStore);
    } else {
      setState(() {
        notEventJedge = true;
      });
    }
  }

  final List<bool> _isSelected = [
    true,
    false,
    false,
    false,
    false
  ]; //星の色を変えるための変数

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得

    //横画面サイズにより幅設定
    double widthBlank = (mediaQueryData.size.width / 2) - 300;
    if (widthBlank < 0) {
      widthBlank = 0;
    }
    //double blank = mediaQueryData.size.width / 20;
    double width = mediaQueryData.size.width - (widthBlank * 2);
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return notEventJedge || widget.notEventJedge
        ? const Scaffold(
            //アップバー
            appBar: TitleAppBar(
              title: "イベントが存在しません",
              jedgeBuck: true,
            ),
            body: Center(child: Text("対象イベントページは削除されました。")),
          )
        : Scaffold(
            //アップバー
            appBar: DetailAppbar(
              postJedge: eventDetailList["postJedge"],
              eventJobJedge: "event",
              postTerm: eventDetailList["postTerm"],
              mediaQueryData: mediaQueryData,
              notPostJedge: eventDetailList["notPost"],
              id: eventDetailList["id"],
              callback: () => "",
            ),
            //body
            body: ShaderMaskComponent(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: width + widthBlank / 10,
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Color.fromARGB(255, 207, 207, 207),
                          width: 2,
                        ),
                        left: BorderSide(
                          color: Color.fromARGB(255, 207, 207, 207),
                          width: 2,
                        ),
                      ), // 枠線の幅を設定
                    ),
                    child: Center(
                      child: SizedBox(
                        width: width,
                        child: Column(
                          children: [
                            //空白
                            SizedBox(
                              height: mediaQueryData.size.height / 50,
                            ),
                            //画像
                            SizedBox(
                                height: width * 0.6,
                                width: width,
                                child: ClipRRect(
                                  // これを追加
                                  borderRadius:
                                      BorderRadius.circular(10), // これを追加
                                  child: Image.network(
                                      eventDetailList["image_url"].toString(),
                                      fit: BoxFit.cover),
                                )),
                            //タイトル
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //タイトル
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    eventDetailList["title"],
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                //お気に入りボタン
                                Row(
                                  children: [
                                    ToggleButtons(
                                      borderWidth: 0.01, // 枠線をなくす
                                      color: Colors.grey[500], //選択していない時の色
                                      selectedColor: store.mainColor, //選択時の色
                                      fillColor: Colors.white, //選択時の背景色
                                      splashColor: store.subColor, //選択時のアクションの色
                                      borderRadius:
                                          BorderRadius.circular(50.0), //角丸
                                      isSelected: [
                                        eventDetailList["favoriteJedge"]
                                      ], //on off
                                      //ボタンを押した時の処理
                                      onPressed: (int index) => setState(() {
                                        boobkmark(eventDetailList["id"], store);
                                      }),
                                      //アイコン
                                      children: <Widget>[
                                        eventDetailList["favoriteJedge"]
                                            ? const Icon(Icons.favorite,
                                                size: 40)
                                            : const Icon(Icons.favorite_border,
                                                size: 40),
                                      ],
                                    ),
                                    //空白
                                    SizedBox(
                                      width: width / 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //ハッシュタグ
                            if (eventDetailList["tag"].length != 0)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: width, // 最小幅をwidthに設定
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start, // 子ウィジェットを左詰めに配置
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < eventDetailList["tag"].length;
                                          i++)
                                        TextButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    SearchPage(
                                                  text:
                                                      "#${eventDetailList["tag"][i]["name"]}",
                                                  eventJobJedge: "おすすめイベント",
                                                  sort: "新着順",
                                                  sortType: "id",
                                                  store: store,
                                                ),
                                              ),
                                            );
                                            getEventList(
                                                widget.id, widget.tStore);
                                          },
                                          child: Text(
                                              "#${eventDetailList["tag"][i]["name"]}"),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                            //空白
                            SizedBox(
                              height: mediaQueryData.size.height / 200,
                            ),

                            //イベント詳細
                            SizedBox(
                              width: width - 20,
                              child: Text(eventDetailList["detail"]),
                            ),

                            //空白
                            SizedBox(
                              height: mediaQueryData.size.height / 50,
                            ),

                            //イベント開催場所・日時
                            SizedBox(
                              width: width - 20,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                                children: [
                                  const Text(
                                    "開催場所・日時",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  //空白
                                  SizedBox(
                                    height: mediaQueryData.size.height / 100,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // 子ウィジェットを左詰めに配置
                                    children: [
                                      generateWidgets(
                                          0, mediaQueryData.size.height / 100),
                                      for (int i = 0;
                                          i <
                                              eventDetailList["eventTimes"]
                                                  .length;
                                          i++)
                                        Text(
                                            "${eventDetailList["eventTimes"][i]["start_time"].substring(0, 4)}年${eventDetailList["eventTimes"][i]["start_time"].substring(5, 7)}月${eventDetailList["eventTimes"][i]["start_time"].substring(8, 10)}日 ${eventDetailList["eventTimes"][i]["start_time"].substring(11, 16)}~${eventDetailList["eventTimes"][i]["end_time"].substring(11, 16)}"),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            //空白
                            SizedBox(
                              height: mediaQueryData.size.height / 50,
                            ),

                            //イベント詳細
                            //任意入力が一つでもある場合のみ表示
                            if (eventDetailList["phone"] != "" ||
                                eventDetailList["mail"] != "" ||
                                eventDetailList["url"] != "" ||
                                eventDetailList["fee"] != "" ||
                                eventDetailList["Capacity"] != "" ||
                                eventDetailList["notes"] != "" ||
                                eventDetailList["addMessage"] != "")
                              SizedBox(
                                width: width - 20,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // 子ウィジェットを左詰めに配置
                                    children: [
                                      const Text(
                                        "イベント詳細",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      //空白
                                      SizedBox(
                                        height:
                                            mediaQueryData.size.height / 100,
                                      ),
                                      //イベント参加費
                                      if (eventDetailList["fee"] != "")
                                        Text("参加費：${eventDetailList["fee"]}円"),
                                      //定員
                                      if (eventDetailList["Capacity"] != "")
                                        Text(
                                            "定員：${eventDetailList["Capacity"]}人"),

                                      //空白
                                      SizedBox(
                                        height:
                                            mediaQueryData.size.height / 200,
                                      ),

                                      //電話番号
                                      if (eventDetailList["phone"] != "")
                                        Text(
                                            "電話番号：${eventDetailList["phone"]}"),
                                      //メールアドレス
                                      if (eventDetailList["mail"] != "")
                                        Text(
                                            "メールアドレス：${eventDetailList["mail"]}"),
                                      //URL
                                      if (eventDetailList["url"] != "")
                                        Text("URL：${eventDetailList["url"]}"),

                                      //空白
                                      SizedBox(
                                        height: mediaQueryData.size.height / 50,
                                      ),

                                      //注意事項
                                      if (eventDetailList["notes"] != "")
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // 子ウィジェットを左詰めに配置
                                          children: [
                                            const Text("注意事項："),
                                            Text(eventDetailList["notes"]),
                                          ],
                                        ),

                                      //空白
                                      SizedBox(
                                        height: mediaQueryData.size.height / 50,
                                      ),

                                      //追加メッセージ
                                      if (eventDetailList["addMessage"] != "")
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // 子ウィジェットを左詰めに配置
                                          children: [
                                            const Text("追加メッセージ："),
                                            Text(eventDetailList["addMessage"]),
                                          ],
                                        ),
                                      //空白
                                      SizedBox(
                                        height: mediaQueryData.size.height / 50,
                                      ),
                                    ]),
                              ),
                            //空白
                            SizedBox(
                              height: mediaQueryData.size.height / 30,
                            ),

                            //レビュー
                            SizedBox(
                                width: width - 20,
                                //height: 400,
                                //color: Colors.blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // 子ウィジェットを左詰めに配置
                                  children: [
                                    //タイトル
                                    const Text(
                                      "評価とレビュー",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: width / 20), //空白

                                    Row(
                                      children: [
                                        SizedBox(width: width / 15), //空白
                                        //平均評価
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${eventDetailList["reviewPoint"].toString()} ",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: width / 8,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration
                                                    .underline, //下線
                                                decorationThickness:
                                                    2, // 下線の太さの設定
                                                decorationColor:
                                                    Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              " 5段階評価中",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: width / 35,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),

                                        SizedBox(width: width / 9), //空白

                                        //評価分布
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            for (int i = 4; i >= 0; i--)
                                              Row(
                                                children: [
                                                  Text(
                                                    "${i + 1} ",
                                                    style: TextStyle(
                                                      fontSize: width / 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Stack(children: [
                                                    Container(
                                                      height: width / 40,
                                                      width: width / 2,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: width / 40,
                                                      width: width /
                                                          2 *
                                                          eventDetailList[
                                                              "ratioStarReviews"][i],
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[800],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    )
                                                  ])
                                                ],
                                              ),
                                            Text(
                                                "${eventDetailList["reviewNumber"]}件のレビュー")
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: width / 20), //空白

                                    Center(
                                      child: TextButton(
                                        child: Text('タップして評価    ★★★★★',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: width / 25,
                                                fontWeight: FontWeight.bold)),
                                        //評価ポップアップ
                                        onPressed: () {
                                          //_isSelected初期化
                                          _isSelected[0] = true;
                                          for (int buttonIndex = 1;
                                              buttonIndex < 5;
                                              buttonIndex++) {
                                            _isSelected[buttonIndex] = false;
                                          }
                                          if (!eventDetailList["postJedge"]) {
                                            //投稿済み
                                            if (eventDetailList["reviewId"] !=
                                                0) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('投稿済みです'),
                                                    content: const Text(
                                                        'このイベント広告にはレビューを投稿済みです。'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child:
                                                            const Text('閉じる'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                            //未投稿
                                            else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        '評価を選択してください'),
                                                    content: SizedBox(
                                                      width: width * 0.7,
                                                      height: 400,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              "※レビューは一般公開され、あなたのアカウント情報が含まれます",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                          .grey[
                                                                      600])),
                                                          //空白
                                                          SizedBox(
                                                              height:
                                                                  width / 40),
                                                          //動的に星の色を変える
                                                          StatefulBuilder(
                                                            builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setState) =>
                                                                ToggleButtons(
                                                              fillColor: Colors
                                                                  .white, //選択中の色
                                                              borderWidth:
                                                                  0, //枠線の太さ
                                                              borderColor: Colors
                                                                  .white, //枠線の色
                                                              selectedBorderColor:
                                                                  Colors
                                                                      .white, //選択中の枠線の色,

                                                              onPressed:
                                                                  (int index) {
                                                                setState(() {
                                                                  review_point =
                                                                      index + 1;
                                                                  for (int buttonIndex =
                                                                          0;
                                                                      buttonIndex <=
                                                                          index;
                                                                      buttonIndex++) {
                                                                    _isSelected[
                                                                            buttonIndex] =
                                                                        true;
                                                                  }
                                                                  for (int buttonIndex =
                                                                          index +
                                                                              1;
                                                                      buttonIndex <
                                                                          5;
                                                                      buttonIndex++) {
                                                                    _isSelected[
                                                                            buttonIndex] =
                                                                        false;
                                                                  }
                                                                });
                                                              },

                                                              isSelected:
                                                                  _isSelected,
                                                              children:
                                                                  List.generate(
                                                                5,
                                                                (index) => Icon(
                                                                  Icons.star,
                                                                  color: _isSelected[
                                                                          index]
                                                                      ? Colors.yellow[
                                                                          800]
                                                                      : Colors
                                                                          .grey,
                                                                  size: 35,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //タイトル
                                                          SizedBox(
                                                              height:
                                                                  width / 40),
                                                          SizedBox(
                                                            width: width,
                                                            child: const Text(
                                                                "タイトル",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Container(
                                                              width: width,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        203,
                                                                        202,
                                                                        202),
                                                                    width: 1.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child:
                                                                      TextField(
                                                                    maxLines:
                                                                        null,
                                                                    maxLength:
                                                                        50,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      //counterText: '',
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          'ここに入力',
                                                                    ),
                                                                    onChanged: (text) =>
                                                                        titleWrite(
                                                                            text),
                                                                  ),
                                                                ),
                                                              )),
                                                          //詳細
                                                          //空白
                                                          SizedBox(
                                                              height:
                                                                  width / 40),
                                                          SizedBox(
                                                            width: width,
                                                            child: const Text(
                                                                "詳細",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          Container(
                                                              width: width,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        203,
                                                                        202,
                                                                        202),
                                                                    width: 1.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child:
                                                                      TextField(
                                                                    maxLines:
                                                                        null,
                                                                    maxLength:
                                                                        500,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      hintText:
                                                                          'ここに入力',
                                                                    ),
                                                                    onChanged: (text) =>
                                                                        detailWrite(
                                                                            text),
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('投稿'),
                                                        onPressed: () {
                                                          //Navigator.of(context).pop();
                                                          if (title == "" ||
                                                              detail == "") {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      '未入力の項目があります'),
                                                                  content:
                                                                      const Text(
                                                                          'タイトルと詳細を入力してください'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: const Text(
                                                                          '閉じる'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          } else
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                          '投稿確認'),
                                                                  content:
                                                                      const Text(
                                                                          'この内容で投稿しますか？'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: const Text(
                                                                          '投稿'),
                                                                      onPressed:
                                                                          () {
                                                                        reviewWrite(
                                                                            eventDetailList["id"],
                                                                            store);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: const Text('投稿完了'),
                                                                              content: const Text('投稿が完了しました'),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  child: const Text('閉じる'),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: const Text(
                                                                          'キャンセル'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('閉じる'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('投稿できません'),
                                                  content: const Text(
                                                      '自分のイベント広告にはレビューを投稿できません。'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('閉じる'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                    SizedBox(height: width / 20), //空白

                                    //レビューがない場合
                                    if (eventDetailList["review"].length == 0)
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(30.0),
                                          child: Text("レビューはまだありません"),
                                        ),
                                      ),

                                    //仕切り線
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey[400]!, //枠線の色
                                              width: 0.7, //枠線の太さ
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //レビュー本体
                                    SizedBox(
                                      //height: (160 * eventDetailList["review"].length).toDouble(),
                                      child: Column(
                                        children: [
                                          for (int index = 0;
                                              index <
                                                  eventDetailList["review"]
                                                      .length;
                                              index++)
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                    minHeight: 150, //最小の高さ
                                                  ),
                                                  child: Container(
                                                    //height: 150,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          color: Colors.grey[
                                                              400]!, //枠線の色
                                                          width: 0.7, //枠線の太さ
                                                        ),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //ユーザー情報
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            //ユーザー画像
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    // これを追加
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50), // これを追加
                                                                    child: Image.network(
                                                                        "${eventDetailList["review"][index]["user"]["image_url"]}",
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: width /
                                                                        50), //空白
                                                                //ユーザー名
                                                                Text(eventDetailList["review"]
                                                                            [
                                                                            index]
                                                                        ["user"]
                                                                    [
                                                                    "username"]),
                                                              ],
                                                            ),

                                                            //通報ボタン===================================================================
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    for (int buttonIndex =
                                                                            0;
                                                                        buttonIndex <=
                                                                            eventDetailList["review"][index]["review_point"] -
                                                                                1;
                                                                        buttonIndex++) {
                                                                      _isSelected[
                                                                              buttonIndex] =
                                                                          true;
                                                                    }
                                                                  });
                                                                  final TextEditingController
                                                                      titleController =
                                                                      TextEditingController(
                                                                          text: eventDetailList["review"][index]
                                                                              [
                                                                              "title"]);
                                                                  final TextEditingController
                                                                      detailController =
                                                                      TextEditingController(
                                                                          text: eventDetailList["review"][index]
                                                                              [
                                                                              "review"]);
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return SimpleDialog(
                                                                        // title: const Text(
                                                                        //   "通報",
                                                                        //   style: TextStyle(
                                                                        //       fontWeight:
                                                                        //           FontWeight.bold),
                                                                        // ),
                                                                        children: [
                                                                          if (eventDetailList["review"][index]["user"]["id"] ==
                                                                              store.myID)
                                                                            Center(
                                                                              child: SizedBox(
                                                                                width: width / 2,
                                                                                child: const Text(
                                                                                  "編集・削除",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (eventDetailList["review"][index]["user"]["id"] ==
                                                                              store.myID)
                                                                            SimpleDialogOption(
                                                                              onPressed: () => {
                                                                                Navigator.pop(context),
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: const Text('評価を選択してください'),
                                                                                      content: SizedBox(
                                                                                        width: width * 0.7,
                                                                                        height: 400,
                                                                                        child: Column(
                                                                                          children: [
                                                                                            Text("※レビューは一般公開され、あなたのアカウント情報が含まれます", style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                                                                                            //空白
                                                                                            SizedBox(height: width / 40),
                                                                                            //動的に星の色を変える
                                                                                            StatefulBuilder(
                                                                                              builder: (BuildContext context, StateSetter setState) => ToggleButtons(
                                                                                                fillColor: Colors.white, //選択中の色
                                                                                                borderWidth: 0, //枠線の太さ
                                                                                                borderColor: Colors.white, //枠線の色
                                                                                                selectedBorderColor: Colors.white, //選択中の枠線の色,

                                                                                                onPressed: (int index) {
                                                                                                  setState(() {
                                                                                                    review_point = index + 1;
                                                                                                    for (int buttonIndex = 0; buttonIndex <= index; buttonIndex++) {
                                                                                                      _isSelected[buttonIndex] = true;
                                                                                                    }
                                                                                                    for (int buttonIndex = index + 1; buttonIndex < 5; buttonIndex++) {
                                                                                                      _isSelected[buttonIndex] = false;
                                                                                                    }
                                                                                                  });
                                                                                                },

                                                                                                isSelected: _isSelected,
                                                                                                children: List.generate(
                                                                                                  5,
                                                                                                  (index) => Icon(
                                                                                                    Icons.star,
                                                                                                    color: _isSelected[index] ? Colors.yellow[800] : Colors.grey,
                                                                                                    size: 35,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            //タイトル
                                                                                            SizedBox(height: width / 40),
                                                                                            SizedBox(
                                                                                              width: width,
                                                                                              child: const Text("タイトル", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                            ),
                                                                                            Container(
                                                                                                width: width,
                                                                                                height: 100,
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(color: const Color.fromARGB(255, 203, 202, 202), width: 1.5),
                                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                                ),
                                                                                                child: SingleChildScrollView(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.all(8.0),
                                                                                                    child: TextField(
                                                                                                      controller: titleController,
                                                                                                      maxLines: null,
                                                                                                      maxLength: 50,
                                                                                                      style: const TextStyle(fontSize: 13),
                                                                                                      decoration: const InputDecoration(
                                                                                                        //counterText: '',
                                                                                                        border: InputBorder.none,
                                                                                                        hintText: 'ここに入力',
                                                                                                      ),
                                                                                                      onChanged: (text) => titleWrite(text),
                                                                                                    ),
                                                                                                  ),
                                                                                                )),
                                                                                            //詳細
                                                                                            //空白
                                                                                            SizedBox(height: width / 40),
                                                                                            SizedBox(
                                                                                              width: width,
                                                                                              child: const Text("詳細", style: TextStyle(fontWeight: FontWeight.bold)),
                                                                                            ),
                                                                                            Container(
                                                                                                width: width,
                                                                                                height: 100,
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(color: const Color.fromARGB(255, 203, 202, 202), width: 1.5),
                                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                                ),
                                                                                                child: SingleChildScrollView(
                                                                                                  child: Padding(
                                                                                                    padding: EdgeInsets.all(8.0),
                                                                                                    child: TextField(
                                                                                                      controller: detailController,
                                                                                                      maxLines: null,
                                                                                                      maxLength: 500,
                                                                                                      style: const TextStyle(fontSize: 13),
                                                                                                      decoration: const InputDecoration(
                                                                                                        border: InputBorder.none,
                                                                                                        hintText: 'ここに入力',
                                                                                                      ),
                                                                                                      onChanged: (text) => detailWrite(text),
                                                                                                    ),
                                                                                                  ),
                                                                                                )),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      actions: <Widget>[
                                                                                        TextButton(
                                                                                          child: const Text('編集'),
                                                                                          onPressed: () {
                                                                                            //Navigator.of(context).pop();
                                                                                            if (title == "" || detail == "") {
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    title: const Text('未入力の項目があります'),
                                                                                                    content: const Text('タイトルと詳細を入力してください'),
                                                                                                    actions: <Widget>[
                                                                                                      TextButton(
                                                                                                        child: const Text('閉じる'),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            } else
                                                                                              showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    title: const Text('編集確認'),
                                                                                                    content: const Text('この内容で編集しますか？'),
                                                                                                    actions: <Widget>[
                                                                                                      TextButton(
                                                                                                        child: const Text('編集'),
                                                                                                        onPressed: () {
                                                                                                          reviewEdit(eventDetailList["id"], store);
                                                                                                          Navigator.of(context).pop();
                                                                                                          Navigator.of(context).pop();
                                                                                                          showDialog(
                                                                                                            context: context,
                                                                                                            builder: (BuildContext context) {
                                                                                                              return AlertDialog(
                                                                                                                title: const Text('編集完了'),
                                                                                                                content: const Text('編集が完了しました'),
                                                                                                                actions: <Widget>[
                                                                                                                  TextButton(
                                                                                                                    child: const Text('閉じる'),
                                                                                                                    onPressed: () {
                                                                                                                      Navigator.of(context).pop();
                                                                                                                    },
                                                                                                                  ),
                                                                                                                ],
                                                                                                              );
                                                                                                            },
                                                                                                          );
                                                                                                        },
                                                                                                      ),
                                                                                                      TextButton(
                                                                                                        child: const Text('キャンセル'),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                          },
                                                                                        ),
                                                                                        TextButton(
                                                                                          child: const Text('閉じる'),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                )
                                                                              },
                                                                              child: const Text("レビューを編集"),
                                                                            ),
                                                                          if (eventDetailList["review"][index]["user"]["id"] ==
                                                                              store.myID)
                                                                            SimpleDialogOption(
                                                                              onPressed: () => {
                                                                                reviewDelite(eventDetailList["id"], store),
                                                                                Navigator.pop(context),
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: const Text('レビュー削除'),
                                                                                      content: const Text('レビューの削除をしました。'),
                                                                                      actions: <Widget>[
                                                                                        TextButton(
                                                                                          child: const Text('閉じる'),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                )
                                                                              },
                                                                              child: const Text("レビューを削除"),
                                                                            ),
                                                                          Center(
                                                                            child:
                                                                                SizedBox(
                                                                              width: width / 2,
                                                                              child: const Text(
                                                                                "通報",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SimpleDialogOption(
                                                                            onPressed: () =>
                                                                                {
                                                                              Navigator.pop(context),
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text('通報完了'),
                                                                                    content: const Text('不適切なレビューとして報告が完了しました'),
                                                                                    actions: <Widget>[
                                                                                      TextButton(
                                                                                        child: const Text('閉じる'),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              )
                                                                            },
                                                                            child:
                                                                                const Text("不適切なレビューとして報告"),
                                                                          ),
                                                                          SimpleDialogOption(
                                                                            onPressed: () =>
                                                                                {
                                                                              Navigator.pop(context),
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text('通報完了'),
                                                                                    content: const Text('スパムとして報告が完了しました'),
                                                                                    actions: <Widget>[
                                                                                      TextButton(
                                                                                        child: const Text('閉じる'),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).pop();
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              )
                                                                            },
                                                                            child:
                                                                                const Text("スパムとして報告"),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .more_vert,
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height: width /
                                                                60), //空白
                                                        Text(
                                                            eventDetailList[
                                                                    "review"][
                                                                index]["title"],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                            height: width /
                                                                60), //空白
                                                        //評価
                                                        Row(
                                                          children: [
                                                            //星(色あり)
                                                            for (int i = 0;
                                                                i <
                                                                    eventDetailList["review"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "review_point"];
                                                                i++)
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                        .yellow[
                                                                    800],
                                                                size: 15,
                                                              ),
                                                            //星(色なし)
                                                            for (int i = 0;
                                                                i <
                                                                    5 -
                                                                        eventDetailList["review"][index]
                                                                            [
                                                                            "review_point"];
                                                                i++)
                                                              Icon(Icons.star,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  size: 15),
                                                            SizedBox(
                                                                width: width /
                                                                    60), //空白
                                                            //評価日時放置
                                                            Text(
                                                                "${eventDetailList["review"][index]["updated_at"].substring(0, 4)}年${eventDetailList["review"][index]["updated_at"].substring(5, 7)}月${eventDetailList["review"][index]["updated_at"].substring(8, 10)}日",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                            .grey[
                                                                        500])),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height: width /
                                                                60), //空白
                                                        //レビュー内容
                                                        Text(eventDetailList[
                                                                "review"][index]
                                                            ["review"]),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
