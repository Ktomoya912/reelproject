// import 'dart:js_interop';
//使用していないためコメントアウト

//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/page/home/notice.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/mypage/apply_hist.dart';
import 'package:reelproject/page/mypage/posted_list.dart';
import 'package:reelproject/page/mypage/watch_history.dart';
import 'package:reelproject/page/mypage/favorite_list.dart';
import 'package:reelproject/page/job/job_post_detail.dart';
import 'package:reelproject/page/event/event_post_detail.dart';
import 'package:reelproject/component/listView/carousel.dart';
// import 'package:reelproject/page/event/event_post_detail.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:reelproject/overlay/rule/screen/select_post.dart'; //投稿選択画面
import 'package:google_fonts/google_fonts.dart'; //googleフォント
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
//job_fee_watch.dartからのimport

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({
    super.key,
  });
}

@RoutePage()
class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int index = 0; //BottomAppBarのIcon番号

  bool notEventJedge = false; //イベントがない場合の判定
  bool notJobJedge = false; //イベントがない場合の判定

  changeNotJedge() {
    if (mounted) {
      setState(() {
        notEventJedge = false; //イベントがない場合の判定
        notJobJedge = false; //イベントがない場合の判定
      });
    }
  }

  //閲覧履歴リスト
  List<dynamic> historyList = [];

  void changeHistoryList(List<dynamic> e) {
    if (mounted) {
      setState(() {
        historyList = e;
      });
    }
  }

  static List<dynamic> eventAdvertisementList = [];
  void changeEventAdvertisementList(List<dynamic> e) {
    if (mounted) {
      setState(() {
        eventAdvertisementList = e;
      });
    }
  }

  static List<dynamic> jobAdvertisementList = [];
  void changeJobAdvertisementList(List<dynamic> e) {
    if (mounted) {
      setState(() {
        jobAdvertisementList = e;
      });
    }
  }

  Future getEventList() async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/events/?${ChangeGeneralCorporation.typeActive}&${ChangeGeneralCorporation.sortPv}&order=asc&offset=0&limit=5');

    final response =
        await http.get(url, headers: {'accept': 'application/json'});
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeEventAdvertisementList(json.decode(data));
    } else {
      //throw Exception("Failed");
    }
  }

  Future getJobList() async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.typeActive}&${ChangeGeneralCorporation.sortPv}&order=asc&offset=0&limit=5');
    final response =
        await http.get(url, headers: {'accept': 'application/json'});
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeJobAdvertisementList(json.decode(data));
    } else {
      //throw Exception("Failed");
    }
  }

  Future getHistoryList(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/events/?${ChangeGeneralCorporation.sortLastWatched}&order=asc&offset=0&limit=10&${ChangeGeneralCorporation.typeActive}&user_id=${store.myID}&target=history');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeHistoryList(json.decode(data));
    } else {
      //throw Exception("Failed");
    }
  }

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

  changeJobDetailList(dynamic data, int id, ChangeGeneralCorporation store) {
    if (mounted) {
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
        jobDetailList["notPost"] = false;

        //投稿期間
        jobDetailList["postTerm"] =
            "${data["purchase"]["expiration_date"].substring(0, 4)}年${data["purchase"]["expiration_date"].substring(5, 7)}月${data["purchase"]["expiration_date"].substring(5, 7)}日";

        //プラン情報
        jobDetailList["parchase"] = data["purchase"];
      });
    }
  }

  Future getJobDetailList(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/jobs/$id');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeJobDetailList(data, id, store);
    } else {
      notJobJedge = true;
    }
  }

  late Map<String, dynamic> eventDetailList = {
    //id
    "id": 1,
    //必須
    //画像
    "image_url": "",
    //タイトル
    "title": "",
    //詳細
    "detail": "",
    "eventTimes": [
      {
        "start_time": "2024-01-18T15:21:23",
        "end_time": "2024-01-18T16:21:23",
        "id": 10
      }
    ], //開催日時
    //開催場所
    "postalNumber": "", //郵便番号
    "prefecture": "", //都道府県
    "city": "", //市町村
    "houseNumber": "", //番地・建物名

    //その他(任意)
    "tag": [], //ハッシュタグ
    "phone": "", //電話番号
    "mail": "", //メールアドレス
    "url": "", //URL
    "fee": "", //参加費
    "Capacity": "", //定員
    "notes": "", //注意事項
    "addMessage": "", //追加メッセージ

    //レビュー
    "reviewPoint": 0, //評価
    //星の割合(前から1,2,3,4,5)
    "ratioStarReviews": [0.0, 0.0, 0.0, 0.0, 0.0],
    //レビュー数
    "reviewNumber": 0,
    //投稿ID
    "reviewId": 0,
    //レビュー内容
    "review": [],

    //この広告を投稿したか
    "postJedge": false,

    //未投稿か否か(true:未投稿,false:投稿済み)
    "notPost": false,

    //掲載期間
    "postTerm": "2023年12月10日",

    //お気に入りか否か
    "favoriteJedge": false,

    //プラン情報
    "parchase": {}
  };

  //late bool favoriteJedge = eventDetailList["favoriteJedge"]; //お気に入り判定

  changeEventDetailList(dynamic data, int id, ChangeGeneralCorporation store) {
    if (mounted) {
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
        eventDetailList["notPost"] = false;
        //投稿期間
        eventDetailList["postTerm"] =
            "${data["purchase"]["expiration_date"].substring(0, 4)}年${data["purchase"]["expiration_date"].substring(5, 7)}月${data["purchase"]["expiration_date"].substring(5, 7)}日";

        //プラン情報
        eventDetailList["parchase"] = data["purchase"];
      });
    }
  }

  Future getEventDetailList(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/events/$id');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
    final data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      changeEventDetailList(data, id, store);
    } else {
      notEventJedge = true;
    }
  }

  //スクロール位置を取得するためのコントローラー
  ScrollController homeScrollController = ScrollController();

  @override
  void dispose() {
    // タイマーやアニメーションのリスナーをここでキャンセルします
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store =
          Provider.of<ChangeGeneralCorporation>(context, listen: false);
      getHistoryList(store);
      getEventList();
      getJobList();
      store.getMyUserInfo();
      notEventJedge = false; //イベントがない場合の判定
      notJobJedge = false; //イベントがない場合の判定
    });
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    //Home画面リロード用の関数
    void reloadHome() async {
      //reloadHomeJedgeがtrueの場合、Home画面をリロードする
      if (store.reloadHomeJedge) {
        //ここにHome画面リロードの処理を記述
        // // スクロール位置をリセットします。

        // await Future.delayed(Duration(microseconds: 1));

        getEventList();
        getJobList();
        getHistoryList(store);
        notEventJedge = false; //イベントがない場合の判定
        notJobJedge = false; //イベントがない場合の判定

        homeScrollController
            .jumpTo(homeScrollController.position.minScrollExtent);

        store.changeReloadHomeJedgeOn(false); //リロード後、falseに戻す
        //0.5秒待つ
        await Future.delayed(
            const Duration(milliseconds: ChangeGeneralCorporation.waitTime));
        //ローディングをpop
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    //ビルド後に実行
    WidgetsBinding.instance.addPostFrameCallback((_) => reloadHome());

    // reloadHome();

    //ボタンリスト
    Map<String, List<Map<String, dynamic>>> buttonList = {
      //一般ボタンリスト
      "general": [
        // {
        //   "title": "閲覧履歴",
        //   "icon": Icons.history,
        //   "push": const WatchHistory(),
        // },
        {
          "title": "お気に入り",
          "icon": Icons.favorite,
          "push": FavoriteList(
            store: store,
          ),
        },
        {
          "title": "応募履歴",
          "icon": Icons.task,
          "push": ApplyHist(
            store: store,
          ),
        },
      ],
      //法人ボタンリスト
      "company": [
        {
          "title": "お気に入り",
          "icon": Icons.favorite,
          "push": FavoriteList(
            store: store,
          ),
        },
        {
          "title": "広告投稿",
          "icon": Icons.post_add,
          "push": "overlay",
          "overlay": SelectPost(),
        },
        {
          "title": "投稿一覧",
          "icon": Icons.summarize,
          "push": PostedList(
            store: store,
          ),
        }
      ]
    };

    //横画面サイズにより幅設定
    double widthBlank = (mediaQueryData.size.width / 2) - 300;
    if (widthBlank < 0) {
      widthBlank = 0;
    }
    double blank = mediaQueryData.size.width / 20;
    double width = mediaQueryData.size.width - (widthBlank * 2) - blank;

    // //中間ボタンのサイズ
    double centerButtonSize = (mediaQueryData.size.width / 7);
    if (centerButtonSize > 100) {
      centerButtonSize = 80;
    } else if (centerButtonSize < 60) {
      centerButtonSize = 60;
    }

    return Scaffold(
        //アップバー
        appBar: const MainAppBar(nextPage: Notice()),
        body: ShaderMaskComponent(
          child: SingleChildScrollView(
            controller: homeScrollController,
            // SingleChildScrollViewで子ウィジェットをラップ
            child: Center(
              child: Container(
                width: width + (widthBlank / 8) + blank,
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
                child: SizedBox(
                  width: width,

                  //height: mediaQueryData.size.height * 1.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, //縦方向に真ん中
                    children: [
                      SizedBox(height: mediaQueryData.size.height / 30), //空間
                      //注目イベント、求人コーナー
                      SizedBox(
                        height: width / 10 * 7,
                        width: width,
                        child: Carousel(
                          pages: [
                            for (int i = 0;
                                i <
                                    eventAdvertisementList.length +
                                        jobAdvertisementList.length;
                                i++)
                              //イベント広告

                              if (i < eventAdvertisementList.length)
                                Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter, //下寄せ
                                    children: [
                                      Container(
                                        height: width / 10 * 7,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: store.mainColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          // これを追加
                                          borderRadius: BorderRadius.circular(
                                              10), // これを追加
                                          child: Image.network(
                                              eventAdvertisementList
                                                  .elementAt(i)["image_url"]
                                                  .toString(),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      //全体を薄暗くする(ボタンの要素もある)
                                      GestureDetector(
                                        onTap: () async {
                                          await getEventDetailList(
                                              eventAdvertisementList
                                                  .elementAt(i)["id"],
                                              store);
                                          await Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      EventPostDetail(
                                                        id: eventAdvertisementList
                                                            .elementAt(i)["id"],
                                                        tStore: store,
                                                        notPostJedge: false,
                                                        eventDetailList:
                                                            eventDetailList,
                                                        notEventJedge:
                                                            notEventJedge,
                                                      )));
                                          getEventList();
                                          getJobList();
                                          getHistoryList(store);
                                          notEventJedge = false; //イベントがない場合の判定
                                          notJobJedge = false; //イベントがない場合の判定
                                        },
                                        child: Container(
                                          height: width / 10 * 7,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: ChangeGeneralCorporation
                                                .transparent,
                                            borderRadius: BorderRadius.circular(
                                                10.0), // ここで枠を丸く設定します
                                          ),
                                        ),
                                      ),

                                      //タイトル枠
                                      SizedBox(
                                        height: width / 10 * 7 / 3.5,
                                        width: width,
                                        child: Center(
                                          child: Text(
                                              eventAdvertisementList
                                                  .elementAt(i)["name"],
                                              //枠を超えたら省略
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ])
                              //求人広告
                              else
                                Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter, //下寄せ
                                    children: [
                                      Container(
                                        height: width / 10 * 7,
                                        width: width,
                                        decoration: BoxDecoration(
                                          color: store.mainColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          // これを追加
                                          borderRadius: BorderRadius.circular(
                                              10), // これを追加
                                          child: Image.network(
                                              jobAdvertisementList
                                                  .elementAt(i -
                                                      eventAdvertisementList
                                                          .length)["image_url"]
                                                  .toString(),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      //全体を薄暗くする(ボタンの要素もある)
                                      GestureDetector(
                                        onTap: () async {
                                          await getJobDetailList(
                                              jobAdvertisementList.elementAt(i -
                                                  eventAdvertisementList
                                                      .length)["id"],
                                              store);
                                          await Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      JobPostDetail(
                                                        id: jobAdvertisementList
                                                            .elementAt(i -
                                                                eventAdvertisementList
                                                                    .length)["id"],
                                                        tStore: store,
                                                        notPostJedge: false,
                                                        jobDetailList:
                                                            jobDetailList,
                                                        notJobJedge:
                                                            notJobJedge,
                                                      )));
                                          getEventList();
                                          getJobList();
                                          getHistoryList(store);
                                          notEventJedge = false; //イベントがない場合の判定
                                          notJobJedge = false; //イベントがない場合の判定
                                        },
                                        child: Container(
                                          height: width / 10 * 7,
                                          width: width,
                                          decoration: BoxDecoration(
                                            color: ChangeGeneralCorporation
                                                .transparent,
                                            borderRadius: BorderRadius.circular(
                                                10.0), // ここで枠を丸く設定します
                                          ),
                                        ),
                                      ),
                                      //タイトル枠
                                      SizedBox(
                                        height: width / 10 * 7 / 3.5,
                                        width: width,
                                        child: Center(
                                          child: Text(
                                              jobAdvertisementList.elementAt(i -
                                                  eventAdvertisementList
                                                      .length)["name"],
                                              //枠を超えたら省略
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ])
                          ],
                          timeJedge: false,
                        ),
                      ),
                      SizedBox(
                          height: mediaQueryData.size.height / 15), //ボタン間の空間
                      //中央ボタン
                      //一般ボタン
                      if (store.jedgeGC)
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, //横方向真ん中寄せ
                          children: [
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["general"]?[0],
                              getEventList: () => getEventList(),
                              getJobList: () => getJobList(),
                              getHistoryList: () => getHistoryList(store),
                            ),
                            SizedBox(width: centerButtonSize * 1.5), //ボタン間の空間
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["general"]?[1],
                              getEventList: () => getEventList(),
                              getJobList: () => getJobList(),
                              getHistoryList: () => getHistoryList(store),
                            ),
                            // SizedBox(width: centerButtonSize), //ボタン間の空間
                            // CenterButton(
                            //   centerButtonSize: centerButtonSize,
                            //   buttonList: buttonList["general"]?[2],
                            // ),
                          ],
                        )
                      //法人ボタン
                      else
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, //横方向真ん中寄せ
                          children: [
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["company"]?[0],
                              getEventList: () => getEventList(),
                              getJobList: () => getJobList(),
                              getHistoryList: () => getHistoryList(store),
                            ),
                            SizedBox(width: centerButtonSize), //ボタン間の空間
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["company"]?[1],
                              getEventList: () => getEventList(),
                              getJobList: () => getJobList(),
                              getHistoryList: () => getHistoryList(store),
                            ),
                            SizedBox(width: centerButtonSize), //ボタン間の空間
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["company"]?[2],
                              getEventList: () => getEventList(),
                              getJobList: () => getJobList(),
                              getHistoryList: () => getHistoryList(store),
                            ),
                          ],
                        ),
                      SizedBox(
                          height: mediaQueryData.size.height / 25), //ボタン間の空間
                      //閲覧履歴
                      SizedBox(
                        //color: Colors.blue,
                        width: width,
                        // height: width * 0.75,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("閲覧履歴(イベント)"),
                              ],
                            ),
                            //全ての閲覧履歴を見るボタン
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: store.mainColor,
                                  ),
                                  child: const Text('全ての閲覧履歴を見る'),
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                WatchHistory(
                                                  store: store,
                                                )));
                                    getEventList();
                                    getJobList();
                                    getHistoryList(store);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    mediaQueryData.size.height / 200), //ボタン間の空間
                            //閲覧履歴リスト
                            SingleChildScrollView(
                              //controller: _scrollControllerHistory,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  //履歴の数だけボタンを作成
                                  for (int i = 0; i < historyList.length; i++)
                                    HistoryButton(
                                      mediaQueryData: mediaQueryData,
                                      width: width,
                                      store: store,
                                      historyList: historyList,
                                      i: i,
                                      getEventList: () => getJobList(),
                                      getJobList: () => getJobList(),
                                      getHistoryList: () =>
                                          getHistoryList(store),
                                      getEventDetailList: () =>
                                          getEventDetailList(
                                              historyList[i]["id"], store),
                                      eventDetailList: eventDetailList,
                                      notEventJedge: notEventJedge,
                                      notEventJedgeFunction: () =>
                                          changeNotJedge(),
                                    ),
                                ],
                              ),
                            ),
                            //空白
                            const SizedBox(height: 20), //ボタン間の空間
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

//閲覧履歴ボタン
class HistoryButton extends StatelessWidget {
  const HistoryButton({
    super.key,
    required this.mediaQueryData,
    required this.store,
    required this.historyList,
    required this.i,
    required this.width,
    required this.getEventList,
    required this.getJobList,
    required this.getHistoryList,
    required this.getEventDetailList,
    required this.eventDetailList,
    required this.notEventJedge,
    required this.notEventJedgeFunction,
  });

  final MediaQueryData mediaQueryData;
  final ChangeGeneralCorporation store;
  final List<dynamic> historyList;
  final int i;
  final double width;
  final Function getEventList;
  final Function getJobList;
  final Function getHistoryList;
  final Function getEventDetailList;
  final Map<String, dynamic> eventDetailList;
  final bool notEventJedge;
  final Function notEventJedgeFunction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width * 0.5,
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              await getEventDetailList();
              await Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          EventPostDetail(
                            id: historyList[i]["id"],
                            tStore: store,
                            notPostJedge: false,
                            eventDetailList: eventDetailList,
                            notEventJedge: notEventJedge,
                          )));
              getEventList();
              getJobList();
              getHistoryList();
              notEventJedgeFunction();
              // Navigator.push(
              //         context,
              //         PageRouteBuilder(
              //             pageBuilder:
              //                 (context, animation, secondaryAnimation) =>
              //                     const EventDetail()));
            },
            child:
                Stack(alignment: AlignmentDirectional.bottomCenter, children: [
              //画像
              Container(
                width: width * 0.4,
                height: width * 0.4,
                decoration: BoxDecoration(
                  color: store.thinColor,
                  borderRadius: BorderRadius.circular(10),
                  //影
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  // これを追加
                  borderRadius: BorderRadius.circular(10), // これを追加
                  child: Image.network(
                      historyList.elementAt(i)["image_url"].toString(),
                      fit: BoxFit.cover),
                ),
              ),
              //タイトル枠
              Container(
                width: width * 0.4,
                height: width * 0.1,
                decoration: BoxDecoration(
                  color: store.mainColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                //タイトル
                child: Center(
                    child: Text(
                  "${historyList[i]["name"]}",
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                )),
              ),
            ]),
          ),
          SizedBox(width: mediaQueryData.size.width / 50),
        ], //ボタン間の空間
      ),
    );
  }
}

//中央のボタンを作成するクラス
class CenterButton extends StatelessWidget {
  const CenterButton({
    super.key,
    required this.centerButtonSize,
    required this.buttonList,
    required this.getEventList,
    required this.getJobList,
    required this.getHistoryList,
  });

  final double centerButtonSize;
  final Map<String, dynamic>? buttonList;
  final Function getEventList;
  final Function getJobList;
  final Function getHistoryList;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return
        //周りの円
        Column(
      children: [
        Ink(
          height: centerButtonSize, //高さ
          width: centerButtonSize, //幅

          //円の中のアイコン
          child: Container(
            decoration: ShapeDecoration(
              color: store.subColor,
              shape: const CircleBorder(), //円形
              //影
              shadows: [
                BoxShadow(
                  color: Colors.grey[400]!,
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: SizedBox(
              child: IconButton(
                icon: Icon(
                  buttonList?["icon"],
                  size: centerButtonSize * (2 / 3),
                  color: store.blackColor,
                ), //アイコン
                color: Colors.white,
                //ボタンを押した時の動作
                onPressed: () async {
                  if (buttonList?["push"] == "overlay") {
                    store.changeOverlay(true);
                    await buttonList?["overlay"].show(
                      //これでおーばーれい表示
                      context: context,
                    );
                  } else {
                    await Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    buttonList?["push"]));
                  }

                  getEventList();
                  getJobList();
                  getHistoryList();
                },
              ),
            ),
          ),
        ),
        Text(buttonList?["title"]),
      ],
    );
  }
}

//使い方
//ファイルの上部でimport '.mainAppBar.dart';と置く
//その後、Scaffold内で"appBar: MainAppBar(nextPage: notice())""のように宣言
//この時のnextPageには移動先クラスを置く
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget nextPage; //通知ボタンから移動するページ

  const MainAppBar({
    super.key,
    required this.nextPage,
  });

  @override
  Size get preferredSize {
    return const Size(double.infinity, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return AppBar(
        //アップバータイトル
        title: Text(
          "REEL", //文字
          style: GoogleFonts.secularOne(
              color: Colors.white,
              //fontWeight: FontWeight.bold,
              fontSize: 40), //書体
        ),
        backgroundColor: store.mainColor,
        //elevation: 0.0, //影なし
        toolbarHeight: 100, //アップバーの高さ
        automaticallyImplyLeading: false, //戻るボタンの非表示
        centerTitle: true,
        //アップバーアイコン
        actions: <Widget>[
          //通知ボタン
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_alert),
                color: Colors.white,
                //通知ページへ移動(push)
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  nextPage));
                },
              ),
              const SizedBox(width: 10),
            ],
          )
        ]);
  }
}
