// // import 'dart:ffi';

// import 'package:http_parser/http_parser.dart';
// import 'package:flutter/material.dart';
// // import 'testinsert.dart';
// // import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// // import 'done.dart';
// import 'package:flutter/cupertino.dart';
// // import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'post_write_comp.dart';
// // import 'text_add.dart';
// import 'package:reelproject/overlay/rule/screen/image_over.dart';
// import 'package:reelproject/overlay/rule/screen/post_comf_over.dart';
// import 'package:provider/provider.dart'; //パッケージをインポート
// import '/provider/change_general_corporation.dart';
// import 'package:reelproject/component/appbar/title_appbar.dart';
// import 'package:reelproject/component/finish_screen/finish_screen.dart';
// import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
// //job_fee_watch.dartからのimport
// import 'package:reelproject/page/create_ad/fee_watch.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'PageView Sample',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text("PageView Sample"),
// //         ),
// //         body: const JobPostWrite(),
// //       ),
// //     );
// //   }
// // }

// class JobPostWrite extends StatefulWidget {
//   final int planId;
//   final int planPeriod;
//   const JobPostWrite({
//     super.key,
//     required this.planId,
//     required this.planPeriod,
//   });

//   @override
//   JobPostWriteState createState() => JobPostWriteState();
// }

// class JobPostWriteState extends State<JobPostWrite> {
//   late int planId;
//   late int planPeriod;
//   @override
//   void initState() {
//     super.initState();
//     planId = widget.planId;
//     planPeriod = widget.planPeriod;
//   }

//   // bool _autoLogin = false; // チェックボックスの状態を管理する変数
//   // String text = "OK";
//   String hyoji_text = "";
//   String imageJudge = "";
//   String selectedValue = "短期";
//   final lists = ["長期", "短期"];
//   String selectedDay = "時給";
//   final listsFee = ["日給", "時給"];
//   List<String> todoList = [];

// // 郵便番号関連------------------
//   String firstNumber = ""; // 最初の3桁
//   String backNumber = ""; // 後半の4桁
//   String addressNum = ""; // 郵便番号

// // 住所関連------------------
//   final prefecture = TextEditingController(); // 都道府県
//   final city = TextEditingController(); // 市町村
//   final houseNumber = TextEditingController(); // 番地・建物名

// // マップで送られる要素-------------------------------------
//   String postTitle = ""; // 広告のタイトル
//   String detail = ""; // 広告詳細説明
//   String term = ""; // 勤務体系
//   bool isOneDay = true; // false=長期, true=短期
//   List day = []; // 日付
//   List time = []; // 時間
//   String posAddressNum = ""; // 郵便番号
//   String posPrefecture = ""; // 都道府県
//   String posCity = ""; // 市町村
//   String posHouseNumber = ""; // 番地・建物名
//   String salary = ""; // 給料
//   String additionalMessage = ""; // 追加メッセージ

// // -------------------------------------------------

//   bool deleteList = false; // Listを削除するかどうか

// // 日時関連-------------------------------------------------
//   List<Map<String, dynamic>> jobTimes = []; // シフト時間を入れるリスト
//   List<Map<String, dynamic>> jobLong = []; // シフト時間を入れるリスト(長期)
//   List<Map<String, dynamic>> jobShort = []; // シフト時間を入れるリスト(短期)
//   List<Map<String, dynamic>> posJobTimes = []; // シフト時間を入れるリストdbに送る用
//   List<Map<String, dynamic>> posJobLong = []; // シフト時間を入れるリスト(長期)dbに送る用
//   List<Map<String, dynamic>> posJobShort = []; // シフト時間を入れるリスト(短期)dbに送る用
//   String daytime = ""; // 勤務時間をまとめる(日+時間)
//   String dDay = ""; // 勤務時間をまとめる(日)
//   String dTime = ""; // 勤務時間をまとめる(時間)
//   String inYear = ""; // 年
//   String inMonth = ""; // 月
//   String inDay = ""; // 日
//   String stTime = ""; // 勤務時間（start時）
//   String stMinute = ""; // 勤務時間（start分）
//   String finTime = ""; // 勤務時間（finish時）
//   String finMinute = ""; // 勤務時間（finish分）

// // ----------------------------------------------------

// // タグ関連--------------------------------------------
//   List<Map<String, dynamic>> tagname = []; // タグ情報が入っている
//   int tagLength = 0; // tagname内の要素数を記録
//   bool tagNotInput = false; // タグが入力可能でないかの判断
//   String tagName = ""; // タグの名前を一時保存する場所
//   final textFieldController = TextEditingController(); // 入力内の取り消しなどを行うためのもの
// // -------------------------------------------------

// // 確認へと送る写真--------------------------------
//   XFile? posImage;
//   bool posImageJudge = false; // 画像をDBに送るかの判定
//   String? imageUrl = "NO";
// // -----------------------------------------------

// // 広告確認画面へ送るマップ--------------------------------------------------------
// // 確認ボタンを押すときにmapをつくりなおしているので，押す前に要素を使わなければエラーは出ないが念のために初期化している
//   late Map<String, dynamic> postList;
//   JobPostWriteState() {
//     postList = {
//       "title": postTitle, //タイトル
//       //詳細
//       "detail": detail, //勤務体系
//       "is_one_day": isOneDay,

//       "day": ["2021年8月1日", "2021年8月2日", "2021年8月2日"], //日付
//       "time": ["10時00分~20時00分", "10時00分~20時00分", "10時00分~20時00分"], //時間

//       //開催場所
//       "postalNumber": addressNum, //郵便番号
//       "prefecture": posPrefecture, //都道府県
//       "city": posCity, //市町村
//       "houseNumber": posHouseNumber, //番地・建物名

//       //給料
//       "salary": salary,

//       //その他(任意)
//       "tag": [
//         "イベント",
//         "夏祭り",
//         "花火",
//         "香美市",
//         "イベント",
//       ], //ハッシュタグ
//       "additional_message": "test", //追加メッセージ

//       //レビュー
//       "reviewPoint": 4.5, //評価
//       //星の割合(前から1,2,3,4,5)
//       "ratioStarReviews": [0.03, 0.07, 0.1, 0.3, 0.5],
//       //レビュー数
//       "reviewNumber": 100,
//       //レビュー内容
//       "review": [
//         {
//           "reviewerName": "名前aiueo",
//           //"reviewerImage" : "test"   //予定
//           "reviewPoint": 3, //レビュー点数
//           "reviewDetail": "testfffff\n\nfffff", //レビュー内容
//           "reviewDate": "2021年8月1日", //レビュー日時
//         },
//         {
//           "reviewerName": "名前kakikukeko",
//           //"reviewerImage" : "test"   //予定
//           "reviewPoint": 3, //レビュー点数
//           "reviewDetail": "test", //レビュー内容
//           "reviewDate": "2021年8月1日", //レビュー日時
//         },
//       ]
//     };
//   }
// // ------------------------------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     final ImagePicker picker = ImagePicker();
//     final store = Provider.of<ChangeGeneralCorporation>(context);

//     return Scaffold(
//       appBar: const TitleAppBar(
//         title: "広告作成",
//         jedgeBuck: true,
//       ),
//       bottomNavigationBar: const NormalBottomAppBar(),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               // ElevatedButton(
//               //   child: Text('デバイスのライブラリから取得'),
//               //   onPressed: () async {
//               //     final XFile? image =
//               //         await picker.pickImage(source: ImageSource.gallery);
//               //     // if (image != null) {
//               //     //   setState(() {
//               //     //     hyoji_text = text;
//               //     //   });
//               //     // }
//               //     // if (image != null)
//               //     //   Navigator.push(
//               //     //     context,
//               //     //     MaterialPageRoute(
//               //     //       builder: (context) => done(image),
//               //     //     ),
//               //     //   );
//               //     if (image != null) {
//               //       // int fileSize = await getImageSize(image);

//               //       setState(() {
//               //         hyoji_text = image.name;
//               //         int length = hyoji_text.length;
//               //         String judge = hyoji_text.substring(length - 5);
//               //         if (judge.contains('.png') ||
//               //             judge.contains('.jpeg') ||
//               //             judge.contains('.jpg') ||
//               //             judge.contains('.JPG')) {
//               //           imageJudge = 'OK';
//               //         } else {
//               //           imageJudge = 'NO';
//               //         }

//               //         // fileSizeInKB = fileSize; // バイトからキロバイトへ変換
//               //       });
//               //     }
//               //   },
//               // ),
//               // Text(hyoji_text),
//               // Text('File size: $fileSizeInKB KB'),
//               // Text(imageJudge),

//               const SizedBox(
//                 height: 50,
//               ),

// // ----------写真投稿部分----------------------------------------------------------------------
//               Container(
//                 width: 350,
//                 height: 230,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 203, 202, 202),
//                       width: 2.5),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     const SizedBox(height: 30),
//                     const Icon(Icons.photo_camera,
//                         size: 100, color: Color.fromARGB(255, 137, 137, 137)),
//                     ElevatedButton(
//                       // 背景色
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: store.mainColor),
//                       child: const Text(
//                         'デバイスのライブラリから取得',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () async {
//                         final XFile? image =
//                             await picker.pickImage(source: ImageSource.gallery);
//                         // if (image != null) {
//                         //   setState(() {
//                         //     hyoji_text = text;
//                         //   });
//                         // }
//                         // if (image != null)
//                         //   Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //       builder: (context) => done(image),
//                         //     ),
//                         //   );
//                         if (image != null) {
//                           setState(() {
//                             hyoji_text = image.name;
//                             int length = hyoji_text.length;
//                             String judge = hyoji_text.substring(length - 5);
//                             if (judge.contains('.png') ||
//                                 judge.contains('.jpeg') ||
//                                 judge.contains('.jpg') ||
//                                 judge.contains('.JPG')) {
//                               posImage = image;
//                               ImageOver().show(
//                                 context: context,
//                                 onInputChanged: (value) {
//                                   // 入力値が変更されたときの処理
//                                   setState(() {
//                                     posImageJudge = value;
//                                     if (posImageJudge && posImage != null) {
//                                       imageJudge = "確認できたお";

//                                       // postImage(context, store, posImage)
//                                       //     .then((url) {
//                                       //   //AWS使用時解放
//                                       //   //ここでローディング画面を表示
//                                       //   if (url != "failed") {
//                                       //     imageUrl = url;
//                                       //   } else {
//                                       //     imageUrl = "NO";
//                                       //   }
//                                       // });
//                                     } else {
//                                       posImage = null;
//                                       imageJudge = 'NO';
//                                     }
//                                   });
//                                 },
//                               );
//                             } else {
//                               imageJudge = 'NO';
//                             }
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Text("オリジナルでないものや\n広告内容に沿わない写真はご遠慮ください",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 10),
//                         textAlign: TextAlign.center),
//                   ],
//                 ),
//               ),
//               // Text(imageJudge), // 確認用
//               Text("{$planId$planPeriod}"),

// // ----------------------------------------------------------------------------------------------

//               const SizedBox(height: 40),
//               // 広告名入力欄
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   "求人名",
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 300,
//                 child: TextField(
//                   textAlign: TextAlign.start,
//                   onChanged: (value) {
//                     setState(() {
//                       postTitle = value;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                     hintText: "求人名",
//                     hintStyle: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // 詳細入力欄（500文字）
//               const SizedBox(height: 40),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   "求人詳細情報",
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: 300,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 203, 202, 202),
//                       width: 2.5),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     maxLines: null,
//                     maxLength: 500,
//                     onChanged: (value) {
//                       setState(() {
//                         detail = value;
//                       });
//                     },
//                     style: const TextStyle(fontSize: 13),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "ここに入力",
//                       counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                     ),
//                   ),
//                 ),
//               ),

//               // 勤務体系
//               const SizedBox(height: 40),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   "勤務体系",
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               DropdownButton(
//                 value: selectedValue,
//                 items: lists.map((String list) {
//                   return DropdownMenuItem(
//                     value: list,
//                     child: Text(list),
//                   );
//                 }).toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedValue = value!;
//                     term = selectedValue;
//                     if (selectedValue == "短期") {
//                       isOneDay = true;
//                     } else {
//                       isOneDay = false;
//                     }
//                   });
//                 },
//               ),

//               // 日付設定
//               const SizedBox(height: 40),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   '日付設定',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),

//               Stack(children: [
//                 selectedValue == "短期"
//                     ? SizedBox(
//                         width: 345,
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               width: 80,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: const Color.fromARGB(
//                                         255, 203, 202, 202),
//                                     width: 2),
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: TextField(
//                                 textAlign: TextAlign.center,
//                                 maxLines: null,
//                                 maxLength: 4,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     inYear = value;
//                                   });
//                                 },
//                                 style: const TextStyle(fontSize: 13),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   counterText:
//                                       '', //maxLengthによる"0/100"の表示を消すための処理
//                                 ),
//                               ),
//                             ),
//                             const Text(
//                               " 年 ",
//                               style: TextStyle(fontSize: 13),
//                             ),
//                             Container(
//                               width: 60,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: const Color.fromARGB(
//                                         255, 203, 202, 202),
//                                     width: 2),
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: TextField(
//                                 textAlign: TextAlign.center,
//                                 maxLines: null,
//                                 maxLength: 2,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     inMonth = value;
//                                   });
//                                 },
//                                 style: const TextStyle(fontSize: 13),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   counterText:
//                                       '', //maxLengthによる"0/100"の表示を消すための処理
//                                 ),
//                               ),
//                             ),
//                             const Text(
//                               " 月 ",
//                               style: TextStyle(fontSize: 13),
//                             ),
//                             Container(
//                               width: 60,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: const Color.fromARGB(
//                                         255, 203, 202, 202),
//                                     width: 2),
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               child: TextField(
//                                 textAlign: TextAlign.center,
//                                 maxLines: null,
//                                 maxLength: 2,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     inDay = value;
//                                   });
//                                 },
//                                 style: const TextStyle(fontSize: 13),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   counterText:
//                                       '', //maxLengthによる"0/100"の表示を消すための処理
//                                 ),
//                               ),
//                             ),
//                             const Text(
//                               " 日 ",
//                               style: TextStyle(fontSize: 13),
//                             ),
//                           ],
//                         ),
//                       )
//                     : const Text(
//                         "勤務体系が長期の場合勤務時間のみの設定となります",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.red),
//                       ),
//               ]),

//               const SizedBox(height: 20),
//               SizedBox(
//                 width: 390,
//                 child: Row(
//                   children: <Widget>[
//                     const SizedBox(
//                       width: 25,
//                     ),
//                     Container(
//                       width: 60,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 2,
//                         onChanged: (value) {
//                           setState(() {
//                             stTime = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       " 時 ",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     Container(
//                       width: 60,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 2,
//                         onChanged: (value) {
//                           setState(() {
//                             stMinute = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       " 分 ",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     const Text(
//                       " ～ ",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Container(
//                       width: 60,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 2,
//                         onChanged: (value) {
//                           setState(() {
//                             finTime = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       " 時 ",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     Container(
//                       width: 60,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 2,
//                         onChanged: (value) {
//                           setState(() {
//                             finMinute = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       " 分 ",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(
//                 height: 15,
//               ),

//               ElevatedButton(
//                   // 背景色
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: store.mainColor),
//                   child: const Text(
//                     "日程を追加",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onPressed: () async {
//                     setState(() {
//                       // if (tagName != "" && tagname.length < 20) {

//                       //日時分合成
//                       dDay = "$inYear年 $inMonth月 $inDay日";
//                       dTime = "$stTime時 $stMinute分 ～ $finTime時 $finMinute分";
//                       daytime = "$dDay:　$dTime";
//                       // 日程追加
//                       if (term == "長期" && jobLong.length < 5) {
//                         String posDaytimeS = "3333-01-22 $stTime:$stMinute:00";
//                         String posDaytimeE =
//                             "3333-01-22 $finTime:$finMinute:00";
//                         jobLong.add({"start_time": dTime, "end_time": "22"});
//                         jobTimes = jobLong;
//                         posJobLong.add({
//                           "start_time": posDaytimeS,
//                           "end_time": posDaytimeE
//                         });
//                         posJobTimes = posJobLong;
//                       } else if (jobShort.length < 5) {
//                         String posDaytimeS =
//                             "$inYear-$inMonth-$inDay $stTime:$stMinute:00";
//                         String posDaytimeE =
//                             "$inYear-$inMonth-$inDay $finTime:$finMinute:00";
//                         jobShort.add({"start_time": daytime, "end_time": "22"});
//                         jobTimes = jobShort;
//                         posJobShort.add({
//                           "start_time": posDaytimeS,
//                           "end_time": posDaytimeE
//                         });
//                         posJobTimes = posJobShort;
//                       }

//                       // 入力内容リセット
//                       //   textFieldController.clear();
//                       //   tagName = "";
//                       //   tagLength = tagname.length;
//                       //   tagNotInput = false;
//                       // } else {
//                       //   tagNotInput = true;
//                       // }
//                     });
//                   }),

//               const SizedBox(
//                 height: 15,
//               ),

//               Stack(children: [
//                 selectedValue == "短期"
//                     ? SizedBox(
//                         width: 390,
//                         height: 200,
//                         child: ListView.builder(
//                           itemCount: jobShort.length,
//                           itemBuilder: (context, index) {
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 TextButton(
//                                   onPressed: () {},
//                                   style: TextButton.styleFrom(
//                                     backgroundColor: const Color.fromARGB(
//                                         255, 235, 235, 235),
//                                   ),
//                                   child: Text(jobShort[index]["start_time"]),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       jobShort.removeAt(index);
//                                       jobTimes = jobShort;
//                                       posJobShort.removeAt(index);
//                                       posJobTimes = posJobShort;
//                                     });
//                                   },
//                                   style: TextButton.styleFrom(
//                                     backgroundColor:
//                                         const Color.fromARGB(255, 255, 75, 51),
//                                   ),
//                                   child: const Text(
//                                     "削除",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       )
//                     : SizedBox(
//                         width: 350,
//                         height: 200,
//                         child: ListView.builder(
//                           itemCount: jobLong.length,
//                           itemBuilder: (context, index) {
//                             // return Card(
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 TextButton(
//                                   onPressed: () {},
//                                   style: TextButton.styleFrom(
//                                     backgroundColor: const Color.fromARGB(
//                                         255, 235, 235, 235),
//                                   ),
//                                   child: Text(jobLong[index]["start_time"]),
//                                 ),
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       jobLong.removeAt(index);
//                                       jobTimes = jobLong;
//                                       posJobLong.removeAt(index);
//                                       jobTimes = posJobLong;
//                                     });
//                                   },
//                                   style: TextButton.styleFrom(
//                                     backgroundColor:
//                                         const Color.fromARGB(255, 255, 75, 51),
//                                   ),
//                                   child: const Text(
//                                     "削除",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       )
//               ]),

//               // 開催場所設定
//               const SizedBox(height: 40),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   '開催場所設定',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // 郵便番号
//               const SizedBox(height: 10),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   '郵便番号',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 60,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 3,
//                         onChanged: (value) {
//                           setState(() {
//                             firstNumber = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       " - ",
//                       style: TextStyle(fontSize: 30),
//                     ),
//                     Container(
//                       width: 80,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 4,
//                         onChanged: (value) {
//                           setState(() {
//                             backNumber = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),

//                     // 住所検索ボタン
//                     ElevatedButton(
//                       //背景色
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: store.mainColor),
//                       child: const Text(
//                         '住所を検索',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () async {
//                         setState(() {
//                           addressNum =
//                               "$firstNumber$backNumber"; // APIに送る用のアドレス
//                           posAddressNum =
//                               "$firstNumber-$backNumber"; // 確認画面へと送る(mapに入る)用のアドレス
//                         });

//                         if (addressNum.length != 7) {
//                           // アドレスが７文字であるかの判定
//                           return;
//                         }
//                         final address = await zipCodeToAddress(addressNum);
//                         // 返ってきた値がnullなら終了
//                         if (address == null) {
//                           return;
//                         }
//                         // 住所が帰ってきたら、addressListの中身を上書きする。
//                         setState(() {
//                           prefecture.text = address[0];
//                           city.text = address[1];
//                           houseNumber.text = address[2];
//                           posPrefecture = prefecture.text;
//                           posCity = city.text;
//                           posHouseNumber = houseNumber.text;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               // 都道府県
//               const SizedBox(height: 20),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   '都道府県',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 200,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         maxLines: null,
//                         maxLength: 10,
//                         onChanged: (value) {
//                           setState(() {
//                             posPrefecture = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                         controller: prefecture,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // 市町村
//               const SizedBox(height: 20),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   '市町村',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 300,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         maxLines: null,
//                         maxLength: 100,
//                         onChanged: (value) {
//                           setState(() {
//                             posCity = value;
//                           });
//                         },
//                         style: const TextStyle(fontSize: 13),
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                         controller: city,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // 番地・建物名
//               const SizedBox(height: 20),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   '番地・建物名',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Container(
//                   width: 300,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: const Color.fromARGB(255, 203, 202, 202),
//                         width: 2),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: TextField(
//                     maxLines: null,
//                     maxLength: 200,
//                     onChanged: (value) {
//                       setState(() {
//                         posHouseNumber = value;
//                       });
//                     },
//                     style: const TextStyle(fontSize: 13),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                     ),
//                     controller: houseNumber,
//                   ),
//                 ),
//               ),

//               // 給料設定
//               const SizedBox(height: 40),
//               SizedBox(
//                 width: 350,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
//                   children: <Widget>[
//                     const Text(
//                       '給料',
//                       style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: <Widget>[
//                         DropdownButton(
//                           value: selectedDay,
//                           items: listsFee.map((String list) {
//                             return DropdownMenuItem(
//                               value: list,
//                               child: Text(list),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               selectedDay = value!;
//                               salary = "$selectedDay$value円";
//                             });
//                           },
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Container(
//                           width: 230,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: const Color.fromARGB(255, 203, 202, 202),
//                                 width: 2),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: TextField(
//                             maxLines: null,
//                             maxLength: 10,
//                             onChanged: (value) {
//                               setState(() {
//                                 salary = "$selectedDay$value円";
//                               });
//                             },
//                             style: const TextStyle(fontSize: 13),
//                             decoration: const InputDecoration(
//                               border: InputBorder.none,
//                               counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // タグ設定
//               const SizedBox(height: 40),
//               SizedBox(
//                 width: 350,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
//                   children: <Widget>[
//                     const Text(
//                       "タグ設定",
//                       style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: 350,
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 200,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                   color:
//                                       const Color.fromARGB(255, 203, 202, 202),
//                                   width: 2),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: TextField(
//                               controller: textFieldController, // コントローラ設置
//                               maxLines: null,
//                               maxLength: 10,
//                               onChanged: (value) {
//                                 setState(() {
//                                   tagName = value;
//                                 });
//                               },
//                               style: const TextStyle(fontSize: 13),
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 counterText:
//                                     '', //maxLengthによる"0/100"の表示を消すための処理
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           ElevatedButton(
//                               //背景色
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: store.mainColor,
//                               ),
//                               child: const Text(
//                                 "タグを追加",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               onPressed: () async {
//                                 setState(() {
//                                   if (tagName != "" && tagname.length < 20) {
//                                     // タグ追加
//                                     tagname.add({"name": tagName});
//                                     // 入力内容リセット
//                                     textFieldController.clear();
//                                     tagName = "";
//                                     tagLength = tagname.length;
//                                     tagNotInput = false;
//                                   } else {
//                                     tagNotInput = true;
//                                   }
//                                 });
//                               }),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       checkTagErr(tagNotInput, tagLength),
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                     SizedBox(
//                       width: 200,
//                       height: 200,
//                       child: ListView.builder(
//                         itemCount: tagname.length,
//                         itemBuilder: (context, index) {
//                           return Column(
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     width: 120,
//                                     child: Card(
//                                       child: FittedBox(
//                                         fit: BoxFit.scaleDown,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                               "#${tagname[index]["name"]}"),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         tagname.removeAt(index);
//                                       });
//                                     },
//                                     style: TextButton.styleFrom(
//                                       backgroundColor: const Color.fromARGB(
//                                           255, 255, 75, 51),
//                                     ),
//                                     child: const Text(
//                                       "削除",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               )
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // 追加メッセージ（500文字）
//               const SizedBox(height: 40),
//               const SizedBox(
//                 width: 350,
//                 child: Text(
//                   "追加メッセージ（500文字）",
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 width: 300,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                       color: const Color.fromARGB(255, 203, 202, 202),
//                       width: 2.5),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     maxLines: null,
//                     maxLength: 500,
//                     onChanged: (value) {
//                       setState(() {
//                         additionalMessage = value;
//                       });
//                     },
//                     style: const TextStyle(fontSize: 13),
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'ここに入力',
//                       counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                     ),
//                   ),
//                 ),
//               ),

//               // 確認とキャンセル
//               const SizedBox(
//                 height: 70,
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     style: ButtonStyle(
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(10.0), // ここで角の丸みを設定します
//                         ),
//                       ),
//                       minimumSize: MaterialStateProperty.all<Size>(
//                           const Size(150, 50)), // ここでボタンの大きさを設定します
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Colors.grey), // ここで背景色を設定します
//                     ),
//                     child: const Text(
//                       '広告完成図確認',
//                       style: TextStyle(
//                           //fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 18),
//                     ),
//                     onPressed: () async {
//                       setState(() {
//                         postList = {
//                           "name": postTitle, //タイトル
//                           //詳細
//                           "description": detail,

//                           "image_url": imageUrl,

//                           "is_one_day": isOneDay, //勤務体系

//                           "job_times": jobTimes,

//                           //開催場所
//                           "postalNumber": posAddressNum, //郵便番号
//                           "prefecture": posPrefecture, //都道府県
//                           "city": posCity, //市町村
//                           "houseNumber": posHouseNumber, //番地・建物名

//                           //給料
//                           "salary": salary,

//                           //その他(任意)
//                           "tags": tagname,

//                           "additional_message": additionalMessage, //追加メッセージ

//                           //レビュー
//                           "reviewPoint": 4.5, //評価
//                           //星の割合(前から1,2,3,4,5)
//                           "ratioStarReviews": [0.03, 0.07, 0.1, 0.3, 0.5],
//                           //レビュー数
//                           "reviewNumber": 100,
//                           //レビュー内容
//                           "review": [
//                             {
//                               "reviewerName": "名前aiueo",
//                               //"reviewerImage" : "test"   //予定
//                               "reviewPoint": 3, //レビュー点数
//                               "reviewDetail": "testfffff\n\nfffff", //レビュー内容
//                               "reviewDate": "2021年8月1日", //レビュー日時
//                             },
//                             {
//                               "reviewerName": "名前kakikukeko",
//                               //"reviewerImage" : "test"   //予定
//                               "reviewPoint": 3, //レビュー点数
//                               "reviewDetail": "test", //レビュー内容
//                               "reviewDate": "2021年8月1日", //レビュー日時
//                             },
//                           ]
//                         };
//                       });

//                       // Navigator.pop(context);
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => PostWriteComp(
//                                 jobList: postList,
//                                 image: posImage,
//                               )));
//                     },
//                   ),
//                   //空白
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   ElevatedButton(
//                       style: ButtonStyle(
//                         shape:
//                             MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(10.0), // ここで角の丸みを設定します
//                           ),
//                         ),
//                         minimumSize: MaterialStateProperty.all<Size>(
//                             const Size(150, 50)), // ここでボタンの大きさを設定します
//                         backgroundColor: MaterialStateProperty.all<Color>(
//                             store.mainColor), // ここで背景色を設定します
//                       ),
//                       child: const Text(
//                         "   投稿する   ",
//                         style: TextStyle(
//                             //fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 18),
//                       ),
//                       onPressed: () {
//                         bool judgePost;
//                         PostComfOver().show(
//                           context: context,
//                           onInputChanged: (value) {
//                             // 入力値が変更されたときの処理
//                             setState(() {
//                               judgePost = value;
//                               if (imageUrl == "NO") {
//                                 imageUrl = null;
//                               }
//                               if (judgePost) {
//                                 Map<String, dynamic> dbPostList;
//                                 dbPostList = {
//                                   "purchase": {
//                                     "plan_id": planId,
//                                     "contract_amount": planPeriod
//                                   },
//                                   "job": {
//                                     "name": postTitle,
//                                     "image_url": imageUrl,
//                                     "salary": salary,
//                                     "postal_code": posAddressNum,
//                                     "prefecture": posPrefecture,
//                                     "city": posCity,
//                                     "address": posHouseNumber,
//                                     "description": detail,
//                                     "is_one_day": isOneDay,
//                                     "additional_message": additionalMessage,
//                                     "tags": tagname,
//                                     "job_times": posJobTimes
//                                   }
//                                 };
//                                 createUser(context, store, dbPostList)
//                                     .then((success) {
//                                   //ここでローディング画面を表示
//                                   if (success) {
//                                     Navigator.pop(context); //pop
//                                     Navigator.push(
//                                       context,
//                                       // MaterialPageRoute(builder: (context) => Home()),
//                                       MaterialPageRoute(
//                                           builder: (context) => JobFeeWatch(
//                                                 planId: planId,
//                                                 planPeriod: planPeriod,
//                                                 eventJobJedge: false,
//                                                 botommBarJedge: true,
//                                               )),
//                                     );
//                                   }
//                                 });
//                               } else {}
//                             });
//                           },
//                         );
//                       }),
//                 ],
//               ),

//               const SizedBox(
//                 height: 50,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // APIによる住所取得
// Future<List<String>?> zipCodeToAddress(String zipCode) async {
//   if (zipCode.length != 7) {
//     return null;
//   }
//   final response = await get(
//     Uri.parse(
//       'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode',
//     ),
//   );
//   // 正常なステータスコードが返ってきているか
//   if (response.statusCode != 200) {
//     return null;
//   }
//   // ヒットした住所はあるか
//   final result = jsonDecode(response.body);
//   if (result['results'] == null) {
//     return null;
//   }
//   final addressMap =
//       (result['results'] as List).first; // 結果が2つ以上のこともあるが、簡易的に最初のひとつを採用することとする。
//   // final address =
//   //     '${addressMap['address1']} ${addressMap['address2']} ${addressMap['address3']}'; // 住所を連結する。
//   String address1 = addressMap['address1'];
//   String address2 = addressMap['address2'];
//   String address3 = addressMap['address3'];
//   final addresses = <String>[address1, address2, address3];

//   return addresses;
// }

// String checkTagErr(bool tagNotInput, int tagLength) {
//   //性別の正規表現
//   if (tagNotInput) {
//     if (tagLength == 20) {
//       return "設定可能なタグ数が最大です（最大２０個）";
//     } else {
//       return "タグ名を入力してください";
//     }
//   }
//   return "";
// }

// Future<bool> createUser(
//   BuildContext context,
//   final store,
//   Map<String, dynamic> jobList,
// ) async {
//   Uri url = Uri.parse("${ChangeGeneralCorporation.apiUrl}/jobs/purchase-job");

//   try {
//     final response = await post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'authorization': 'Bearer ${store.accessToken}',
//         'accept': 'application/json',
//       },
//       body: jsonEncode(jobList),
//     );

//     if (response.statusCode == 200) {
//       return true; // 成功時は true を返す
//     } else {
//       return false; // 仮置き
//       // final Map<String, dynamic> data = json.decode(response.body);

//       // if (data["detail"] == "Username already registered") {
//       //   // 既にユーザー名が登録されている場合//pop

//       //   Navigator.pop(context);
//       //   showDialog(
//       //     context: context,
//       //     builder: (context) {
//       //       return AlertDialog(
//       //         title: const Text('エラー'),
//       //         content: const Text('登録予定のユーザー名は既に登録されています'),
//       //         actions: <Widget>[
//       //           TextButton(
//       //             child: const Text('OK'),
//       //             onPressed: () => Navigator.pop(context),
//       //           ),
//       //         ],
//       //       );
//       //     },
//       //   );
//       //   return false; // エラー時は false を返す
//       // } else if (data["detail"] == "Email already registered") {
//       //   // 既にメールアドレスが登録されている場合
//       //   Navigator.pop(context); //
//       //   showDialog(
//       //     context: context,
//       //     builder: (context) {
//       //       return AlertDialog(
//       //         title: const Text('エラー'),
//       //         content: const Text('登録予定のメールアドレスは既に登録されています'),
//       //         actions: <Widget>[
//       //           TextButton(
//       //             child: const Text('OK'),
//       //             onPressed: () => Navigator.pop(context),
//       //           ),
//       //         ],
//       //       );
//       //     },
//       //   );
//       //   return false; // エラー時は false を返す
//       // } else {
//       //   // その他のエラーの場合
//       //   return false; // エラー時は false を返す
//       // }
//     }
//   } catch (error) {
//     // 通信エラーなどの例外が発生した場合
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('エラー'),
//           content: const Text('通信エラーが発生しました'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//     return false; // エラー時は false を返す
//   }
// }

// Future<String> postImage(
//   BuildContext context,
//   final store,
//   XFile? image,
//   // Map<String, dynamic> jobList,
// ) async {
//   Uri url = Uri.parse("${ChangeGeneralCorporation.apiUrl}/upload-image");

//   try {
//     // final response = await post(
//     //   url,
//     //   headers: {
//     //     'Content-Type': 'multipart/from-data',
//     //     'authorization': 'Bearer ${store.accessToken}',
//     //     'accept': 'application/json',
//     //   },

//     // );
//     final test = await image!.readAsBytes();
//     final request = MultipartRequest("POST", url);
//     request.headers.addAll({"Authorization": 'Bearer ${store.accessToken}'});
//     request.files.add(MultipartFile.fromBytes('file', test,
//         filename: image.name,
//         contentType: MediaType.parse("multipart/form-data")));
//     final stream = await request.send();

//     return Response.fromStream(stream).then((response) {
//       if (response.statusCode == 200) {
//         final data = json.decode(utf8.decode(response.bodyBytes));
//         // final data = response.body;
//         return data["url"].toString();
//       }
//       return "failed";
//     });
//     // if (response.statusCode == 200) {
//     //   return true; // 成功時は true を返す
//     // } else {
//     //   return false; // 仮置き
//     // final Map<String, dynamic> data = json.decode(response.body);

//     // if (data["detail"] == "Username already registered") {
//     //   // 既にユーザー名が登録されている場合//pop

//     //   Navigator.pop(context);
//     //   showDialog(
//     //     context: context,
//     //     builder: (context) {
//     //       return AlertDialog(
//     //         title: const Text('エラー'),
//     //         content: const Text('登録予定のユーザー名は既に登録されています'),
//     //         actions: <Widget>[
//     //           TextButton(
//     //             child: const Text('OK'),
//     //             onPressed: () => Navigator.pop(context),
//     //           ),
//     //         ],
//     //       );
//     //     },
//     //   );
//     //   return false; // エラー時は false を返す
//     // } else if (data["detail"] == "Email already registered") {
//     //   // 既にメールアドレスが登録されている場合
//     //   Navigator.pop(context); //
//     //   showDialog(
//     //     context: context,
//     //     builder: (context) {
//     //       return AlertDialog(
//     //         title: const Text('エラー'),
//     //         content: const Text('登録予定のメールアドレスは既に登録されています'),
//     //         actions: <Widget>[
//     //           TextButton(
//     //             child: const Text('OK'),
//     //             onPressed: () => Navigator.pop(context),
//     //           ),
//     //         ],
//     //       );
//     //     },
//     //   );
//     //   return false; // エラー時は false を返す
//     // } else {
//     //   // その他のエラーの場合
//     //   return false; // エラー時は false を返す
//     // }
//     // }
//   } catch (error) {
//     // 通信エラーなどの例外が発生した場合
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('エラー'),
//           content: const Text('通信エラーが発生しました'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//     return "failed"; // エラー時は false を返す
//   }
// }
