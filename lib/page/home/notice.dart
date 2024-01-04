import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../component/appbar/title_appbar.dart';
import '/component/button/toggle_button.dart';
import '/provider/change_general_corporation.dart';
import 'notice_detail.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';

//通知一覧画面作成クラス
class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final String title = "通知"; //AppBarに表示する文字

  String content = "イベント開催期間が迫っています";

  List<List<Map<String, dynamic>>> noticeList = [
    [
      {
        "title": "【イベント開催間近1】",
        "subtitle": "開催間近",
      },
      {
        "title": "【イベント開催間近2】",
        "subtitle": "開催間近",
      },
    ],
    [
      {
        "title": "【求人期限間近1】",
        "subtitle": "期限間近",
      },
      {
        "title": "【求人期限間近2】",
        "subtitle": "期限間近",
      },
      {
        "title": "【求人期限間近3】",
        "subtitle": "期限間近",
      }
    ]
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ChangeNotifierProvider(
        create: (context) => ChangeToggleButton(),
        child: Builder(builder: (BuildContext context) {
          final store = Provider.of<ChangeToggleButton>(context); //プロバイダ
          //横画面サイズにより幅設定
          double widthBlank = (mediaQueryData.size.width / 2) - 300;
          if (widthBlank < 0) {
            widthBlank = 0;
          }
          double blank = mediaQueryData.size.width / 20;
          double width = mediaQueryData.size.width - (widthBlank * 2) - blank;
          return Scaffold(
            //アップバー
            appBar: TitleAppBar(
              title: title,
              jedgeBuck: true,
            ),

            body: ShaderMaskComponent(
              child: Column(
                children: [
                  //イベント、求人切り替えボタン
                  //四角で囲む(上ボタンの幅選択)
                  ToggleButton(
                    mediaQueryData: mediaQueryData,
                    leftTitle: "イベント",
                    rightTitle: "求人",
                    height: 50,
                  ),

                  //リスト
                  SizedBox(
                    width: width + (widthBlank / 8) + blank - 10,
                    height: mediaQueryData.size.height - 210,
                    child: NoticeListView(
                      jedgeEJ: store.onButtonIndex,
                      noticeList: noticeList,
                      content: content,
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

//通知一覧クラス
class NoticeListView extends StatelessWidget {
  const NoticeListView({
    super.key,
    required this.jedgeEJ,
    required this.noticeList,
    required this.content,
  });

  final int jedgeEJ; //イベントか求人かジャッジ
  final List<List<Map<String, dynamic>>> noticeList; //通知タイトル
  final String content; //通知詳細内容

  //アイコン
  static List icon = [Icons.favorite, Icons.work];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    //ListViewをColumnの中にいれるにはExpandedを行う必要がある
    return Expanded(
      //通知一覧
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return
              //四角作成(これの大きさがリストの高さをになっている)
              Container(
                  height: 90, //リストの高さ
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey), //リストを区別する線
                    ),
                  ),
                  //リストの内容
                  //リストの一つ一つを作成するListTitle
                  child: ListTile(
                      //左のアイコン
                      //Containerで円を作っている
                      leading: Container(
                          height: 70, //アイコン高さ
                          width: 70, //アイコン幅
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, //円形に
                              color: store.subColor), //アイコン周囲円の色
                          //円内のアイコン
                          child: Icon(icon[jedgeEJ],
                              size: 45, color: store.mainColor)), //アイコンの色
                      //右側の矢印アイコン
                      trailing: Padding(
                        padding:
                            const EdgeInsets.all(15.0), //このままだと真ん中に来ないため空間を作る
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                          color: store.greyColor,
                        ),
                      ),
                      title: Text(noticeList[jedgeEJ][index]["title"]), //タイトル
                      subtitle:
                          Text(noticeList[jedgeEJ][index]["subtitle"]), //サブタイトル
                      visualDensity: const VisualDensity(
                          vertical: 1.5), //listTitleの大きさを広げている(1.5倍)
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        NoticeDetail(
                                          noticeList: noticeList,
                                          jedgeEJ: jedgeEJ,
                                          index: index,
                                          content: content,
                                        )));
                      })); //ボタンを押した際の挙動
        },
        itemCount: noticeList[jedgeEJ].length, //リスト数
      ),
    );
  }
}
