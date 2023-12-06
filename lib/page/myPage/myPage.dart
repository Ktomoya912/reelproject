import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '/provider/changeGeneralCorporation.dart';
import 'package:reelproject/component/appBar/titleAppBar.dart';

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
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: TitleAppBar(
        title: "マイページ",
        jedgeBuck: true,
      ),

      //内部
      body: ScrollMyPageDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollMyPageDetail extends StatelessWidget {
  const ScrollMyPageDetail({
    super.key,
  });

  //ユーザー設定ListView
  static const List<Map<String, dynamic>> userSettingList = [
    {
      "title": "会員情報確認・編集",
      "icon": Icons.favorite,
    },
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            //上のアイコン部分
            //上に空白
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 150, //アイコン高さ
                width: 150, //アイコン幅
                decoration: BoxDecoration(
                    shape: BoxShape.circle, //円形に
                    color: store.subColor), //アイコン周囲円の色
              ),
            ),
            //アイコンと名前の間に空白
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text("ユーザ名",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ), //ユーザー名
            //空白
            const SizedBox(
              height: 10,
            ),
            //下の詳細部分
            //アイコン部分との空白
            SizedBox(
                width: _mediaQueryData.size.width,
                height: 1000,
                child: MyPageListView(
                  mediaQueryData: _mediaQueryData,
                  store: store,
                  list: userSettingList,
                  tagTitle: "ユーザ設定",
                )),
          ],
        ),
      ),
    );
  }
}

class MyPageListView extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //左詰め
      children: [
        Container(
          width: _mediaQueryData.size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: store.greyColor), //リストを区別する線
            ),
          ),
          child: Text(tagTitle,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        Expanded(
          //通知一覧
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return
                  //四角作成(これの大きさがリストの高さをになっている)
                  Container(
                      //height: 60, //リストの高さ
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: store.greyColor), //リストを区別する線
                        ),
                      ),
                      //リストの内容
                      //リストの一つ一つを作成するListTitle
                      child: ListTile(
                          //左のアイコン
                          //Containerで円を作っている
                          leading: Icon(list[index]["icon"],
                              size: 45, color: store.mainColor), //アイコンの色
                          //右側の矢印アイコン
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 30,
                            color: store.greyColor,
                          ),
                          title: Text(list[index]["title"]), //タイトル
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     PageRouteBuilder(
                            //         pageBuilder: (context, animation,
                            //                 secondaryAnimation) =>
                            //             ));
                          })); //ボタンを押した際の挙動
            },
            itemCount: list.length, //リスト数
          ),
        ),
      ],
    );
  }
}
