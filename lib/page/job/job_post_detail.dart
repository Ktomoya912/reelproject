import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/listView/review.dart';
import 'package:reelproject/component/appbar/detail_appbar.dart';
import 'package:reelproject/component/listView/carousel.dart';
import 'package:reelproject/page/event/search_page.dart'; //イベント検索

class JobPostDetail extends StatefulWidget {
  const JobPostDetail({
    super.key,
    required this.jobList,
  });

  final Map<String, dynamic> jobList;

  @override
  State<JobPostDetail> createState() => _JobPostDetailState();
}

class _JobPostDetailState extends State<JobPostDetail> {
  late Map<String, dynamic> jobDetailList;

  @override
  void initState() {
    super.initState();
    jobDetailList = widget.jobList;
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

  bool favoriteJedge = false; //お気に入り判定

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得

    //短期or長期の色
    MaterialColor termColor = Colors.green;
    if (jobDetailList["term"] == "短期") {
      termColor = Colors.lightGreen;
    } else if (jobDetailList["term"] == "長期") {
      termColor = Colors.yellow;
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
      ),
      //body
      body: SingleChildScrollView(
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
                              isSelected: [favoriteJedge], //on off
                              //ボタンを押した時の処理
                              onPressed: (int index) => setState(() {
                                favoriteJedge = !favoriteJedge;
                              }),
                              //アイコン
                              children: <Widget>[
                                favoriteJedge
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
                                                  text: jobDetailList["tag"][i],
                                                  eventJobJedge: "おすすめ求人",
                                                  sort: "新着順",
                                                ),
                                              ))
                                        },
                                    child: Text("#${jobDetailList["tag"][i]}")),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text("  ${jobDetailList["term"]}  ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
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
                                  i < jobDetailList["day"].length;
                                  i++)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // 子ウィジェットを左詰めに配置
                                  children: [
                                    //時間
                                    //短期の場合
                                    if (jobDetailList["term"] == "短期")
                                      Text(jobDetailList["day"][i] +
                                          "   " +
                                          jobDetailList["time"][i])
                                    //長期の場合
                                    else if (jobDetailList["term"] == "長期")
                                      Text(jobDetailList["time"][i]),
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

                    Review(
                      width: width,
                      eventDetailList: jobDetailList,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
