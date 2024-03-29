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
  final int popTimes; //何回popするか(0の場合はルートまで戻る)

  const FinishScreen({
    super.key,
    required this.appbarText,
    required this.appIcon,
    required this.finishText,
    required this.text,
    required this.buttonText,
    // required this.appBar,
    required this.jedgeBottomAppBar,
    required this.popTimes,
  });

  @override
  Widget build(BuildContext context) {
    StatelessWidget questionButtonWidget = Container(); //お問合せボタンのWidget
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    //直前のページがお問合せである場合、完了ページではお問合せボタンを表示しない
    if (appbarText != "問い合わせ") {
      questionButtonWidget = QuestionButton(
        jedgeBottomAppBar: jedgeBottomAppBar,
        buttonText: buttonText,
        popTimes: popTimes,
      );
    }
    return Scaffold(
      appBar: TitleAppBar(
        title: appbarText,
        jedgeBuck: false,
      ),
      body: Container(
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height,
        color: Colors.white,
        child: SingleChildScrollView(
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
                        width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                      ButtonSet(buttonName: buttonText, popTimes: popTimes),
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
      ),
      bottomNavigationBar:
          jedgeBottomAppBar == true ? const NormalBottomAppBar() : null,
    );
  }
}

//お問合せボタンコンポーネント
class QuestionButton extends StatelessWidget {
  const QuestionButton({
    super.key,
    required this.jedgeBottomAppBar,
    required this.buttonText,
    required this.popTimes,
  });

  final bool jedgeBottomAppBar;
  final String buttonText;
  final int popTimes;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return OutlinedButton(
        //ボタン設置
        onPressed: () {
          // ボタンが押されたときの処理をここに追加予定
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AskPage(
                      loginJedge: jedgeBottomAppBar,
                      buttonTex: buttonText,
                      popTimes: popTimes,
                    )),
          );
        },
        style: OutlinedButton.styleFrom(
          //下線付きボタンにするためoutlinedbuttonにしている
          side: BorderSide.none, //ここで周りの線を消している
        ),
        child: Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: 17,
              color: store.mainColor,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "お問い合わせ",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: store.mainColor, // ここで下線の色を設定します
                ),
              ),
            ],
          ),
        ));
  }
}
