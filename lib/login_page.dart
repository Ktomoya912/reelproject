import 'package:flutter/material.dart';
import 'package:reelproject/forgot_password_page.dart';
import 'package:reelproject/new_menber_general.dart';
//パスを指定して、forgot_password_page.dartをインポート

class LoginPage extends StatefulWidget {
  final bool userisgeneral;

  const LoginPage({Key? key, required this.userisgeneral}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _autoLogin = false; // チェックボックスの状態を管理する変数
  late bool userisgeneral;//hyamamotos
  late int seed;

  @override
  void initState() {
    super.initState();
    userisgeneral = widget.userisgeneral;
    //シード値を設定することによって関連の色を生成するようにする
    print(userisgeneral);
  }

  @override
  Widget build(BuildContext context) {
    int seed = userisgeneral ? 0xFFEF6C00 : 0xFF1976D2;
    //シード値を設定することによって関連の色を生成するようにする

    ColorScheme colorScheme = ColorScheme.fromSeed(
      //シード値から色を生成する
      //カラーパレットを生成する
      seedColor: Color(seed),
      secondary: Color(seed),
      primary: Color(seed),
    );

    ThemeData themeData = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
      //テーマの構築
    );
    return Scaffold(
      appBar: AppBar(
        //アップバータイトル
        title: const Text(
          "REEL", //文字
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 44,
              color: Colors.white), //書体
        ),
        backgroundColor: themeData.primaryColor, //背景
        iconTheme: const IconThemeData(color: Colors.grey), //戻るボタン
        centerTitle: true, //中央揃え
        toolbarHeight: 80, //アップバーの高さ
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 50),
            child: InkWell(
              onTap: () {
                // パスワードを忘れた場合の画面に遷移
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginPage(userisgeneral: !userisgeneral)),
                );
              },
              splashColor: Colors.transparent, // splashColorを透明にする。
              child: userisgeneral
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
      ),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: themeData.primaryColor, //onPrimaryは非推奨らしい
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
                      builder: (context) => const ForgotPasswordPage()),
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
                      builder: (context) => const ForgotPasswordPage()),
                );
              },
              splashColor: Colors.transparent, // splashColorを透明にする。
              child: const Text(
                'お問い合わせはこちら',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: themeData.primaryColor,
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
  }
}
