import 'package:reelproject/component/finish_screen/finish_screen.dart';

import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/comment_box/comment_box.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

class AskPage extends StatefulWidget {
  const AskPage({
    super.key,
    required this.loginJedge,
  });

  final bool loginJedge;

  @override
  AskPageState createState() => AskPageState();
}

class AskPageState extends State<AskPage> {
  // bool _autoLogin = false; // チェックボックスの状態を管理する変数

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);

    return Scaffold(
      appBar: const TitleAppBar(
        title: "問い合わせ",
        jedgeBuck: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),

              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              const Icon(Icons.contact_support,
                  size: 170, color: Color.fromARGB(255, 137, 137, 137)),
              // const IconSelecter(iconName: Icons.add, r: 137, g: 137, b: 137),
              const Text(
                'お問い合わせの内容をお書きください。',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                width: 300,
                height: 30,
                child: Text(
                  ' お問い合わせ内容',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),

              const CommentBox(boxWidth: 300.0, boxHeight: 200.0),

              const SizedBox(
                height: 35,
              ),

              ElevatedButton(
                onPressed: () {
                  // ログインボタンが押されたときの処理をここに追加予定
                  Navigator.pop(context, true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FinishScreen(
                        appbarText: "問い合わせ",
                        appIcon: Icons.mail_outlined,
                        finishText: "送信完了",
                        text:
                            "この度はお問い合わせいただきまして、\n誠にありがとうございました。\n弊社から折り返しご連絡を差し上げますので、\n今しばらくお待ちください。\nお問い合わせから１週間以上弊社からの返信がない場合は、メールのトラブルなどが考えられますので、再度お問い合わせいただくようお願いします。",
                        buttonText: widget.loginJedge == true
                            ? "ログイン画面に戻る"
                            : "マイページに戻る",
                        jedgeBottomAppBar: widget.loginJedge,
                      ),
                    ),
                  );
                },
                // child: Text('送信する', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(130, 40),
                  backgroundColor: store.mainColor,
                ),
                child:
                    const Text('送信する', style: TextStyle(color: Colors.white)),
              ),
              //空白
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          widget.loginJedge == true ? const NormalBottomAppBar() : null,
    );
  }
}
