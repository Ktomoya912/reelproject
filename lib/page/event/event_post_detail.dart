import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/component/appbar/detail_appbar.dart';
//import 'package:reelproject/page/event/event.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/listView/review.dart';
import 'package:reelproject/component/listView/carousel.dart';

class EventPostDetail extends StatefulWidget {
  const EventPostDetail({
    super.key,
    required this.eventList,
  });

  final Map<String, dynamic> eventList;

  @override
  State<EventPostDetail> createState() => _EventPostDetailState();
}

class _EventPostDetailState extends State<EventPostDetail> {
  late Map<String, dynamic> eventDetailList;

  @override
  void initState() {
    super.initState();
    eventDetailList = widget.eventList;
  }

  //求人広告のリスト
  //titleに文字数制限を設ける
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
      //アップバー
      appBar: DetailAppbar(
        postJedge: eventDetailList["postJedge"],
        eventJobJedge: "event",
        postTerm: eventDetailList["postTerm"],
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
