import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/changeGeneralCorporation.dart';

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
    return Size(double.infinity, 80.0);
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
          style: TextStyle(
              fontWeight: FontWeight.bold,
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
            child: Container(
              child: AppBar(
                //アップバー内にアップバー(ページ説明のため)
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: store.blackColor,
                  ),
                ), //ページ説明文字
                centerTitle: true, //中央揃え
                automaticallyImplyLeading: false, //戻るボタンの非表示
                backgroundColor: store.subColor, //背景
                elevation: 0.0, //影なし
              ),
              height: 30, //高さ
            ),
            preferredSize: Size.fromHeight(5)), //高さ
      ),
    );
  }
}
