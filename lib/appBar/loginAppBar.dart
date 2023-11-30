import 'package:flutter/material.dart';

//使い方
//ファイルの上部でimport '.loginAppBar.dart';と置く
//その後、Scaffold内で"appBar: LogiAppBar()""のように宣言
class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({
    super.key,
  });

  @override
  Size get preferredSize {
    return Size(double.infinity, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //アップバー
        appBar: AppBar(
      //アップバータイトル
      title: Text(
        "REEL", //文字
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30), //書体
      ),
      centerTitle: true, //中央ぞろえ
      toolbarHeight: 80, //高さ
      automaticallyImplyLeading: false, //戻るボタンの非表示

      //法人利用者へ移動ボタン
      actions: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end, //下寄せ
          children: [
            TextButton(
              onPressed: () {
                // ボタンが押されたときに発動される処理(自由に変更可)
              },
              child: Text(
                "法人の方はこちら",
                style: TextStyle(
                  fontSize: 15, //文字の大きさ
                  color: Colors.white, //テキストの色
                  decoration: TextDecoration.underline, //下線
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
