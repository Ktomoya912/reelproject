import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/event/event_post_detail.dart';

//イベント広告リストコンポーネント
class EventAdvertisementList extends StatelessWidget {
  const EventAdvertisementList({
    super.key,
    required this.advertisementList,
    required this.mediaQueryData,
  });

  final List<Map<String, dynamic>> advertisementList;
  final MediaQueryData mediaQueryData;

  static double lineWidth = 0.7; //線の太さ定数

  static String dayString = "開催日     : ";
  static String timeString = "開催時間 : ";
  static String placeString = "開催場所 : ";

// データベースと連携させていないので現在はここでイベント詳細内容を設定
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
    "postTerm": "2023年12月10日"
  };
// -------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    double buttonWidthPower = mediaQueryData.size.width / 4; //ボタンの縦横幅
    //画像の縦横幅の最大、最小値
    if (buttonWidthPower > 230) {
      buttonWidthPower = 230;
    } else if (buttonWidthPower < 170) {
      buttonWidthPower = 170;
    }
    double imageWidthPower =
        buttonWidthPower - mediaQueryData.size.width / 40; //画像の縦横幅
    //横幅が想定より大きくなった場合、横の幅を広げる
    //その時足し加える値
    double addWidth = 0;
    //横のほうが広くなった場合
    if (mediaQueryData.size.width > mediaQueryData.size.height) {
      addWidth = (mediaQueryData.size.width - mediaQueryData.size.height) / 3;
    }

    return Expanded(
      child: ListView.builder(
        itemCount: advertisementList.length, //要素数
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              //ボタン
              InkWell(
                onTap: () {
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
                          width: (mediaQueryData.size.width / 100) + addWidth),
                      //左の文
                      SizedBox(
                        width:
                            (mediaQueryData.size.width / 12 * 6) - (addWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
                          mainAxisSize: MainAxisSize.min, //縦方向真ん中寄せ
                          children: [
                            //タイトル
                            Text(
                              advertisementList.elementAt(index)["title"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, //左寄せ
                              children: [
                                //開催日
                                Text(
                                    dayString +
                                        advertisementList
                                            .elementAt(index)["day"],
                                    style: const TextStyle(fontSize: 18)),
                                //開催時
                                Text(
                                    timeString +
                                        advertisementList
                                            .elementAt(index)["time"],
                                    style: const TextStyle(fontSize: 18)),
                                //開催場所
                                Text(
                                    placeString +
                                        advertisementList
                                            .elementAt(index)["place"],
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //画像
                      SizedBox(
                        height: buttonWidthPower + 10, //ボタン全体の高さ,
                        width:
                            (mediaQueryData.size.width / 12 * 5) - (addWidth),
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
                          width: (mediaQueryData.size.width / 100) + addWidth),
                    ],
                  ),
                ),
              ),
              //下線
              Container(
                width: mediaQueryData.size.width -
                    (mediaQueryData.size.width / 20) -
                    addWidth * 2,
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: store.greyColor, width: lineWidth),
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
