import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/changeGeneralCorporation.dart';

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
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(
        //アップバー
        appBar: AppBar(
      //アップバータイトル
      title: Text(
        "REEL", //文字
        style: TextStyle(
            color: store.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 40), //書体
      ),
      backgroundColor: store.subColor,
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
                store.changeGC(!store.jedgeGC);
              },
              child: Text(
                "法人の方はこちら",
                style: TextStyle(
                  fontSize: 17, //文字の大きさ
                  color: store.mainColor, //テキストの色
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
