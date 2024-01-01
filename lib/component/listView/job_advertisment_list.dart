import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/job/job_post_detail.dart';

//求人広告リストコンポーネント
class JobAdvertisementList extends StatelessWidget {
  const JobAdvertisementList({
    super.key,
    required this.advertisementList,
    required this.mediaQueryData,
  });

  final List<Map<String, dynamic>> advertisementList;
  final MediaQueryData mediaQueryData;

  static double lineWidth = 1.3; //線の太さ定数

  static String dayString = "時給 : ";
  static String timeString = "時間 : ";
  static String placeString = "場所 : ";

  static String enString = "円";

// データベースと連携させていないので現在はここでイベント詳細内容を設定
  static Map<String, dynamic> jobDetailList = {
    //必須
    "title": "川上神社夏祭り", //タイトル
    //詳細
    "detail":
        "川上様夏祭りは香北の夏の風物詩ともいえるお祭で、ビアガーデンや各種団体による模擬店、ステージイベントなどが行われ、毎年市内外から多くの見物客が訪れます。\n \n この度、運営スタッフ不足によりスタッフを募集します。\n \n・当日の会場設営\n・祭り終了後のゴミ拾い\n・祭り開催中のスタッフ（内容は当日お知らせします）",
    //勤務体系
    "term": "長期",

    "day": ["2021年8月1日", "2021年8月2日", "2021年8月2日"], //日付
    "time": ["10時00分~20時00分", "10時00分~20時00分", "10時00分~20時00分"], //時間

    //開催場所
    "postalNumber": "781-5101", //郵便番号
    "prefecture": "高知県", //都道府県
    "city": "香美市", //市町村
    "houseNumber": "土佐山田町", //番地・建物名

    //給料
    "pay": "1000",

    //その他(任意)
    "tag": [
      "イベント",
      "夏祭り",
      "花火",
      "香美市",
      "イベント",
    ], //ハッシュタグ
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
    ],

    //この広告を投稿したか
    "postJedge": true,

    //掲載期間
    "postTerm": "2023年12月10日"
  };

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
                                  JobPostDetail(jobList: jobDetailList)));
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
                                //時給
                                Text(
                                    dayString +
                                        advertisementList
                                            .elementAt(index)["pay"] +
                                        enString,
                                    style: const TextStyle(fontSize: 18)),
                                //時間
                                if (advertisementList
                                        .elementAt(index)["time"] !=
                                    null)
                                  Text(
                                    timeString +
                                        advertisementList
                                            .elementAt(index)["time"],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                //場所
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
                        width: (mediaQueryData.size.width / 12 * 5) -
                            (addWidth) +
                            10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, //右寄せ
                          children: [
                            //重ねる
                            Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: <Widget>[
                                  SizedBox(
                                    height: imageWidthPower + 10,
                                    width: imageWidthPower + 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center, //中央寄せ
                                      children: [
                                        SizedBox(
                                          //画像
                                          child: Container(
                                            height: imageWidthPower,
                                            width: imageWidthPower,
                                            decoration: BoxDecoration(
                                              color: store.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //長期、短期タグ
                                  //長期短期の判定は時間がnullかどうかで判定
                                  //長期
                                  if (advertisementList
                                          .elementAt(index)["time"] ==
                                      null)
                                    Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "長期",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  //短期
                                  else
                                    Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "短期",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                ]),
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
