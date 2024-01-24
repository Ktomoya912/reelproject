import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/job/job_post_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//ローディング

//求人広告リストコンポーネント
class JobAdvertisementList extends StatefulWidget {
  const JobAdvertisementList({
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

  static String dayString = "時給 : ";
  static String timeString = "時間 : ";
  static String placeString = "場所 : ";

  static String enString = "円";

  @override
  State<JobAdvertisementList> createState() => _JobAdvertisementListState();
}

class _JobAdvertisementListState extends State<JobAdvertisementList> {
  Map<String, dynamic> jobDetailList = {
    "id": 0,
    //必須
    //画像
    "image_url": "",
    //タイトル
    "title": "",
    //詳細
    "detail": "",
    //勤務体系
    "term": "長期",

    //開催期間
    "jobTimes": [
      {
        "start_time": "2024-01-18T15:21:23",
        "end_time": "2024-01-18T16:21:23",
        "id": 10
      }
    ],

    //開催場所
    "postalNumber": "", //郵便番号
    "prefecture": "", //都道府県
    "city": "", //市町村
    "houseNumber": "", //番地・建物名

    //給料
    "pay": "時給1000円",

    //その他(任意)
    "tag": [], //ハッシュタグ
    "addMessage": "", //追加メッセージ

    //レビュー
    "reviewPoint": 0, //評価
    //星の割合(前から1,2,3,4,5)
    "ratioStarReviews": [0.0, 0.0, 0.0, 0.0, 0.0],
    //レビュー数
    "reviewNumber": 0,
    //自分のレビューか否か
    "reviewId": 0,
    //レビュー内容
    "review": [],

    //この広告を投稿したか
    "postJedge": false,

    //未投稿か否か(true:未投稿,false:投稿済み)
    "notPost": true,

    //お気に入りか否か]
    "favoriteJedge": false,

    //掲載期間
    "postTerm": "2023年12月10日",

    //プラン情報
    "parchase": {}
  };

  changeJobList(dynamic data, int id, ChangeGeneralCorporation store) {
    setState(() {
      jobDetailList["id"] = id; //id
      jobDetailList["image_url"] = data["image_url"]; //画像
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
      //時給
      jobDetailList["pay"] = data["salary"]; //給料
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
      jobDetailList["ratioStarReviews"] = [
        0.0,
        0.0,
        0.0,
        0.0,
        0.0
      ]; //星の割合(前から1,2,3,4,5)
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

      //この広告を投稿したか
      if (data["author"]["id"] == store.myID) {
        jobDetailList["postJedge"] = true;
      } else {
        jobDetailList["postJedge"] = false;
      }

      //未投稿か否か
      jobDetailList["notPost"] = widget.notPostJedge;

      //投稿期間
      jobDetailList["postTerm"] =
          "${data["purchase"]["expiration_date"].substring(0, 4)}年${data["purchase"]["expiration_date"].substring(5, 7)}月${data["purchase"]["expiration_date"].substring(8, 10)}日";

      //プラン情報
      jobDetailList["parchase"] = data["purchase"];
    });
  }

  Future getJobList(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/jobs/$id');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeJobList(data, id, store);
    } else {
      setState(() {
        notJobJedge = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notJobJedge = false;
  }

  //スクロール位置を取得するためのコントローラー
  final ScrollController _scrollController = ScrollController();

  bool notJobJedge = false; //イベント広告がないか否か

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

    // void changeScrollController() async {
    //reloadEventJedgeがtrueの場合、Home画面をリロードする
    if (store.reloadJobScroll) {
      //widget.functionCall();
      // スクロール位置をリセットします。
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
      store.changeReloadJobScrollOn(false); //リロード後、falseに戻す
      //store.changeReloadJobJedgeOn(false); //リロード後、falseに戻す
      //0.5秒待つ
      // await Future.delayed(
      //     const Duration(milliseconds: ChangeGeneralCorporation.waitTime));
      // //ローディングをpop
      // Navigator.of(context, rootNavigator: true).pop();
    }
    // }

    // changeScrollController();

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => changeScrollController());

    // changeScrollController();

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
                  await getJobList(
                      widget.advertisementList.elementAt(index)["id"], store);
                  await Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  JobPostDetail(
                                    id: widget.advertisementList
                                        .elementAt(index)["id"],
                                    tStore: store,
                                    notPostJedge: widget.notPostJedge,
                                    jobDetailList: jobDetailList,
                                    notJobJedge: notJobJedge,
                                  )));
                  widget.functionCall();
                  notJobJedge = false;
                  //タップ処理
                },
                child:
                    //ボタン全体のサイズ
                    SizedBox(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center, //横方向真ん中寄寄せ
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // ここで配置を設定します
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
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, //左寄せ
                              children: [
                                //時給
                                Text(
                                    "時給 : ${widget.advertisementList.elementAt(index)["salary"].substring(2)}",
                                    style: const TextStyle(fontSize: 14)),
                                //時間
                                if (widget.advertisementList
                                    .elementAt(index)["is_one_day"])
                                  Text(
                                    "時間 : ${widget.advertisementList.elementAt(index)["job_times"][0]["start_time"].substring(11, 16)}~${widget.advertisementList.elementAt(index)["job_times"][0]["end_time"].substring(11, 16)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                //場所
                                Text(
                                    JobAdvertisementList.placeString +
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
                        // width: (widget.mediaQueryData.size.width / 12 * 5) -
                        //     (addWidth) +
                        //     10,
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
                                            height: imageWidthPower,
                                            width: imageWidthPower,
                                            //画像
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: store.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ClipRRect(
                                                  // これを追加
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // これを追加
                                                  child: Image.network(
                                                      widget.advertisementList
                                                          .elementAt(index)[
                                                              "image_url"]
                                                          .toString(),
                                                      fit: BoxFit.cover),
                                                ))),
                                      ],
                                    ),
                                  ),
                                  //長期、短期タグ
                                  //長期短期の判定は時間がnullかどうかで判定
                                  //長期
                                  if (widget.advertisementList
                                          .elementAt(index)["is_one_day"] ==
                                      false)
                                    Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "長期",
                                          style: GoogleFonts.mochiyPopOne(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    )
                                  //短期
                                  else
                                    Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[500],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "短期",
                                          style: GoogleFonts.mochiyPopOne(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    )
                                ]),
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
                        width: JobAdvertisementList.lineWidth),
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
