import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reelproject/component/finishScreen/finishScreen.dart';
import 'package:reelproject/component/buttonSet/buttonSet.dart';
import 'package:reelproject/component/appBar/titleAppBar.dart';
import 'package:reelproject/component/bottomAppBar/normalBottomAppBar.dart';
import 'package:reelproject/provider/changeGeneralCorporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

class PassChange extends StatefulWidget {
  const PassChange({
    super.key,
  });

  @override
  PassChangeState createState() => PassChangeState();
}

class PassChangeState extends State<PassChange> {
  // bool _autoLogin = false; // チェックボックスの状態を管理する変数

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    return Scaffold(
      appBar: const TitleAppBar(
        title: "パスワード再設定",
        jedgeBuck: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),

            const Icon(Icons.lock,
                size: 170, color: Color.fromARGB(255, 137, 137, 137)),
            // const IconSelecter(iconName: Icons.add, r: 137, g: 137, b: 137),
            const Text(
              '登録したパスワードを変更します。',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(
              height: 40,
            ),

            Container(
              width: 300,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 203, 202, 202),
                    width: 2.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 20),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const SizedBox(
                      width: 10,
                      child: TextField(
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          labelText: "メールアドレス",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          // contentPadding:
                          //     EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          hintText: '例：info@example.com',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // ログインボタンが押されたときの処理をここに追加予定
                      Navigator.pop(context, true);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const FinishScreen(
                                appbarText: "パスワード再設定",
                                appIcon: Icons.mail_outlined,
                                finishText: "送信完了",
                                text:
                                    "ご入力いただいた、メールアドレスに、\nパスワード再設定用URLを記載したメールを送信いたしました。\nURLの有効期限は30分です。\n30分以内にアクセスいただけない場合、再度お手続きをお願いします。",
                                buttonText: "ログイン画面に戻る")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(130, 40),
                      backgroundColor: store.mainColor,
                    ),
                    child: const Text('送信する',
                        style: TextStyle(color: Colors.white)),
                  ),
                  // const ButtonSet(buttonName: "送信する"),
                ],
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            const SizedBox(
              height: 100,
              width: 260,
              child: Text(
                "ご登録いただいたメールアドレスを入力してください。\n本人確認のため、確認コードを記載したメールをお送り致します。",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 106, 106)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
    );
  }
}
