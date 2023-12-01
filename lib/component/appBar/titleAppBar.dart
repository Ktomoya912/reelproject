import 'package:flutter/material.dart';

//使い方
//ファイルの上部でimport '.titleAppBar.dart';と置く
//その後、Scaffold内で"appBar: TitleAppBar(title: 通知)""のように宣言
//この時のtitleには表示ページ名を載せる
class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; //ページ名

  const TitleAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize {
    return Size(double.infinity, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: AppBar(
        //アップバータイトル
        title: Text(
          "REEL", //文字
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.blue), //書体
        ),
        backgroundColor: Colors.white, //背景
        iconTheme: IconThemeData(color: Colors.grey), //戻るボタン
        centerTitle: true, //中央揃え
        toolbarHeight: 100, //アップバーの高さ

        //画面説明アップバー
        bottom: PreferredSize(
            child: Container(
              child: AppBar(
                //アップバー内にアップバー(ページ説明のため)
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ), //ページ説明文字
                centerTitle: true, //中央揃え
                automaticallyImplyLeading: false, //戻るボタンの非表示
                backgroundColor: Colors.blue, //背景
              ),
              height: 30, //高さ
            ),
            preferredSize: Size.fromHeight(5)), //高さ
      ),
    );
  }
}
