import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'mypage.dart';

class ApplyConf extends StatefulWidget {
  const ApplyConf({
    super.key,
  });

  @override
  ApplyConfState createState() => ApplyConfState();
}

class ApplyConfState extends State<ApplyConf> {
  // bool _autoLogin = false; // チェックボックスの状態を管理する変数

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);

    return Scaffold(
      appBar: const TitleAppBar(
        title: "応募者プロフィール",
        jedgeBuck: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                width: 400,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.1,
                    //影
                  ),
                  //影
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[400]!,
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    // ----------応募者情報表示部分（アイコンなど）----------
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 150, //アイコン高さ
                              width: 150, //アイコン幅
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, //円形に
                                  color: store.subColor), //アイコン周囲円の色
                            ),
                            const Text(
                                'ユーザー名'), // 後にデータベースから取得したユーザー名を表示させるようにする
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        // 後にデータベースから情報を取得しその内容を反映させるようにするのでconstにはしない
                        width: 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'メールアドレス',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: store.greyColor,
                              ),
                            ),
                            const Text(
                              '　info@example.com',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            Divider(
                              color: store.greyColor,
                              thickness: 1,
                              endIndent: 2,
                            ),
                            Text(
                              '生年月日',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: store.greyColor,
                              ),
                            ),
                            const Text(
                              '　◯年◯月◯日',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            Divider(
                              color: store.greyColor,
                              thickness: 1,
                              endIndent: 2,
                            ),
                            Text(
                              '性別',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: store.greyColor,
                              ),
                            ),
                            const Text(
                              '　男性',
                              style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            Divider(
                              color: store.greyColor,
                              thickness: 1,
                              endIndent: 2,
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                    // ---------------------------------------------------
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 400,
                child: Text(
                  '求人広告に対して応募を行ったユーザーのプロフィールです。\n 雇用を行いたい、または面接を行いたいなどといった場合には、上記のメールアドレスへ連絡を行ってください。\n　\nまた、実際に雇用が決定されましたら、以下の確認ボタンを押してください。\n残念ながら不採用となってしまった際には以下のキャンセルボタンを押してください。',
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.grey[600]),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 400,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // // ログインボタンが押されたときの処理をここに追加予定
                        Navigator.pop(context, true);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const FinishScreen(
                              appbarText: "応募者確認",
                              appIcon: Icons.playlist_add_check,
                              finishText: "確認完了",
                              text:
                                  "この度は応募者確認をしていただきありがとうございます。\n今回行っていただいた応募者確認情報はアプリの機能改善に用いさせていただきます。",
                              buttonText:
                                  "ログイン画面に戻る", // 今は既存のfinish_screenをつかっているのでログイン画面に戻ってしまうが後に変更予定
                              jedgeBottomAppBar: true,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(195, 60),
                        backgroundColor: store.mainColor,
                      ),
                      child: const Text('送信する',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // ボタンが押されたときの処理をここに追加
                        Navigator.pop(context, true);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const MyPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(195, 60),
                        backgroundColor: store.greyColor,
                      ),
                      child: const Text('キャンセル',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              //空白
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
