import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '/provider/change_general_corporation.dart';
import '../../component/appbar/title_appbar.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
//オーバーレイ
import '../../overlay/rule/screen/notice_delete.dart';

//通知詳細クラス
//このクラスをpopすると任意の通知内容を開くことができる
class NoticeDetail extends StatelessWidget {
  const NoticeDetail({
    super.key,
    required this.noticeList,
    required this.jedgeEJ,
    required this.index,
    required this.content,
  });

  final int index; //index個目の通知
  final int jedgeEJ; //イベント、求人区別
  final List<dynamic> noticeList; //通知タイトル
  final String content; //文章内容

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: const TitleAppBar(
        title: "通知詳細",
        jedgeBuck: true,
      ),

      //内容
      body: NoticeContent(
        title: noticeList[jedgeEJ][index]["title"],
        content: content,
        id: noticeList[jedgeEJ][index]["id"],
      ),
    );
  }
}

//内容クラス(スクロール可能)
class NoticeContent extends StatelessWidget {
  const NoticeContent({
    super.key,
    required this.title,
    required this.content,
    required this.id,
  });

  final String title; //タイトル
  final String content; //内容
  final int id; //id

  @override
  Widget build(BuildContext context) {
    //final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    MediaQueryData mediaQueryData = MediaQuery.of(context); //サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    //横画面サイズにより幅設定
    double widthBlank = (mediaQueryData.size.width / 2) - 300;
    if (widthBlank < 0) {
      widthBlank = 0;
    }
    double blank = mediaQueryData.size.width / 20;
    double width = mediaQueryData.size.width - (widthBlank * 2) - blank;
    return
        //スクロール
        ShaderMaskComponent(
      child: SingleChildScrollView(
          //上に空間
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        //真ん中に
        child: Center(
          //横に空間を開けるため
          child: SizedBox(
              width: width + (widthBlank / 8) + blank - 100, //横の空間の合計だけ引く
              child: Column(
                  //左詰め
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //空白
                    const SizedBox(height: 10),
                    //タイトル
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width + (widthBlank / 8) + blank - 100 - 70,
                          child: Text(
                            "タイトル : \n$title",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        //アイコンボタン(ゴミ箱)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: store.mainColor, // アイコンの色を設定
                          iconSize: 25, // アイコンのサイズを設定
                          onPressed: () {
                            //オーバーレイを表示
                            store.changeOverlay(true);
                            NoticeDelete().show(
                              //これでおーばーれい表示
                              context: context,
                              id: id,
                            );
                          },
                        ),
                      ],
                    ),
                    //空白
                    const SizedBox(height: 20),
                    //内容
                    const Text(
                      " 詳細",
                      style: TextStyle(fontSize: 15),
                    ),
                    //空白
                    const SizedBox(height: 5),

                    Container(
                      constraints: BoxConstraints(
                        minHeight: mediaQueryData.size.height / 20 * 12,
                      ),
                      width: width + (widthBlank / 8) + blank - 100,
                      decoration: BoxDecoration(
                        //color: Colors.grey[100],
                        border: Border.all(
                          color: const Color.fromARGB(255, 207, 207, 207), // 枠線の色
                          width: 1, // 枠線の幅
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(content),
                      ),
                    )
                  ])),
        ),
      )),
    );
  }
}
