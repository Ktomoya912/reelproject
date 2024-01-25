import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント
import 'package:reelproject/overlay/rule/screen/rule_screen.dart'; //オーバレイで表示される画面のファイル
import 'package:reelproject/overlay/rule/screen/logout.dart'; //オーバレイで表示される画面のファイル
//push先
import 'general_mem_inf_conf.dart'; //会員情報確認
import 'company_mem_inf_conf.dart'; //会員情報確認
import 'apply_hist.dart'; //応募履歴
import 'posted_list.dart'; //投稿一覧
import 'watch_history.dart'; //閲覧履歴
import 'favorite_list.dart'; //お気に入りリスト
import 'no_post_list.dart'; //投稿なしリスト
//イベント掲載料金プラン
//import 'apply_post/job_fee_select.dart'; //イベント掲載料金プラン
import 'transfer_to.dart'; //振込口座確認
//応募者確認
import 'package:reelproject/page/login/ask_page.dart'; //お問い合わせ
import 'package:reelproject/overlay/rule/screen/select_post.dart'; //投稿選択画面
import 'package:reelproject/overlay/rule/screen/secession.dart'; //利用規約画面

@RoutePage()
class MyPageRouterPage extends AutoRouter {
  const MyPageRouterPage({super.key});
}

@RoutePage()
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store =
          Provider.of<ChangeGeneralCorporation>(context, listen: false);
      store.getMyUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: MypageAppBar(
        title: "マイページ",
        jedgeBuck: true,
      ),

      //内部
      body: ScrollMyPageDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollMyPageDetail extends StatefulWidget {
  const ScrollMyPageDetail({
    super.key,
  });

  @override
  State<ScrollMyPageDetail> createState() => _ScrollMyPageDetailState();
}

class _ScrollMyPageDetailState extends State<ScrollMyPageDetail> {
  //スクロール位置を取得するためのコントローラー
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    //showLoadingDialog(context: context); //ここでローディング画面を表示

    //reloadHomeJedgeがtrueの場合、Home画面をリロードする
    void changeMypageScroll() async {
      if (store.reloadMypageJedge) {
        //ここにHome画面リロードの処理を記述
        //ユーザ情報更新
        store.getMyUserInfo();
        //await Future.delayed(Duration(microseconds: 1));
        // スクロール位置をリセットします。
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        store.changeReloadMypageJedgeOn(false); //リロード後、falseに戻す
        //0.5秒待つ
        await Future.delayed(
            const Duration(milliseconds: ChangeGeneralCorporation.waitTime));
        //ローディングをpop
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    //ビルド後に実行
    WidgetsBinding.instance.addPostFrameCallback((_) => changeMypageScroll());

    // changeMypageScroll();

    //一般向けマイページリスト
    Map<String, List<Map<String, dynamic>>> generalMypageMap = {
      //ユーザ設定
      "settingList": [
        {
          "title": "会員情報確認・編集",
          "icon": Icons.manage_accounts,
          "push": const GeneralMemInfConf(),
        },
      ],
      //メニュー
      "menuList": [
        {
          "title": "閲覧履歴",
          "icon": Icons.history,
          "push": WatchHistory(store: store),
        },
        {
          "title": "お気に入りリスト",
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
        }
      ],
      //その他
      "elseList": [
        {
          "title": "お問い合わせ",
          "icon": Icons.chat_bubble,
          "push": const AskPage(
            loginJedge: false,
            buttonTex: "マイページに戻る",
            popTimes: 0,
          ),
        },
        {
          "title": "利用規約",
          "icon": Icons.article,
          "push": "overlay",
          "overlay": RuleScreen(),
        },
        {
          "title": "ログアウト",
          "icon": Icons.logout,
          "push": "overlay",
          "overlay": Logout(),
        },
        {
          "title": "退会申請",
          "icon": Icons.waving_hand,
          "push": "overlay",
          "overlay": Secession(),
        },
      ],
    };

    //法人向けマイページリスト
    Map<String, List<Map<String, dynamic>>> companyMypageMap = {
      //ユーザ設定
      "settingList": [
        {
          "title": "会員情報確認・編集",
          "icon": Icons.manage_accounts,
          "push": const CompanyMemInfConf(),
        },
      ],
      //投稿
      "postList": [
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
        },
        // {
        //   "title": "応募者確認",
        //   "icon": Icons.manage_search,
        //   "push": ApplyConf(),
        // },
        {
          "title": "未振り込み投稿一覧",
          "icon": Icons.money_off,
          "push": const NoPostList(),
        },
        {
          "title": "振込口座確認",
          "icon": Icons.payment,
          "push": const TransferTo(),
        },
      ],
      //メニュー
      "menuList": [
        {
          "title": "閲覧履歴",
          "icon": Icons.history,
          "push": WatchHistory(
            store: store,
          ),
        },
        {
          "title": "お気に入りリスト",
          "icon": Icons.favorite,
          "push": FavoriteList(
            store: store,
          ),
        },
      ],
      //その他
      "elseList": [
        {
          "title": "お問い合わせ",
          "icon": Icons.chat_bubble,
          "push": const AskPage(
            loginJedge: false,
            buttonTex: "マイページに戻る",
            popTimes: 0,
          ),
        },
        {
          "title": "利用規約",
          "icon": Icons.article,
          "push": "overlay",
          "overlay": RuleScreen(),
        },
        {
          "title": "ログアウト",
          "icon": Icons.logout,
          "push": "overlay",
          "overlay": Logout(),
        },
        {
          "title": "退会申請",
          "icon": Icons.waving_hand,
          "push": "overlay",
          "overlay": Secession(),
        },
      ],
    };

    //マイページのリストで使用するWidget
    Widget generalCompanyMypageList;

    //一般、法人の切り替えにより、使用するリストを変更
    if (store.jedgeGC) {
      generalCompanyMypageList = GeneralMypage(
        mediaQueryData: mediaQueryData,
        store: store,
        mypageList: generalMypageMap,
      );
    } else {
      generalCompanyMypageList = CompanyMypage(
          mediaQueryData: mediaQueryData,
          store: store,
          mypageList: companyMypageMap);
    }
    return ShaderMaskComponent(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Column(
            children: [
              //上のアイコン部分
              //上に空白
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                        // これを追加
                        borderRadius: BorderRadius.circular(50), // これを追加
                        child: Image.network("${store.userInfo["image_url"]}",
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
              //アイコンと名前の間に空白
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                    "${store.jedgeGC ? store.userInfo["username"] : store.userInfo["username"]}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ), //ユーザー名
              //空白
              const SizedBox(
                height: 30,
              ),
              //下の詳細部分
              //アイコン部分との空白
              generalCompanyMypageList,
            ],
          ),
        ),
      ),
    );
  }
}

//一般向けマイページスクロール
class GeneralMypage extends StatelessWidget {
  const GeneralMypage({
    super.key,
    required this.mediaQueryData,
    required this.store,
    required this.mypageList,
  });

  final MediaQueryData mediaQueryData;
  final ChangeGeneralCorporation store;
  final Map<String, List<Map<String, dynamic>>> mypageList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: mediaQueryData.size.width,
            height: 130,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["settingList"]!,
              tagTitle: "ユーザ設定",
            )),
        SizedBox(
            width: mediaQueryData.size.width,
            height: 270,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["menuList"]!,
              tagTitle: "メニュー",
            )),
        SizedBox(
            width: mediaQueryData.size.width,
            height: 300,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["elseList"]!,
              tagTitle: "その他",
            )),
      ],
    );
  }
}

//法人向けマイページスクロール
class CompanyMypage extends StatelessWidget {
  const CompanyMypage({
    super.key,
    required this.mediaQueryData,
    required this.store,
    required this.mypageList,
  });

  final MediaQueryData mediaQueryData;
  final ChangeGeneralCorporation store;
  final Map<String, List<Map<String, dynamic>>> mypageList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: mediaQueryData.size.width,
            height: 130,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["settingList"]!,
              tagTitle: "ユーザ設定",
            )),
        SizedBox(
            width: mediaQueryData.size.width,
            height: 320,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["postList"]!,
              tagTitle: "投稿",
            )),
        SizedBox(
            width: mediaQueryData.size.width,
            height: 200,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["menuList"]!,
              tagTitle: "メニュー",
            )),
        SizedBox(
            width: mediaQueryData.size.width,
            height: 300,
            child: MyPageListView(
              mediaQueryData: mediaQueryData,
              store: store,
              list: mypageList["elseList"]!,
              tagTitle: "その他",
            )),
      ],
    );
  }
}

//マイページリストを作成するクラス
class MyPageListView extends StatefulWidget {
  const MyPageListView({
    super.key,
    required MediaQueryData mediaQueryData,
    required this.store,
    required this.list,
    required this.tagTitle,
  }) : _mediaQueryData = mediaQueryData;

  final MediaQueryData _mediaQueryData;
  final ChangeGeneralCorporation store;
  final List<Map<String, dynamic>> list;
  final String tagTitle;

  static double widthPower = 11 / 12; //横幅の倍率定数
  static double lineWidth = 0.8;
  @override
  State<MyPageListView> createState() => _MyPageListViewState();
}

class _MyPageListViewState extends State<MyPageListView> {
  //線の太さ定数
  @override
  Widget build(BuildContext context) {
    //横幅が想定より大きくなった場合、横の幅を広げる
    double addWidth = 0;
    //横のほうが広くなった場合
    if (widget._mediaQueryData.size.width >
        widget._mediaQueryData.size.height) {
      addWidth = (widget._mediaQueryData.size.width -
          widget._mediaQueryData.size.height);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //左詰め
      children: [
        Center(
          child: Container(
            width:
                widget._mediaQueryData.size.width * MyPageListView.widthPower -
                    addWidth,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.store.greyColor,
                  width: MyPageListView.lineWidth,
                ), //リストを区別する線
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: widget._mediaQueryData.size.width / 50,
                ),
                Text(widget.tagTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
        ),
        Expanded(
          //通知一覧
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(), //スクロール禁止
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  //リストの内容
                  //リストの一つ一つを作成するListTitle
                  ListTile(
                      //左のアイコン
                      leading: Icon(widget.list[index]["icon"],
                          size: 35, color: widget.store.mainColor), //アイコンの色
                      //右側の矢印アイコン
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                        color: widget.store.greyColor,
                      ),
                      title: Text(widget.list[index]["title"]), //タイトル
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: widget._mediaQueryData.size.width / 20 +
                              addWidth / 2), //タイル内の余白
                      onTap: () async {
                        if (widget.list[index]["push"] == "overlay") {
                          widget.store.changeOverlay(true);
                          await widget.list[index]["overlay"].show(
                            //これでおーばーれい表示
                            context: context,
                          );
                        } else {
                          await Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      widget.list[index]["push"]));
                        }
                        widget.store.getMyUserInfo();
                      }),
                  Container(
                    width: widget._mediaQueryData.size.width *
                            MyPageListView.widthPower -
                        addWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: widget.store.greyColor,
                            width: MyPageListView.lineWidth), //リストを区別する線
                      ),
                    ),
                  )
                ],
              ); //ボタンを押した際の挙動
            },
            itemCount: widget.list.length, //リスト数
          ),
        ),
      ],
    );
  }
}

//appbar
class MypageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; //ページ名
  final bool jedgeBuck; //戻るボタンを表示するか否か

  const MypageAppBar({
    super.key,
    required this.title,
    required this.jedgeBuck,
  });

  @override
  Size get preferredSize {
    return const Size(double.infinity, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(

        //アップバー
        appBar: AppBar(
      //アップバータイトル
      title: Text(
        "REEL", //文字
        style: GoogleFonts.secularOne(
            //fontWeight: FontWeight.bold,
            fontSize: 40,
            color: store.mainColor), //書体
      ),
      automaticallyImplyLeading: jedgeBuck, //戻るボタンの非表示
      backgroundColor: Colors.white, //背景
      elevation: 0.0, //影なし
      iconTheme: IconThemeData(color: store.greyColor), //戻るボタン
      centerTitle: true, //中央揃え
      toolbarHeight: 100, //アップバーの高さ

      //画面説明アップバー
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: SizedBox(
            height: 30,
            child: AppBar(
              //アップバー内にアップバー(ページ説明のため)
              title: Text(
                title,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ), //ページ説明文字
              centerTitle: true, //中央揃え
              automaticallyImplyLeading: false, //戻るボタンの非表示
              backgroundColor: store.mainColor, //背景
              //elevation: 0.0, //影なし
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(right: 20, top: 5),
              //     child: InkWell(
              //       onTap: () {
              //         store.changeGC(!store.jedgeGC);
              //       },
              //       splashColor: Colors.transparent, // splashColorを透明にする。
              //       child: store.jedgeGC
              //           ? const Text(
              //               '法人の方はこちら',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 decoration: TextDecoration.underline,
              //                 decorationColor: Colors.white,
              //                 decorationThickness: 2,
              //                 color: Colors.white,
              //               ),
              //             )
              //           : const Text(
              //               '個人の方はこちら',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 decoration: TextDecoration.underline,
              //                 decorationColor: Colors.white,
              //                 decorationThickness: 2,
              //                 color: Colors.white,
              //               ),
              //             ),
              //     ),
              //   ),
              // ],
            ), //高さ
          )), //高さ
    ));
  }
}
