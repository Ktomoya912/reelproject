import 'package:reelproject/page/login/ask_page.dart';
import 'package:flutter/material.dart';
// import 'normalBottomAppBar.dart';
// import 'titleAppBar.dart';
import 'package:reelproject/component/button_set/button_set.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

//使い方
//ログイン前の完了画面を生成する
//ファイルの上部でimport 'FinishScreen.dart';と置く
//その後、Widget内でreturnの後に"FinishScreen();"のように宣言
class FinishScreen extends StatelessWidget {
  final String appbarText;
  final IconData appIcon;
  final String finishText;
  final String text;
  final String buttonText;
  // final Widget appBar;
  final bool jedgeBottomAppBar;

  const FinishScreen({
    super.key,
    required this.appbarText,
    required this.appIcon,
    required this.finishText,
    required this.text,
    required this.buttonText,
    // required this.appBar,
    required this.jedgeBottomAppBar,
  });

  @override
  Widget build(BuildContext context) {
    Widget bottomAppBar = const SizedBox();
    if (jedgeBottomAppBar) {
      bottomAppBar = const NormalBottomAppBar();
    }
    StatelessWidget questionButtonWidget = Container(); //お問合せボタンのWidget
    //直前のページがお問合せである場合、完了ページではお問合せボタンを表示しない
    if (appbarText != "問い合わせ") {
      questionButtonWidget = const QuestionButton();
    }
    return Scaffold(
      appBar: TitleAppBar(
        title: appbarText,
        jedgeBuck: false,
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
              Icon(appIcon,
                  size: 180, color: const Color.fromARGB(255, 137, 137, 137)),
              Text(
                finishText,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 300,
                height: 270,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      width: 2.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 15),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        text,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 134, 134, 134)),
                      ),
                    ),
                    ButtonSet(buttonName: buttonText),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              questionButtonWidget,
              //空白
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomAppBar,
    );
  }
}

//お問合せボタンコンポーネント
class QuestionButton extends StatelessWidget {
  const QuestionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return OutlinedButton(
      //ボタン設置
      onPressed: () {
        // ボタンが押されたときの処理をここに追加予定
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AskPage()),
        );
      },

      style: OutlinedButton.styleFrom(
        //下線付きボタンにするためoutlinedbuttonにしている
        side: BorderSide.none, //ここで周りの線を消している
      ),
      child: Text("お問い合わせ",
          style: TextStyle(
            fontSize: 17,
            color: store.mainColor,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          )),
    );
  }
}
