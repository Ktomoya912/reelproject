import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:reelproject/page/event/event.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/listView/review.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  //求人広告のリスト
  //titleに文字数制限を設ける
  static Map<String, dynamic> eventDetailList = {
    //必須
    "title": "川上神社夏祭り", //タイトル
    //詳細
    "detail":
        "川上様夏祭りは香北の夏の風物詩ともいえるお祭で、ビアガーデンや各種団体による模擬店、ステージイベントなどが行われ、毎年市内外から多くの見物客が訪れます。\n \n ステージイベント、宝さがし、鎮守の杜のびらふマルシェなど、子どもから大人まで誰でも楽しめるイベント内容が盛りだくさん！",
    "day": ["2021年8月1日", "2021年8月2日", "2021年8月2日"], //日付
    "time": ["10時00分~20時00分", "10時00分~20時00分", "10時00分~20時00分"], //時間
    //開催場所
    "postalNumber": ["781-5101", "781-5101", "781-5101"], //郵便番号
    "prefecture": ["高知県", "高知県", "高知県"], //都道府県
    "city": ["香美市", "香美市", "香美市"], //市町村
    "houseNumber": ["川上町", "川上町", "土佐山田町"], //番地・建物名

    //その他(任意)
    "tag": [
      "イベント",
      "夏祭り",
      "花火",
      "香美市",
      "イベント",
    ], //ハッシュタグ
    "phone": "0887-00-0000", //電話番号
    "mail": "conf@gmai.com", //メールアドレス
    "url": "https://www.city.kami.lg.jp/", //URL
    "fee": "1000", //参加費
    "Capacity": "100", //定員
    "notes": "駐車場はありません。", //注意事項
    "addMessage": "test", //追加メッセージ

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
      {
        "reviewerName": "名前sasisuseso",
        //"reviewerImage" : "test"   //予定
        "reviewPoint": 3, //レビュー点数
        "reviewDetail": "test", //レビュー内容
        "reviewDate": "2021年8月1日", //レビュー日時
      }
    ]
  };

  bool favoriteJedge = false; //お気に入り判定

  //二度同じ場所を表示しないように制御する関数
  Widget generateWidgets(int i, double height) {
    if (i == 0) {
      return Text(
          eventDetailList["postalNumber"][i] +
              "〒" +
              "   " +
              eventDetailList["prefecture"][i] +
              eventDetailList["city"][i] +
              eventDetailList["houseNumber"][i],
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
    return Scaffold(
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
                    SizedBox(
                      height: mediaQueryData.size.height * 0.05,
                    ),
                    //画像
                    Stack(children: [
                      Container(
                        alignment: Alignment.topRight,
                        height: width * 0.6,
                        //width: width,
                        color: Colors.blue,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: width * 0.09, //高さ
                          width: width * 0.09, //幅
                          //円の装飾
                          decoration: BoxDecoration(
                            color: store.whiteColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          //円の中のアイコン
                          child: IconButton(
                              onPressed: () => {Navigator.pop(context)},
                              icon: Icon(Icons.arrow_back,
                                  color: store.greyColor)),
                        ),
                      )
                    ]),
                    //タイトル
                    Row(
                      children: [
                        //タイトル
                        SizedBox(
                          width: width * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              eventDetailList["title"],
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        //お気に入りボタン
                        SizedBox(
                          width: width * 0.2 - 5,
                          child: ToggleButtons(
                            color: store.greyColor, //選択していない時の色
                            selectedColor: store.mainColor, //選択時の色
                            fillColor: store.thinColor, //選択時の背景色
                            splashColor: store.subColor, //選択時のアクションの色
                            borderRadius: BorderRadius.circular(50.0), //角丸
                            isSelected: [favoriteJedge], //on off
                            //ボタンを押した時の処理
                            onPressed: (int index) => setState(() {
                              favoriteJedge = !favoriteJedge;
                            }),
                            //アイコン
                            children: const <Widget>[
                              Icon(Icons.favorite, size: 40),
                            ],
                          ),
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
                            mainAxisAlignment:
                                MainAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0;
                                  i < eventDetailList["tag"].length;
                                  i++)
                                TextButton(
                                    onPressed: () => {},
                                    child:
                                        Text("#${eventDetailList["tag"][i]}")),
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            children: [
                              for (int i = 0;
                                  i < eventDetailList["day"].length;
                                  i++)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // 子ウィジェットを左詰めに配置
                                  children: [
                                    //場所
                                    generateWidgets(
                                        i, mediaQueryData.size.height / 100),

                                    //時間
                                    Text(eventDetailList["day"][i] +
                                        "   " +
                                        eventDetailList["time"][i]),
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

                    //イベント詳細
                    //任意入力が一つでもある場合のみ表示
                    if (eventDetailList["phone"] != null ||
                        eventDetailList["mail"] != null ||
                        eventDetailList["url"] != null ||
                        eventDetailList["fee"] != null ||
                        eventDetailList["Capacity"] != null ||
                        eventDetailList["notes"] != null ||
                        eventDetailList["addMessage"] != null)
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
                              //イベント参加費
                              if (eventDetailList["fee"] != null)
                                Text("参加費：${eventDetailList["fee"]}円"),
                              //定員
                              if (eventDetailList["Capacity"] != null)
                                Text("定員：${eventDetailList["Capacity"]}人"),

                              //空白
                              SizedBox(
                                height: mediaQueryData.size.height / 200,
                              ),

                              //電話番号
                              if (eventDetailList["phone"] != null)
                                Text("電話番号：${eventDetailList["phone"]}"),
                              //メールアドレス
                              if (eventDetailList["mail"] != null)
                                Text("メールアドレス：${eventDetailList["mail"]}"),
                              //URL
                              if (eventDetailList["url"] != null)
                                Text("URL：${eventDetailList["url"]}"),

                              //空白
                              SizedBox(
                                height: mediaQueryData.size.height / 50,
                              ),

                              //注意事項
                              if (eventDetailList["notes"] != null)
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
                              if (eventDetailList["addMessage"] != null)
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

                    Review(
                      width: width,
                      eventDetailList: eventDetailList,
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
