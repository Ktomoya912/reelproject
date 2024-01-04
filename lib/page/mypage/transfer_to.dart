// import 'package:reelproject/component/finish_screen/finish_screen.dart';

import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
// import 'package:reelproject/component/comment_box/comment_box.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

//ログイン以外のアプリを包括するレイヤー
//ボトムアップバーは共有で、それ以外が変更される

class TransferTo extends StatelessWidget {
  const TransferTo({super.key});

  @override

  //移動可能なRoutes

  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(
      appBar: const TitleAppBar(
        title: "振り込み先",
        jedgeBuck: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '金融機関名',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: store.greyColor,
                        ),
                      ),
                      const Text(
                        '　ゆうちょ銀行',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: store.greyColor,
                        thickness: 1,
                        endIndent: 20,
                      ),
                      Text(
                        '支店名',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: store.greyColor,
                        ),
                      ),
                      const Text(
                        '　139支店(支店番号)',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: store.greyColor,
                        thickness: 1,
                        endIndent: 20,
                      ),
                      Text(
                        '口座種類',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: store.greyColor,
                        ),
                      ),
                      const Text(
                        '　当座預金',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: store.greyColor,
                        thickness: 1,
                        endIndent: 20,
                      ),
                      Text(
                        '口座番号',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: store.greyColor,
                        ),
                      ),
                      const Text(
                        '　0069029',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: store.greyColor,
                        thickness: 1,
                        endIndent: 20,
                      ),
                      Text(
                        '口座名義',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: store.greyColor,
                        ),
                      ),
                      const Text(
                        '　株式会社Chao!(カブシキガイシャチャオ!)',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Divider(
                        color: store.greyColor,
                        thickness: 1,
                        endIndent: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 270,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'こちらが振込口座になります。\n振り込みが確認され次第投稿させていただきます。\n　\n7日以内に振り込みが確認できなければ、作成ページを削除させていただきます。',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '※お振り込みの際は必ず法人名様もしくは、個人様名を入力欄にご記入ください。',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      //空白

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
