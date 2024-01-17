import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント

//使い方
//ファイルの上部でimport '.titleAppBar.dart';と置く
//その後、Scaffold内で"appBar: TitleAppBar(title: "通知")"のように宣言
//この時のtitleには表示ページ名を載せる
class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; //ページ名
  final bool jedgeBuck; //戻るボタンを表示するか否か

  const TitleAppBar({
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
        leading: jedgeBuck
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              )
            : null,
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
        //elevation: 0.0, //影なし
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
                elevation: 4.0, //影なし
              ), //高さ
            )), //高さ
      ),
    );
  }
}
