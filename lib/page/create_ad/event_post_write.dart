// import 'dart:ffi';

import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
// import 'testinsert.dart';
// import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import 'done.dart';
import 'package:flutter/cupertino.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:reelproject/overlay/rule/screen/return_write.dart';
import 'package:reelproject/page/create_ad/post_write_comp_ev.dart';
import 'dart:convert';
import 'post_write_comp.dart';
// import 'text_add.dart';
import 'package:reelproject/overlay/rule/screen/image_over.dart';
import 'package:reelproject/overlay/rule/screen/post_comf_over.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
//job_fee_watch.dartからのimport
import 'package:reelproject/page/create_ad/fee_watch.dart';

class EventPostWrite extends StatefulWidget {
  final int planId;
  final int planPeriod;
  const EventPostWrite({
    super.key,
    required this.planId,
    required this.planPeriod,
  });

  @override
  EventPostWriteState createState() => EventPostWriteState();
}

class EventPostWriteState extends State<EventPostWrite> {
  late int planId;
  late int planPeriod;
  @override
  void initState() {
    super.initState();
    planId = widget.planId;
    planPeriod = widget.planPeriod;
  }

  String hyoji_text = "";
  String imageJudge = "";
  String selectedValue = "短期";
  final lists = ["長期", "短期"];
  String selectedPrace = "無料";
  final listPrace = ["有料", "無料"];
  bool praceInput = false;
  List<String> todoList = [];
  List<String> shortageList = [];
  var feeController = TextEditingController();

// 郵便番号関連------------------
  String firstNumber = ""; // 最初の3桁
  String backNumber = ""; // 後半の4桁
  String addressNum = ""; // 郵便番号

// 住所関連------------------
  final prefecture = TextEditingController(); // 都道府県
  final city = TextEditingController(); // 市町村
  final houseNumber = TextEditingController(); // 番地・建物名

// 電話番号関連------------------
  String firstPhone = ""; // 最初の4桁
  String centralPhone = ""; // 中央の2桁
  String backPhone = ""; // 後半の4桁
  String phoneNumber = ""; // 電話番号

// マップで送られる要素-------------------------------------
  String postTitle = ""; // 広告のタイトル
  String detail = ""; // 広告詳細説明
  String term = ""; // 勤務体系
  bool isOneDay = true; // false=長期, true=短期
  List day = []; // 日付
  List time = []; // 時間
  String posAddressNum = ""; // 郵便番号
  String posPrefecture = ""; // 都道府県
  String posCity = ""; // 市町村
  String posHouseNumber = ""; // 番地・建物名
  String fee = ""; // 給料
  String additionalMessage = ""; // 追加メッセージ
  String caution = ""; // 注意事項
  String email = ""; // メールアドレス
  String homepage = ""; // ホームページ
  int capacity = 0; // 定員

// -------------------------------------------------

  bool deleteList = false; // Listを削除するかどうか

// 日時関連-------------------------------------------------
  List<Map<String, dynamic>> jobTimes = []; // シフト時間を入れるリスト
  List<Map<String, dynamic>> jobLong = []; // シフト時間を入れるリスト(長期)
  List<Map<String, dynamic>> eventTime = []; // シフト時間を入れるリスト(短期)
  List<Map<String, dynamic>> posEventTimes = []; // シフト時間を入れるリストdbに送る用
  List<Map<String, dynamic>> posJobLong = []; // シフト時間を入れるリスト(長期)dbに送る用
  List<Map<String, dynamic>> poseventTime = []; // シフト時間を入れるリスト(短期)dbに送る用
  String daytime = ""; // 勤務時間をまとめる(日+時間)
  String dDay = ""; // 勤務時間をまとめる(日)
  String dTime = ""; // 勤務時間をまとめる(時間)
  String inYear = ""; // 年
  String inMonth = ""; // 月
  String inDay = ""; // 日
  String stTime = ""; // 勤務時間（start時）
  String stMinute = ""; // 勤務時間（start分）
  String finTime = ""; // 勤務時間（finish時）
  String finMinute = ""; // 勤務時間（finish分）

// ----------------------------------------------------

// タグ関連--------------------------------------------
  List<Map<String, dynamic>> tagname = []; // タグ情報が入っている
  int tagLength = 0; // tagname内の要素数を記録
  bool tagNotInput = false; // タグが入力可能でないかの判断
  String tagName = ""; // タグの名前を一時保存する場所
  final textFieldController = TextEditingController(); // 入力内の取り消しなどを行うためのもの
// -------------------------------------------------

// 確認へと送る写真--------------------------------
  XFile? posImage;
  bool posImageJudge = false; // 画像をDBに送るかの判定
  String? imageUrl = "NO";
// -----------------------------------------------

// エラー文or判定---------------------------------------------
  String errEmail = "";
  bool daytimeSh = false;
  bool shortageErr = false;
  bool phoneSh = false;
  bool addressSh = false;
  String dayErr = "";
  String homepageErr = "";
// -----------------------------------------------

// 広告確認画面へ送るマップ--------------------------------------------------------
// 確認ボタンを押すときにmapをつくりなおしているので，押す前に要素を使わなければエラーは出ないが念のために初期化している
  late Map<String, dynamic> postList;
  EventPostWriteState() {
    postList = {
      "title": postTitle, //タイトル
      //詳細
      "detail": detail, //勤務体系
      "is_one_day": isOneDay,

      "day": ["2021年8月1日", "2021年8月2日", "2021年8月2日"], //日付
      "time": ["10時00分~20時00分", "10時00分~20時00分", "10時00分~20時00分"], //時間

      //開催場所
      "postalNumber": addressNum, //郵便番号
      "prefecture": posPrefecture, //都道府県
      "city": posCity, //市町村
      "houseNumber": posHouseNumber, //番地・建物名

      //給料
      "fee": fee,

      //その他(任意)
      "tag": [
        "イベント",
        "夏祭り",
        "花火",
        "香美市",
        "イベント",
      ], //ハッシュタグ
      "additional_message": "test", //追加メッセージ

      //レビュー
      "reviewPoint": 4.5, //評価
      //星の割合(前から1,2,3,4,5)
      "ratioStarReviews": [0.03, 0.07, 0.1, 0.3, 0.5],
      //レビュー数
      "reviewNumber": 100,
      //レビュー内容
      "review": [
        {
          "reviewerName": "名前aiueo",
          //"reviewerImage" : "test"   //予定
          "reviewPoint": 3, //レビュー点数
          "reviewDetail": "testfffff\n\nfffff", //レビュー内容
          "reviewDate": "2021年8月1日", //レビュー日時
        },
        {
          "reviewerName": "名前kakikukeko",
          //"reviewerImage" : "test"   //予定
          "reviewPoint": 3, //レビュー点数
          "reviewDetail": "test", //レビュー内容
          "reviewDate": "2021年8月1日", //レビュー日時
        },
      ]
    };
  }
// ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    final store = Provider.of<ChangeGeneralCorporation>(context);

    return Scaffold(
      appBar: const TitleAppBar(
        title: "イベント広告作成",
        jedgeBuck: true,
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ElevatedButton(
              //   child: Text('デバイスのライブラリから取得'),
              //   onPressed: () async {
              //     final XFile? image =
              //         await picker.pickImage(source: ImageSource.gallery);
              //     // if (image != null) {
              //     //   setState(() {
              //     //     hyoji_text = text;
              //     //   });
              //     // }
              //     // if (image != null)
              //     //   Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //       builder: (context) => done(image),
              //     //     ),
              //     //   );
              //     if (image != null) {
              //       // int fileSize = await getImageSize(image);

              //       setState(() {
              //         hyoji_text = image.name;
              //         int length = hyoji_text.length;
              //         String judge = hyoji_text.substring(length - 5);
              //         if (judge.contains('.png') ||
              //             judge.contains('.jpeg') ||
              //             judge.contains('.jpg') ||
              //             judge.contains('.JPG')) {
              //           imageJudge = 'OK';
              //         } else {
              //           imageJudge = 'NO';
              //         }

              //         // fileSizeInKB = fileSize; // バイトからキロバイトへ変換
              //       });
              //     }
              //   },
              // ),
              // Text(hyoji_text),
              // Text('File size: $fileSizeInKB KB'),
              // Text(imageJudge),

              const SizedBox(
                height: 40,
              ),
              Stack(children: [
                shortageErr
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter, //下ぞろえ
                            //影
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey, //色
                                  //spreadRadius: 5,//拡散
                                  blurRadius: 5, //ぼかし
                                  offset: Offset(3, 3), //影の位置
                                ),
                              ],
                              color: Colors.white,
                            ),
                            width: 350,
                            height: 100,
                            //height: width * 0.7 / 2.5,
                            child: Column(
                              children: [
                                //上枠
                                Container(
                                  width: 350,
                                  height: 30,
                                  color: const Color.fromARGB(255, 248, 45, 45),
                                  child: const Center(
                                    child: Text("以下の必須項目が抜けています",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ),
                                ),
                                //下文字
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 20, // 最小幅をwidthに設定
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start, // 子ウィジェットを左詰めに配置
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (int i = 0;
                                              i < shortageList.length;
                                              i++)
                                            Text(
                                              "${shortageList[i]}, ",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 240, 160, 85),
                                                  fontSize: 16),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      )
                    : const SizedBox(
                        height: 10,
                      )
              ]),

// ----------写真投稿部分----------------------------------------------------------------------
              Container(
                width: 350,
                height: 230,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    const Icon(Icons.photo_camera,
                        size: 100, color: Color.fromARGB(255, 137, 137, 137)),
                    ElevatedButton(
                      // 背景色
                      style: ElevatedButton.styleFrom(
                          backgroundColor: store.mainColor),
                      child: const Text(
                        'デバイスのライブラリから取得',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        // if (image != null) {
                        //   setState(() {
                        //     hyoji_text = text;
                        //   });
                        // }
                        // if (image != null)
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => done(image),
                        //     ),
                        //   );
                        if (image != null) {
                          setState(() {
                            hyoji_text = image.name;
                            int length = hyoji_text.length;
                            String judge = hyoji_text.substring(length - 5);
                            if (judge.contains('.png') ||
                                judge.contains('.jpeg') ||
                                judge.contains('.jpg') ||
                                judge.contains('.JPG')) {
                              posImage = image;
                              ImageOver().show(
                                context: context,
                                onInputChanged: (value) {
                                  // 入力値が変更されたときの処理
                                  setState(() {
                                    posImageJudge = value;
                                    if (posImageJudge && posImage != null) {
                                      imageJudge = "確認できたお";

                                      // postImage(context, store, posImage)
                                      //     .then((url) {
                                      //   //AWS使用時解放
                                      //   //ここでローディング画面を表示
                                      //   if (url != "failed") {
                                      //     imageUrl = url;
                                      //   } else {
                                      //     imageUrl = "NO";
                                      //   }
                                      // });
                                    } else {
                                      posImage = null;
                                      imageJudge = 'NO';
                                    }
                                  });
                                },
                              );
                            } else {
                              imageJudge = 'NO';
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("オリジナルでないものや\n広告内容に沿わない写真はご遠慮ください",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              // Text(imageJudge), // 確認用

// ----------------------------------------------------------------------------------------------

              const SizedBox(height: 40),
              // 広告名入力欄
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "イベント名",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  textAlign: TextAlign.start,
                  maxLength: 20,
                  onChanged: (value) {
                    setState(() {
                      postTitle = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    hintText: "イベント名",
                    hintStyle: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 詳細入力欄（500文字）
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "イベント詳細情報",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    maxLength: 500,
                    onChanged: (value) {
                      setState(() {
                        detail = value;
                      });
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "ここに入力",
                      counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                    ),
                  ),
                ),
              ),

              // 注意事項入力欄（500文字）
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Text(
                  "注意事項",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    maxLength: 500,
                    onChanged: (value) {
                      setState(() {
                        caution = value;
                      });
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "ここに入力",
                      counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                    ),
                  ),
                ),
              ),

              // 日付設定
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "日付設定",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),

              SizedBox(
                width: 345,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 4,
                        onChanged: (value) {
                          setState(() {
                            inYear = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 年 ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 2,
                        onChanged: (value) {
                          setState(() {
                            inMonth = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 月 ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 2,
                        onChanged: (value) {
                          setState(() {
                            inDay = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 日 ",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: 390,
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 25,
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 2,
                        onChanged: (value) {
                          setState(() {
                            stTime = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 時 ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 2,
                        onChanged: (value) {
                          setState(() {
                            stMinute = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 分 ",
                      style: TextStyle(fontSize: 13),
                    ),
                    const Text(
                      " ～ ",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 2,
                        onChanged: (value) {
                          setState(() {
                            finTime = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 時 ",
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 2,
                        onChanged: (value) {
                          setState(() {
                            finMinute = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " 分 ",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              ElevatedButton(
                  // 背景色
                  style: ElevatedButton.styleFrom(
                      backgroundColor: store.mainColor),
                  child: const Text(
                    "日程を追加",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      if (checkYear(inYear) &&
                          checkDay(inDay) &&
                          checkMonth(inMonth) &&
                          checkDay(stTime) &&
                          checkDay(stMinute) &&
                          checkDay(finTime) &&
                          checkDay(finMinute)) {
                        dayErr = "";

                        //日時分合成
                        dDay = "$inYear年 $inMonth月 $inDay日";
                        dTime = "$stTime時 $stMinute分 ～ $finTime時 $finMinute分";
                        daytime = "$dDay:　$dTime";
                        // 日程追加
                        if (eventTime.length < 5) {
                          String posDaytimeS =
                              "$inYear-$inMonth-$inDay $stTime:$stMinute:00";
                          String posDaytimeE =
                              "$inYear-$inMonth-$inDay $finTime:$finMinute:00";
                          eventTime
                              .add({"start_time": daytime, "end_time": "22"});
                          jobTimes = eventTime;
                          poseventTime.add({
                            "start_time": posDaytimeS,
                            "end_time": posDaytimeE
                          });
                          posEventTimes = poseventTime;
                        }
                      } else {
                        dayErr = "入力に誤りがあります\n（年:４桁, 月:２桁, 日:２桁）\n(時:２桁, 分:２桁)";
                      }

                      // 入力内容リセット
                      //   textFieldController.clear();
                      //   tagName = "";
                      //   tagLength = tagname.length;
                      //   tagNotInput = false;
                      // } else {
                      //   tagNotInput = true;
                      // }
                    });
                  }),

              Text(
                dayErr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),

              const SizedBox(
                height: 15,
              ),

              SizedBox(
                width: 390,
                height: 200,
                child: ListView.builder(
                  itemCount: eventTime.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 235, 235, 235),
                          ),
                          child: Text(eventTime[index]["start_time"]),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              eventTime.removeAt(index);
                              jobTimes = eventTime;
                              poseventTime.removeAt(index);
                              posEventTimes = poseventTime;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 75, 51),
                          ),
                          child: const Text(
                            "削除",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 開催場所設定
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Text(
                  '開催場所設定',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 郵便番号
              const SizedBox(height: 10),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "郵便番号",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            firstNumber = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " - ",
                      style: TextStyle(fontSize: 30),
                    ),
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 4,
                        onChanged: (value) {
                          setState(() {
                            backNumber = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    // 住所検索ボタン
                    ElevatedButton(
                      //背景色
                      style: ElevatedButton.styleFrom(
                          backgroundColor: store.mainColor),
                      child: const Text(
                        '住所を検索',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          addressNum =
                              "$firstNumber$backNumber"; // APIに送る用のアドレス
                          posAddressNum =
                              "$firstNumber-$backNumber"; // 確認画面へと送る(mapに入る)用のアドレス
                        });

                        if (addressNum.length != 7) {
                          // アドレスが７文字であるかの判定
                          return;
                        }
                        final address = await zipCodeToAddress(addressNum);
                        // 返ってきた値がnullなら終了
                        if (address == null) {
                          return;
                        }
                        // 住所が帰ってきたら、addressListの中身を上書きする。
                        setState(() {
                          prefecture.text = address[0];
                          city.text = address[1];
                          houseNumber.text = address[2];
                          posPrefecture = prefecture.text;
                          posCity = city.text;
                          posHouseNumber = houseNumber.text;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // 都道府県
              const SizedBox(height: 20),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "都道府県",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        maxLines: null,
                        maxLength: 10,
                        onChanged: (value) {
                          setState(() {
                            posPrefecture = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                        controller: prefecture,
                      ),
                    ),
                  ],
                ),
              ),

              // 市町村
              const SizedBox(height: 20),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "市町村",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        maxLines: null,
                        maxLength: 20,
                        onChanged: (value) {
                          setState(() {
                            posCity = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                        controller: city,
                      ),
                    ),
                  ],
                ),
              ),

              // 番地・建物名
              const SizedBox(height: 20),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "番地・建物名",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 203, 202, 202),
                        width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    maxLines: null,
                    maxLength: 50,
                    onChanged: (value) {
                      setState(() {
                        posHouseNumber = value;
                      });
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                    ),
                    controller: houseNumber,
                  ),
                ),
              ),

              // 電話番号
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "電話番号",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 3,
                        onChanged: (value) {
                          setState(() {
                            firstPhone = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " - ",
                      style: TextStyle(fontSize: 30),
                    ),
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 4,
                        onChanged: (value) {
                          setState(() {
                            centralPhone = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    const Text(
                      " - ",
                      style: TextStyle(fontSize: 30),
                    ),
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: null,
                        maxLength: 4,
                        onChanged: (value) {
                          setState(() {
                            backPhone = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // メールアドレス
              const SizedBox(height: 40),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Text(
                          "メールアドレス",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("必須",
                            style: TextStyle(
                              color: Colors.red,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 230,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        maxLines: null,
                        maxLength: 30,
                        onChanged: (value) {
                          setState(() {
                            if (checkMail(value)) {
                              errEmail = "";
                              email = value;
                            } else {
                              errEmail = "入力が間違っています";
                            }
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    Text(
                      errEmail,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // ホームページ
              const SizedBox(height: 40),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Text(
                          "ホームページ",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("必須",
                            style: TextStyle(
                              color: Colors.red,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 230,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        maxLines: null,
                        maxLength: 50,
                        onChanged: (value) {
                          setState(() {
                            // RegExp regExp = RegExp(
                            //     r'((https?:\/\/)|(https?:www\.)|(www\.))[a-zA-Z0-9-]{1,256}\.[a-zA-Z0-9]{2,6}(\/[a-zA-Z0-9亜-熙ぁ-んァ-ヶ()@:%_\+.~#?&\/=-]*)?');
                            // Iterable<RegExpMatch> matches =
                            //     regExp.allMatches(value);

                            // for (RegExpMatch regExpMatch in matches) {
                            //   // URLを抽出
                            //   homepage = value.substring(
                            //       regExpMatch.start, regExpMatch.end);
                            // }
                            homepage = value;
                            // if (homepage == "") {
                            //   homepageErr = "入力に誤りがあります";
                            // } else {
                            //   homepageErr = "";
                            // }
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                    Text(
                      homepageErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),

              // 参加費設定
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Row(
                  children: <Widget>[
                    Text(
                      "イベント参加費",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("必須",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                  children: <Widget>[
                    DropdownButton(
                      value: selectedPrace,
                      items: listPrace.map((String list) {
                        return DropdownMenuItem(
                          value: list,
                          child: Text(list),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPrace = value!;
                          if (selectedPrace == "有料") {
                            praceInput = true;
                            fee = "";
                          } else {
                            feeController.clear();
                            fee = selectedPrace;
                            praceInput = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 230,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: feeController,
                        enabled: praceInput,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLines: null,
                        maxLength: 10,
                        onChanged: (value) {
                          setState(() {
                            fee = value;
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 定員
              const SizedBox(height: 40),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                  children: <Widget>[
                    const Text(
                      '定員',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 230,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            width: 2),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        maxLines: null,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          setState(() {
                            capacity = int.parse(value);
                          });
                        },
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // タグ設定
              const SizedBox(height: 40),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                  children: <Widget>[
                    const Text(
                      "タグ設定",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 350,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 203, 202, 202),
                                  width: 2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextField(
                              controller: textFieldController, // コントローラ設置
                              maxLines: null,
                              maxLength: 10,
                              onChanged: (value) {
                                setState(() {
                                  tagName = value;
                                });
                              },
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText:
                                    '', //maxLengthによる"0/100"の表示を消すための処理
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              //背景色
                              style: ElevatedButton.styleFrom(
                                backgroundColor: store.mainColor,
                              ),
                              child: const Text(
                                "タグを追加",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                setState(() {
                                  if (tagName != "" && tagname.length < 20) {
                                    // タグ追加
                                    tagname.add({"name": tagName});
                                    // 入力内容リセット
                                    textFieldController.clear();
                                    tagName = "";
                                    tagLength = tagname.length;
                                    tagNotInput = false;
                                  } else {
                                    tagNotInput = true;
                                  }
                                });
                              }),
                        ],
                      ),
                    ),
                    Text(
                      checkTagErr(tagNotInput, tagLength),
                      style: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: ListView.builder(
                        itemCount: tagname.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 120,
                                    child: Card(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "#${tagname[index]["name"]}"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        tagname.removeAt(index);
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 75, 51),
                                    ),
                                    child: const Text(
                                      "削除",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 追加メッセージ（500文字）
              const SizedBox(height: 40),
              const SizedBox(
                width: 350,
                child: Text(
                  "追加メッセージ（500文字）",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    maxLength: 500,
                    onChanged: (value) {
                      setState(() {
                        additionalMessage = value;
                      });
                    },
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ここに入力',
                      counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                    ),
                  ),
                ),
              ),

              // 確認とキャンセル
              const SizedBox(
                height: 70,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // ここで角の丸みを設定します
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(150, 50)), // ここでボタンの大きさを設定します
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey), // ここで背景色を設定します
                    ),
                    child: const Text(
                      '広告完成図確認',
                      style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      setState(() {
                        phoneNumber = "$firstPhone-$centralPhone-$backPhone";
                        if (imageUrl == "NO") {
                          imageUrl = null;
                        }
                        if (posAddressNum == "") {
                          posAddressNum = "$firstNumber-$backNumber";
                        }
                        postList = {
                          "name": postTitle,
                          "image_url": imageUrl,
                          "postalNumber": posAddressNum,
                          "prefecture": posPrefecture,
                          "city": posCity,
                          "houseNumber": posHouseNumber,
                          "phone": phoneNumber,
                          "mail": email,
                          "url": homepage,
                          "fee": fee,
                          "Capacity": capacity,
                          "addMessage": additionalMessage,
                          "detail": detail,
                          "notes": caution,
                          "tags": tagname,
                          "eventTimes": posEventTimes
                        };
                      });

                      // Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PostWriteCompEv(
                                eventList: postList,
                                image: posImage,
                              )));
                    },
                  ),
                  //空白
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // ここで角の丸みを設定します
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(150, 50)), // ここでボタンの大きさを設定します
                        backgroundColor: MaterialStateProperty.all<Color>(
                            store.mainColor), // ここで背景色を設定します
                      ),
                      child: const Text(
                        "   投稿する   ",
                        style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                      onPressed: () {
                        bool judgePost;
                        PostComfOver().show(
                          context: context,
                          onInputChanged: (value) {
                            // 入力値が変更されたときの処理
                            setState(() {
                              if (inYear == "" ||
                                  inMonth == "" ||
                                  inDay == "" ||
                                  stTime == "" ||
                                  stMinute == "" ||
                                  finTime == "" ||
                                  finMinute == "") {
                                daytimeSh = true;
                              } else {
                                daytimeSh = false;
                              }
                              if (firstNumber == "" || backNumber == "") {
                                addressSh = true;
                              } else {
                                addressSh = false;
                              }
                              if (firstPhone == "" ||
                                  centralPhone == "" ||
                                  backPhone == "") {
                                phoneSh = true;
                              } else {
                                phoneSh = false;
                              }
                              shortageList = [];
                              shortageList = [
                                if (postTitle == "") "イベント名",
                                if (detail == "") "イベント詳細情報",
                                if (daytimeSh) "日付設定",
                                if (addressSh) "郵便番号",
                                if (posPrefecture == "") "都道府県",
                                if (posCity == "") "市町村",
                                if (posHouseNumber == "") "番地",
                                if (phoneSh) "電話番号",
                                if (email == "") "メールアドレス",
                                if (homepage == "") "ホームページ",
                                if (fee == "") "イベント参加費",
                              ];
                              if (shortageList.isEmpty) {
                                shortageErr = false;
                                judgePost = value;
                                phoneNumber =
                                    "$firstPhone-$centralPhone-$backPhone";
                                if (imageUrl == "NO") {
                                  imageUrl = null;
                                }
                                if (posAddressNum == "") {
                                  posAddressNum = "$firstNumber-$backNumber";
                                }
                                if (judgePost) {
                                  Map<String, dynamic> dbPostList;
                                  dbPostList = {
                                    "purchase": {
                                      "plan_id": planId,
                                      "contract_amount": planPeriod
                                    },
                                    "event": {
                                      "name": postTitle,
                                      "image_url": imageUrl,
                                      "postal_code": posAddressNum,
                                      "prefecture": posPrefecture,
                                      "city": posCity,
                                      "address": posHouseNumber,
                                      "phone_number": phoneNumber,
                                      "email": email,
                                      "homepage": homepage,
                                      "participation_fee": fee,
                                      "capacity": capacity,
                                      "additional_message": additionalMessage,
                                      "description": detail,
                                      "caution": caution,
                                      "tags": tagname,
                                      "event_times": posEventTimes
                                    }
                                  };
                                  createUser(context, store, dbPostList)
                                      .then((success) {
                                    //ここでローディング画面を表示
                                    if (success) {
                                      Navigator.pop(context); //pop
                                      Navigator.push(
                                        context,
                                        // MaterialPageRoute(builder: (context) => Home()),
                                        MaterialPageRoute(
                                            builder: (context) => JobFeeWatch(
                                                  planId: planId,
                                                  planPeriod: planPeriod,
                                                  eventJobJedge: false,
                                                  botommBarJedge: true,
                                                )),
                                      );
                                    }
                                  });
                                }
                              } else {
                                ReturnWrite().show(context: context);
                                shortageErr = true;
                              }
                            });
                          },
                        );
                      }),
                ],
              ),

              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// APIによる住所取得
Future<List<String>?> zipCodeToAddress(String zipCode) async {
  if (zipCode.length != 7) {
    return null;
  }
  final response = await get(
    Uri.parse(
      'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode',
    ),
  );
  // 正常なステータスコードが返ってきているか
  if (response.statusCode != 200) {
    return null;
  }
  // ヒットした住所はあるか
  final result = jsonDecode(response.body);
  if (result['results'] == null) {
    return null;
  }
  final addressMap =
      (result['results'] as List).first; // 結果が2つ以上のこともあるが、簡易的に最初のひとつを採用することとする。
  // final address =
  //     '${addressMap['address1']} ${addressMap['address2']} ${addressMap['address3']}'; // 住所を連結する。
  String address1 = addressMap['address1'];
  String address2 = addressMap['address2'];
  String address3 = addressMap['address3'];
  final addresses = <String>[address1, address2, address3];

  return addresses;
}

String checkTagErr(bool tagNotInput, int tagLength) {
  //性別の正規表現
  if (tagNotInput) {
    if (tagLength == 20) {
      return "設定可能なタグ数が最大です（最大２０個）";
    } else {
      return "タグ名を入力してください";
    }
  }
  return "";
}

Future<bool> createUser(
  BuildContext context,
  final store,
  Map<String, dynamic> eventList,
) async {
  Uri url =
      Uri.parse("${ChangeGeneralCorporation.apiUrl}/events/purchase-event");

  try {
    final response = await post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ${store.accessToken}',
        'accept': 'application/json',
      },
      body: jsonEncode(eventList),
    );

    if (response.statusCode == 200) {
      return true; // 成功時は true を返す
    } else {
      return false; // 仮置き
      // final Map<String, dynamic> data = json.decode(response.body);

      // if (data["detail"] == "Username already registered") {
      //   // 既にユーザー名が登録されている場合//pop

      //   Navigator.pop(context);
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text('エラー'),
      //         content: const Text('登録予定のユーザー名は既に登録されています'),
      //         actions: <Widget>[
      //           TextButton(
      //             child: const Text('OK'),
      //             onPressed: () => Navigator.pop(context),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      //   return false; // エラー時は false を返す
      // } else if (data["detail"] == "Email already registered") {
      //   // 既にメールアドレスが登録されている場合
      //   Navigator.pop(context); //
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text('エラー'),
      //         content: const Text('登録予定のメールアドレスは既に登録されています'),
      //         actions: <Widget>[
      //           TextButton(
      //             child: const Text('OK'),
      //             onPressed: () => Navigator.pop(context),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      //   return false; // エラー時は false を返す
      // } else {
      //   // その他のエラーの場合
      //   return false; // エラー時は false を返す
      // }
    }
  } catch (error) {
    // 通信エラーなどの例外が発生した場合
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: const Text('通信エラーが発生しました'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
    return false; // エラー時は false を返す
  }
}

Future<String> postImage(
  BuildContext context,
  final store,
  XFile? image,
  // Map<String, dynamic> jobList,
) async {
  Uri url = Uri.parse("${ChangeGeneralCorporation.apiUrl}/upload-image");

  try {
    // final response = await post(
    //   url,
    //   headers: {
    //     'Content-Type': 'multipart/from-data',
    //     'authorization': 'Bearer ${store.accessToken}',
    //     'accept': 'application/json',
    //   },

    // );
    final test = await image!.readAsBytes();
    final request = MultipartRequest("POST", url);
    request.headers.addAll({"Authorization": 'Bearer ${store.accessToken}'});
    request.files.add(MultipartFile.fromBytes('file', test,
        filename: image.name,
        contentType: MediaType.parse("multipart/form-data")));
    final stream = await request.send();

    return Response.fromStream(stream).then((response) {
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        // final data = response.body;
        return data["url"].toString();
      }
      return "failed";
    });
    // if (response.statusCode == 200) {
    //   return true; // 成功時は true を返す
    // } else {
    //   return false; // 仮置き
    // final Map<String, dynamic> data = json.decode(response.body);

    // if (data["detail"] == "Username already registered") {
    //   // 既にユーザー名が登録されている場合//pop

    //   Navigator.pop(context);
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const Text('エラー'),
    //         content: const Text('登録予定のユーザー名は既に登録されています'),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () => Navigator.pop(context),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return false; // エラー時は false を返す
    // } else if (data["detail"] == "Email already registered") {
    //   // 既にメールアドレスが登録されている場合
    //   Navigator.pop(context); //
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const Text('エラー'),
    //         content: const Text('登録予定のメールアドレスは既に登録されています'),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () => Navigator.pop(context),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return false; // エラー時は false を返す
    // } else {
    //   // その他のエラーの場合
    //   return false; // エラー時は false を返す
    // }
    // }
  } catch (error) {
    // 通信エラーなどの例外が発生した場合
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: const Text('通信エラーが発生しました'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
    return "failed"; // エラー時は false を返す
  }
}

bool checkMail(String mail) {
  //メールアドレスの正規表現
  final regEmail = RegExp(
    caseSensitive: false,
    r"^[\w!#$%&'*+/=?`{|}~^-]+(\.[\w!#$%&'*+/=?`{|}~^-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.([A-Za-z]{2,}|\.[A-Za-z]{2}\.[A-Za-z]{2})$",
  );
  return regEmail.hasMatch(mail);
}

bool checkYear(String year) {
  //年の正規表現
  final regYear = RegExp(
    caseSensitive: false,
    r"^[0-9]{4}$",
  );
  return regYear.hasMatch(year);
}

bool checkMonth(String month) {
  //月の正規表現
  final regMonth = RegExp(
    caseSensitive: false,
    r"^[0-9]{2}$",
  );
  return regMonth.hasMatch(month) && int.parse(month) <= 12 && month != '';
}

bool checkDay(String day) {
  //日の正規表現
  final regDay = RegExp(
    caseSensitive: false,
    r"^[0-9]{2}$",
  );
  return regDay.hasMatch(day);
}

bool checkTree(String value) {
  final regDay = RegExp(
    caseSensitive: false,
    r"^[0-9]{3}$",
  );
  return regDay.hasMatch(value);
}
