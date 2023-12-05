import 'package:flutter/material.dart';
import 'package:reelproject/page/login/forgot_password_page.dart';
import 'package:reelproject/page/login/new_menber_general.dart';
import 'package:reelproject/page/login/ask_page.dart';
import 'package:reelproject/provider/changeGeneralCorporation.dart';
import 'package:reelproject/page/login/pass_change.dart';
import 'package:reelproject/page/home/home.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
//パスを指定して、forgot_password_page.dartをインポート

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _autoLogin = false; // チェックボックスの状態を管理する変数

  @override
  void initState() {
    super.initState();
    //シード値を設定することによって関連の色を生成するようにする
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    return ChangeNotifierProvider(
        create: (context) => ChangeGeneralCorporation(),
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: LoginAppBar(store: store),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // パスワードを忘れた場合の画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewMemberGeneral()),
                      );
                    },
                    splashColor: Colors.transparent, // splashColorを透明にする。
                    child: const Text(
                      '新規会員登録はこちら',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      const Text(
                        'メールアドレス',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 300,
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: '例：info@example.com',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'パスワード',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 300,
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: '例：password',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _autoLogin, // チェックボックスの状態
                            onChanged: (bool? value) {
                              // チェックボックスの状態が変更されたときのコールバック
                              setState(() {
                                // setStateメソッドを使って、ウィジェットを再構築し、新しい状態でCheckboxを描画
                                _autoLogin = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            '次回から自動でログインする',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // ログインボタンが押されたときの処理をここに追加予定
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: store.subColor, //onPrimaryは非推奨らしい
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(300, 50),
                        ),
                        child: const Text('ログイン'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // パスワードを忘れた場合の画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PassChange()),
                      );
                    },
                    splashColor: Colors.transparent, // splashColorを透明にする。
                    child: const Text(
                      'パスワードを忘れた方はこちら',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  InkWell(
                    onTap: () {
                      // パスワードを忘れた場合の画面に遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => const ForgotPasswordPage()),
                            builder: (context) => const AskPage()),
                      );
                    },
                    splashColor: Colors.transparent, // splashColorを透明にする。
                    child: const Text(
                      'お問い合わせはこちら',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: store.mainColor,
              height: 40,
              child: const Text(
                '© 2023 REEL',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }));
  }
}

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //アップバータイトル
      title: const Text(
        "REEL", //文字
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 44,
            color: Colors.white), //書体
      ),
      backgroundColor: store.mainColor, //背景
      iconTheme: const IconThemeData(color: Colors.grey), //戻るボタン
      centerTitle: true, //中央揃え
      toolbarHeight: 80, //アップバーの高さ
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 50),
          child: InkWell(
            onTap: () {
              // パスワードを忘れた場合の画面に遷移

              store.changeGC(!store.jedgeGC);
            },
            splashColor: Colors.transparent, // splashColorを透明にする。
            child: store.jedgeGC
                ? const Text(
                    '法人の方はこちら',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    '個人の方はこちら',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
