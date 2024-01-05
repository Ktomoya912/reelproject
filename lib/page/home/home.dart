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
import 'package:reelproject/component/listView/carousel.dart';
// import 'package:reelproject/page/event/event_post_detail.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}

@RoutePage()
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int index = 0; //BottomAppBarのIcon番号

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
        "push": const FavoriteList(),
      },
      {
        "title": "応募履歴",
        "icon": Icons.task,
        "push": const ApplyHist(),
      },
    ],
    //法人ボタンリスト
    "company": [
      {
        "title": "お気に入り",
        "icon": Icons.favorite,
        "push": const FavoriteList(),
      },
      {
        "title": "広告投稿",
        "icon": Icons.post_add,
        "push": const ApplyHist(),
      },
      {
        "title": "投稿一覧",
        "icon": Icons.summarize,
        "push": const PostedList(),
      }
    ]
  };

  //閲覧履歴リスト
  List<Map<String, dynamic>> historyList = [
    {
      "title": "イベントタイトル",
    },
    {
      "title": "イベントタイトル",
    },
    {
      "title": "イベントタイトル",
    },
    {
      "title": "イベントタイトル",
    },
    {
      "title": "イベントタイトル",
    }
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

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
                            for (int i = 0; i < 5; i++)
                              Container(
                                height: width / 10 * 7,
                                width: width,
                                decoration: BoxDecoration(
                                  color: store.subColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          ],
                          timeJedge: false,
                        ),
                      ),
                      SizedBox(
                          height: mediaQueryData.size.height / 25), //ボタン間の空間
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
                            ),
                            SizedBox(width: centerButtonSize * 1.5), //ボタン間の空間
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["general"]?[1],
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
                            ),
                            SizedBox(width: centerButtonSize), //ボタン間の空間
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["company"]?[1],
                            ),
                            SizedBox(width: centerButtonSize), //ボタン間の空間
                            CenterButton(
                              centerButtonSize: centerButtonSize,
                              buttonList: buttonList["company"]?[2],
                            ),
                          ],
                        ),
                      SizedBox(
                          height: mediaQueryData.size.height / 25), //ボタン間の空間
                      //閲覧履歴
                      SizedBox(
                        //color: Colors.blue,
                        width: width,
                        height: width * 0.75,
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("閲覧履歴"),
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                    secondaryAnimation) =>
                                                const WatchHistory()));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    mediaQueryData.size.height / 200), //ボタン間の空間
                            //閲覧履歴リスト
                            SingleChildScrollView(
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
                                        i: i),
                                ],
                              ),
                            ),
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
  });

  final MediaQueryData mediaQueryData;
  final ChangeGeneralCorporation store;
  final List<Map<String, dynamic>> historyList;
  final int i;
  final double width;

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

    //未投稿か否か(true:未投稿,false:投稿済み)
    "notPost": false,

    //掲載期間
    "postTerm": "2023年12月10日"
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width * 0.5,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          JobPostDetail(jobList: jobDetailList)));
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
              ),
              //タイトル枠
              Container(
                width: width * 0.4,
                height: width * 0.1,
                decoration: BoxDecoration(
                  color: store.subColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                //タイトル
                child: Center(child: Text(historyList[i]["title"])),
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
  });

  final double centerButtonSize;
  final Map<String, dynamic>? buttonList;

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
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  buttonList?["push"]));
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
              color: store.mainColor,
              //fontWeight: FontWeight.bold,
              fontSize: 40), //書体
        ),
        backgroundColor: store.subColor,
        //elevation: 0.0, //影なし
        toolbarHeight: 100, //アップバーの高さ
        automaticallyImplyLeading: false, //戻るボタンの非表示
        centerTitle: true,
        //アップバーアイコン
        actions: <Widget>[
          //通知ボタン
          IconButton(
            icon: const Icon(Icons.add_alert),
            color: store.mainColor,
            //通知ページへ移動(push)
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          nextPage));
            },
          )
        ]);
  }
}
