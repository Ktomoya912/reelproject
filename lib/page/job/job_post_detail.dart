import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/appbar/detail_appbar.dart';
import 'package:reelproject/component/listView/carousel.dart';
import 'package:reelproject/page/event/search_page.dart'; //イベント検索
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobPostDetail extends StatefulWidget {
  const JobPostDetail({
    super.key,
    required this.id,
    required this.tStore,
  });

  final int id;
  final tStore;

  @override
  State<JobPostDetail> createState() => _JobPostDetailState();
}

class _JobPostDetailState extends State<JobPostDetail> {
  // データベースと連携させていないので現在はここでイベント詳細内容を設定
  static Map<String, dynamic> jobDetailList = {
    "id": 0,
    //必須
    "title": "川上神社夏祭り", //タイトル
    //詳細
    "detail":
        "川上様夏祭りは香北の夏の風物詩ともいえるお祭で、ビアガーデンや各種団体による模擬店、ステージイベントなどが行われ、毎年市内外から多くの見物客が訪れます。\n \n この度、運営スタッフ不足によりスタッフを募集します。\n \n・当日の会場設営\n・祭り終了後のゴミ拾い\n・祭り開催中のスタッフ（内容は当日お知らせします）",
    //勤務体系
    "term": "長期",

    //開催期間
    "jobTimes": [
      {
        "start_time": "2024-01-12T19:53:41",
        "end_time": "2024-01-12T20:53:41",
        "id": 1
      }
    ],

    //開催場所
    "postalNumber": "781-5101", //郵便番号
    "prefecture": "高知県", //都道府県
    "city": "香美市", //市町村
    "houseNumber": "土佐山田町", //番地・建物名

    //給料
    "pay": "1000",

    //その他(任意)
    "tag": [
      {"name": "タグ名", "id": 1}
    ], //ハッシュタグ
    "addMessage": "test", //追加メッセージ

    //レビュー
    "reviewPoint": 0, //評価
    //星の割合(前から1,2,3,4,5)
    "ratioStarReviews": [0, 0, 0, 0, 0],
    //レビュー数
    "reviewNumber": 0,
    //自分のレビューか否か
    "reviewId": 0,
    //レビュー内容
    "review": [
      {
        "title": "ｗｗｗえええ",
        "review": "ｗｗｗえええ",
        "review_point": 4,
        "id": 9,
        "user": {
          "username": "admin",
          "image_url": null,
          "email": "mitsuara0517@gmail.com",
          "sex": "o",
          "birthday": "2000-01-01",
          "user_type": "a",
          "id": 1,
          "company": null,
          "is_active": true
        },
        "created_at": "2024-01-12T17:39:35",
        "updated_at": "2024-01-12T17:39:47"
      }
    ],

    //この広告を投稿したか
    "postJedge": true,

    //未投稿か否か(true:未投稿,false:投稿済み)
    "notPost": true,

    //お気に入りか否か]
    "favoriteJedge": false,

    //掲載期間
    "postTerm": "2023年12月10日"
  };

  changeJobList(dynamic data, int id, ChangeGeneralCorporation store) {
    setState(() {
      jobDetailList["id"] = id; //id
      jobDetailList["title"] = data["name"]; //タイトル
      jobDetailList["detail"] = data["description"]; //詳細

      //タグ
      jobDetailList["tag"] = data["tags"];

      //開催期間
      jobDetailList["jobTimes"] = data["job_times"];

      //勤務体系
      if (data["is_one_day"]) {
        jobDetailList["term"] = "短期";
      } else {
        jobDetailList["term"] = "長期";
      }

      //住所
      jobDetailList["postalNumber"] = data["postal_code"]; //郵便番号
      jobDetailList["prefecture"] = data["prefecture"]; //都道府県
      jobDetailList["city"] = data["city"]; //市町村
      jobDetailList["houseNumber"] = data["address"]; //番地・建物名
      //任意
      //jobDetailList["phone"] = data["phone_number"]; //電話番号
      //jobDetailList["mail"] = data["email"]; //メールアドレス
      //jobDetailList["url"] = data["homepage"]; //URL
      //jobDetailList["fee"] = data["participation_fee"]; //参加費
      //jobDetailList["Capacity"] = data["capacity"]; //定員
      jobDetailList["addMessage"] = data["additional_message"]; //追加メッセージ
      //jobDetailList["notes"] = data["caution"]; //注意事項

      //レビュー
      jobDetailList["review"] = data["reviews"]; //評価
      //初期化
      jobDetailList["reviewPoint"] = 0; //平均点
      jobDetailList["ratioStarReviews"] = [0, 0, 0, 0, 0]; //星の割合(前から1,2,3,4,5)
      jobDetailList["reviewNumber"] = 0; //レビュー数
      jobDetailList["reviewId"] = 0; //自分のレビューか否か
      if (jobDetailList["review"].length != 0) {
        //平均点
        for (int i = 0; i < data["reviews"].length; i++) {
          jobDetailList["reviewPoint"] +=
              data["reviews"][i]["review_point"]; //平均点
          jobDetailList["ratioStarReviews"]
              [data["reviews"][i]["review_point"] - 1]++; //星の割合(前から1,2,3,4,5)
          //自分のレビューか否か
          if (store.myID == data["reviews"][i]["user"]["id"]) {
            jobDetailList["reviewId"] = data["reviews"][i]["id"];
          }
        }
        //平均を出す
        jobDetailList["reviewPoint"] =
            jobDetailList["reviewPoint"] / data["reviews"].length;

        //レビュー数
        jobDetailList["reviewNumber"] = data["reviews"].length;

        //割合計算
        for (int i = 0; i < 5; i++) {
          jobDetailList["ratioStarReviews"][i] =
              jobDetailList["ratioStarReviews"][i] / data["reviews"].length;
        }
      }

      jobDetailList["favoriteJedge"] = data["is_favorite"]; //お気に入りか否か
    });
  }

  Future getJobList(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/jobs/$id');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeJobList(data, id, store);
    } else {
      print("error");
      throw Exception("Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    getJobList(widget.id, widget.tStore);
  }

  //お気に入り登録
  Future boobkmarkOn(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/jobs/$id/bookmark');
    final response = await post(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    getJobList(widget.id, widget.tStore);
  }

  //お気に入り削除
  Future boobkmarkOff(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/jobs/$id/bookmark');
    final response = await delete(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    getJobList(widget.id, widget.tStore);
  }

  //求人広告のリスト
  //titleに文字数制限を設ける
  // static Map<String, dynamic> jobDetailList = {
  //   //必須
  //   "title": "川上神社夏祭り", //タイトル
  //   //詳細
  //   "detail":
  //       "川上様夏祭りは香北の夏の風物詩ともいえるお祭で、ビアガーデンや各種団体による模擬店、ステージイベントなどが行われ、毎年市内外から多くの見物客が訪れます。\n \n この度、運営スタッフ不足によりスタッフを募集します。\n \n・当日の会場設営\n・祭り終了後のゴミ拾い\n・祭り開催中のスタッフ（内容は当日お知らせします）",
  //   //勤務体系
  //   "term": "長期",

  //   "day": ["2021年8月1日", "2021年8月2日", "2021年8月2日"], //日付
  //   "time": ["10時00分~20時00分", "10時00分~20時00分", "10時00分~20時00分"], //時間

  //   //開催場所
  //   "postalNumber": "781-5101", //郵便番号
  //   "prefecture": "高知県", //都道府県
  //   "city": "香美市", //市町村
  //   "houseNumber": "土佐山田町", //番地・建物名

  //   //給料
  //   "pay": "1000",

  //   //その他(任意)
  //   "tag": [
  //     "イベント",
  //     "夏祭り",
  //     "花火",
  //     "香美市",
  //     "イベント",
  //   ], //ハッシュタグ
  //   "addMessage": "test", //追加メッセージ

  //   //レビュー
  //   "reviewPoint": 4.5, //評価
  //   //星の割合(前から1,2,3,4,5)
  //   "ratioStarReviews": [0.03, 0.07, 0.1, 0.3, 0.5],
  //   //レビュー数
  //   "reviewNumber": 100,
  //   //レビュー内容
  //   "review": [
  //     {
  //       "reviewerName": "名前aiueo",
  //       //"reviewerImage" : "test"   //予定
  //       "reviewPoint": 3, //レビュー点数
  //       "reviewDetail": "testfffff\n\nfffff", //レビュー内容
  //       "reviewDate": "2021年8月1日", //レビュー日時
  //     },
  //     {
  //       "reviewerName": "名前kakikukeko",
  //       //"reviewerImage" : "test"   //予定
  //       "reviewPoint": 3, //レビュー点数
  //       "reviewDetail": "test", //レビュー内容
  //       "reviewDate": "2021年8月1日", //レビュー日時
  //     },
  //     {
  //       "reviewerName": "名前sasisuseso",
  //       //"reviewerImage" : "test"   //予定
  //       "reviewPoint": 3, //レビュー点数
  //       "reviewDetail": "test", //レビュー内容
  //       "reviewDate": "2021年8月1日", //レビュー日時
  //     }
  //   ],

  //   //この広告を投稿したか
  //   "postJedge": true,

  //   //掲載期間
  //   "postTerm": "2023年12月10日"
  // };

  //bool favoriteJedge = false; //お気に入り判定

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
    Uri url = Uri.parse('http://localhost:8000/api/v1/jobs/${id}/review');
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
    getJobList(widget.id, widget.tStore);
  }

  //レビュー削除
  Future reviewDelite(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        'http://localhost:8000/api/v1/jobs/${id}/review?user_id=${store.myID}');
    final response = await delete(url, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${store.accessToken}',
    });
    getJobList(widget.id, widget.tStore);
  }

  //レビュー編集
  Future reviewEdit(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        'http://localhost:8000/api/v1/jobs/${id}/review?user_id=${store.myID}');
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
    getJobList(widget.id, widget.tStore);
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

    //短期or長期の色
    Color termColor = Colors.green;
    if (jobDetailList["term"] == "長期") {
      termColor = Colors.lightGreen;
    } else if (jobDetailList["term"] == "短期") {
      termColor = Colors.yellow[500]!;
    }

    //横画面サイズにより幅設定
    double widthBlank = (mediaQueryData.size.width / 2) - 300;
    if (widthBlank < 0) {
      widthBlank = 0;
    }
    //double blank = mediaQueryData.size.width / 20;
    double width = mediaQueryData.size.width - (widthBlank * 2);
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(
      //アップバー
      appBar: DetailAppbar(
        postJedge: jobDetailList["postJedge"],
        eventJobJedge: "job",
        postTerm: jobDetailList["postTerm"],
        mediaQueryData: mediaQueryData,
        notPostJedge: jobDetailList["notPost"],
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
                      //上の空間

                      //空白
                      SizedBox(
                        height: mediaQueryData.size.height / 50,
                      ),

                      //画像
                      Stack(children: [
                        SizedBox(
                          height: width * 0.6,
                          width: width,
                          child: Carousel(
                            pages: [
                              for (int i = 0; i < 5; i++)
                                Container(
                                  alignment: Alignment.topRight,
                                  height: width * 0.6,
                                  //width: width,
                                  color: Colors.blue,
                                ),
                            ],
                            timeJedge: false,
                          ),
                        ),
                      ]),
                      //タイトル
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //タイトル
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              jobDetailList["title"],
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
                                borderRadius: BorderRadius.circular(50.0), //角丸
                                isSelected: [
                                  jobDetailList["favoriteJedge"]
                                ], //on off
                                //ボタンを押した時の処理
                                onPressed: (int index) => setState(() {
                                  if (!jobDetailList["favoriteJedge"]) {
                                    boobkmarkOn(jobDetailList["id"], store);
                                  } else {
                                    boobkmarkOff(jobDetailList["id"], store);
                                  }
                                }),
                                //アイコン
                                children: <Widget>[
                                  jobDetailList["favoriteJedge"]
                                      ? const Icon(Icons.favorite, size: 40)
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
                      if (jobDetailList["tag"].length != 0)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: width, // 最小幅をwidthに設定
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // 子ウィジェットを左詰めに配置
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0;
                                    i < jobDetailList["tag"].length;
                                    i++)
                                  TextButton(
                                      onPressed: () => {
                                            Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      SearchPage(
                                                    text: jobDetailList["tag"]
                                                        [i]["name"],
                                                    eventJobJedge: "おすすめ求人",
                                                    sort: "新着順",
                                                  ),
                                                ))
                                          },
                                      child: Text(
                                          "#${jobDetailList["tag"][i]["name"]}")),
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
                        child: Text(jobDetailList["detail"]),
                      ),

                      //空白
                      SizedBox(
                        height: mediaQueryData.size.height / 50,
                      ),

                      //勤務期間
                      SizedBox(
                        width: width - 20,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "勤務期間",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 30,
                                ),
                                //短期or長期
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: termColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text("  ${jobDetailList["term"]}  ",
                                      style: GoogleFonts.mochiyPopOne(
                                          //fontWeight: FontWeight.bold
                                          )),
                                ),
                              ],
                            ),
                            //空白
                            SizedBox(
                              height: mediaQueryData.size.height / 100,
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                              children: [
                                for (int i = 0;
                                    i < jobDetailList["jobTimes"].length;
                                    i++)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // 子ウィジェットを左詰めに配置
                                    children: [
                                      //時間
                                      //短期の場合
                                      if (jobDetailList["term"] == "短期")
                                        Text(
                                            "${jobDetailList["jobTimes"][i]["start_time"].substring(0, 4)}年${jobDetailList["jobTimes"][i]["start_time"].substring(5, 7)}月${jobDetailList["jobTimes"][i]["start_time"].substring(8, 10)}日 ${jobDetailList["jobTimes"][i]["start_time"].substring(11, 16)}~${jobDetailList["jobTimes"][i]["end_time"].substring(11, 16)}")
                                      //長期の場合
                                      else if (jobDetailList["term"] == "長期")
                                        Text(
                                            "${jobDetailList["jobTimes"][i]["start_time"].substring(11, 16)}~${jobDetailList["jobTimes"][i]["end_time"].substring(11, 16)}"),
                                    ],
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),

                      //空白
                      SizedBox(
                        height: mediaQueryData.size.height / 50,
                      ),

                      //勤務場所
                      SizedBox(
                          width: width - 20,
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                              children: [
                                const Text(
                                  "勤務場所",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //空白
                                SizedBox(
                                  height: mediaQueryData.size.height / 100,
                                ),
                                Text(
                                    "〒${jobDetailList["postalNumber"]}  ${jobDetailList["prefecture"]}${jobDetailList["city"]}${jobDetailList["houseNumber"]}")
                              ])),

                      //空白
                      SizedBox(
                        height: mediaQueryData.size.height / 50,
                      ),

                      //給与
                      SizedBox(
                          width: width - 20,
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                              children: [
                                const Text(
                                  "給与",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //空白
                                SizedBox(
                                  height: mediaQueryData.size.height / 100,
                                ),
                                Text("時給 : ${jobDetailList["pay"]}円")
                              ])),

                      //空白
                      SizedBox(
                        height: mediaQueryData.size.height / 50,
                      ),

                      //イベント詳細
                      //任意入力が一つでもある場合のみ表示
                      if (jobDetailList["addMessage"] != null)
                        SizedBox(
                          width: width - 20,
                          child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
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
                                  height: mediaQueryData.size.height / 100,
                                ),

                                //追加メッセージ
                                if (jobDetailList["addMessage"] != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // 子ウィジェットを左詰めに配置
                                    children: [
                                      const Text("追加メッセージ："),
                                      Text(jobDetailList["addMessage"]),
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

                      SizedBox(
                          width: width - 20,
                          //height: 400,
                          //color: Colors.blue,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
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
                                        "${jobDetailList["reviewPoint"].toString()} ",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: width / 8,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline, //下線
                                          decorationThickness: 2, // 下線の太さの設定
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      for (int i = 4; i >= 0; i--)
                                        Row(
                                          children: [
                                            Text(
                                              "${i + 1} ",
                                              style: TextStyle(
                                                fontSize: width / 40,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Stack(children: [
                                              Container(
                                                height: width / 40,
                                                width: width / 2,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Container(
                                                height: width / 40,
                                                width: width /
                                                    2 *
                                                    jobDetailList[
                                                        "ratioStarReviews"][i],
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow[800],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              )
                                            ])
                                          ],
                                        ),
                                      Text(
                                          "${jobDetailList["reviewNumber"]}件のレビュー")
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
                                    //投稿済み
                                    if (jobDetailList["reviewId"] != 0) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('投稿済みです'),
                                            content: const Text(
                                                'このイベント広告にはレビューを投稿済みです。'),
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
                                    }
                                    //未投稿
                                    else {
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
                                                  Text(
                                                      "※レビューは一般公開され、あなたのアカウント情報が含まれます",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors
                                                              .grey[600])),
                                                  //空白
                                                  SizedBox(height: width / 40),
                                                  //動的に星の色を変える
                                                  StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                                StateSetter
                                                                    setState) =>
                                                            ToggleButtons(
                                                      fillColor:
                                                          Colors.white, //選択中の色
                                                      borderWidth: 0, //枠線の太さ
                                                      borderColor:
                                                          Colors.white, //枠線の色
                                                      selectedBorderColor: Colors
                                                          .white, //選択中の枠線の色,

                                                      onPressed: (int index) {
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
                                                                  index + 1;
                                                              buttonIndex < 5;
                                                              buttonIndex++) {
                                                            _isSelected[
                                                                    buttonIndex] =
                                                                false;
                                                          }
                                                        });
                                                      },

                                                      isSelected: _isSelected,
                                                      children: List.generate(
                                                        5,
                                                        (index) => Icon(
                                                          Icons.star,
                                                          color: _isSelected[
                                                                  index]
                                                              ? Colors
                                                                  .yellow[800]
                                                              : Colors.grey,
                                                          size: 35,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //タイトル
                                                  SizedBox(height: width / 40),
                                                  SizedBox(
                                                    width: width,
                                                    child: const Text("タイトル",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                      width: width,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                203, 202, 202),
                                                            width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: TextField(
                                                            maxLines: null,
                                                            maxLength: 50,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                            decoration:
                                                                const InputDecoration(
                                                              //counterText: '',
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText: 'ここに入力',
                                                            ),
                                                            onChanged: (text) =>
                                                                titleWrite(
                                                                    text),
                                                          ),
                                                        ),
                                                      )),
                                                  //詳細
                                                  //空白
                                                  SizedBox(height: width / 40),
                                                  SizedBox(
                                                    width: width,
                                                    child: const Text("詳細",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Container(
                                                      width: width,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                203, 202, 202),
                                                            width: 1.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: TextField(
                                                            maxLines: null,
                                                            maxLength: 500,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText: 'ここに入力',
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              '未入力の項目があります'),
                                                          content: const Text(
                                                              'タイトルと詳細を入力してください'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  '閉じる'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              '投稿確認'),
                                                          content: const Text(
                                                              'この内容で投稿しますか？'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  '投稿'),
                                                              onPressed: () {
                                                                reviewWrite(
                                                                    jobDetailList[
                                                                        "id"],
                                                                    store);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                          '投稿完了'),
                                                                      content:
                                                                          const Text(
                                                                              '投稿が完了しました'),
                                                                      actions: <Widget>[
                                                                        TextButton(
                                                                          child:
                                                                              const Text('閉じる'),
                                                                          onPressed:
                                                                              () {
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
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
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
                                                child: const Text('閉じる'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
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
                              if (jobDetailList["review"].length == 0)
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
                                //height: (160 * jobDetailList["review"].length).toDouble(),
                                child: Column(
                                  children: [
                                    for (int index = 0;
                                        index < jobDetailList["review"].length;
                                        index++)
                                      Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minHeight: 150, //最小の高さ
                                            ),
                                            child: Container(
                                              //height: 150,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors
                                                        .grey[400]!, //枠線の色
                                                    width: 0.7, //枠線の太さ
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  50), //空白
                                                          //ユーザー名
                                                          Text(jobDetailList[
                                                                      "review"][
                                                                  index]["user"]
                                                              ["username"]),
                                                        ],
                                                      ),

                                                      //通報ボタン===================================================================
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              for (int buttonIndex =
                                                                      0;
                                                                  buttonIndex <=
                                                                      jobDetailList["review"][index]
                                                                              [
                                                                              "review_point"] -
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
                                                                    text: jobDetailList["review"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "title"]);
                                                            final TextEditingController
                                                                detailController =
                                                                TextEditingController(
                                                                    text: jobDetailList["review"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "review"]);
                                                            showDialog(
                                                              context: context,
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
                                                                    if (jobDetailList["review"][index]["user"]
                                                                            [
                                                                            "id"] ==
                                                                        store
                                                                            .myID)
                                                                      Center(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              width / 2,
                                                                          child:
                                                                              const Text(
                                                                            "編集・削除",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    if (jobDetailList["review"][index]["user"]
                                                                            [
                                                                            "id"] ==
                                                                        store
                                                                            .myID)
                                                                      SimpleDialogOption(
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                          Navigator.pop(
                                                                              context),
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                                                    reviewEdit(jobDetailList["id"], store);
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
                                                                        child: const Text(
                                                                            "レビューを編集"),
                                                                      ),
                                                                    if (jobDetailList["review"][index]["user"]
                                                                            [
                                                                            "id"] ==
                                                                        store
                                                                            .myID)
                                                                      SimpleDialogOption(
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                          reviewDelite(
                                                                              jobDetailList["id"],
                                                                              store),
                                                                          Navigator.pop(
                                                                              context),
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                        child: const Text(
                                                                            "レビューを削除"),
                                                                      ),
                                                                    Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            width /
                                                                                2,
                                                                        child:
                                                                            const Text(
                                                                          "通報",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SimpleDialogOption(
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                        Navigator.pop(
                                                                            context),
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
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
                                                                      child: const Text(
                                                                          "不適切なレビューとして報告"),
                                                                    ),
                                                                    SimpleDialogOption(
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                        Navigator.pop(
                                                                            context),
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
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
                                                                      child: const Text(
                                                                          "スパムとして報告"),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.more_vert,
                                                            color: Colors
                                                                .grey[500],
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: width / 60), //空白
                                                  Text(
                                                      jobDetailList["review"]
                                                          [index]["title"],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                      height: width / 60), //空白
                                                  //評価
                                                  Row(
                                                    children: [
                                                      //星(色あり)
                                                      for (int i = 0;
                                                          i <
                                                              jobDetailList[
                                                                          "review"]
                                                                      [index][
                                                                  "review_point"];
                                                          i++)
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellow[800],
                                                          size: 15,
                                                        ),
                                                      //星(色なし)
                                                      for (int i = 0;
                                                          i <
                                                              5 -
                                                                  jobDetailList[
                                                                              "review"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "review_point"];
                                                          i++)
                                                        Icon(
                                                            Icons.star,
                                                            color: Colors
                                                                .grey[400],
                                                            size: 15),
                                                      SizedBox(
                                                          width:
                                                              width / 60), //空白
                                                      //評価日時放置
                                                      Text(
                                                          "${jobDetailList["review"][index]["updated_at"].substring(0, 4)}年${jobDetailList["review"][index]["updated_at"].substring(5, 7)}月${jobDetailList["review"][index]["updated_at"].substring(8, 10)}日",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .grey[500])),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: width / 60), //空白
                                                  //レビュー内容
                                                  Text(jobDetailList["review"]
                                                      [index]["review"]),
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
