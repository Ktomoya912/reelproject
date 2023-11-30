import 'package:flutter/material.dart';

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
    return Size.fromHeight(50);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        //アップバータイトル
        title: Text(
          "REEL", //文字
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), //書体
        ),
        centerTitle: true,
        //アップバーアイコン
        actions: <Widget>[
          //通知ボタン
          IconButton(
            icon: const Icon(Icons.add_alert),
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
