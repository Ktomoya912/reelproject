import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '/provider/change_general_corporation.dart';
import '../../component/appbar/title_appbar.dart';

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
  final List<List<Map<String, dynamic>>> noticeList; //通知タイトル
  final String content; //文章内容

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: TitleAppBar(
        title: noticeList[jedgeEJ][index]["subtitle"],
        jedgeBuck: true,
      ),

      //内容
      body: NoticeContent(
        title: noticeList[jedgeEJ][index]["title"],
        content: content,
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
  });

  final String title; //タイトル
  final String content; //内容

  @override
  Widget build(BuildContext context) {
    //final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    MediaQueryData mediaQueryData = MediaQuery.of(context); //サイズ取得
    return
        //スクロール
        SingleChildScrollView(
            //上に空間
            child: Padding(
      padding: const EdgeInsets.all(10.0),
      //真ん中に
      child: Center(
        //横に空間を開けるため
        child: SizedBox(
            width: mediaQueryData.size.width - 100, //横の空間の合計だけ引く
            child: Column(
                //左詰め
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //タイトル
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    //内容
                    child: Text(content),
                  )
                ])),
      ),
    ));
  }
}
