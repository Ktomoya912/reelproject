import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/component/loading/show_loading_dialog.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';

class PassChange extends StatefulWidget {
  const PassChange({
    super.key,
    required this.loginJedge,
  });

  final bool loginJedge;

  @override
  PassChangeState createState() => PassChangeState();
}

class PassChangeState extends State<PassChange> {
  // bool _autoLogin = false; // チェックボックスの状態を管理する変数
  bool passChange = false; // パスワード変更の状態を管理する変数
  String email = ""; // メールアドレス

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    Future<bool> forgotPassword(String email) async {
      Uri url =
          Uri.parse("${ChangeGeneralCorporation.apiUrl}/auth/forgot-password");
      final requsetEmail = json.encode({
        'email': email,
      });

      try {
        Response response = await post(
          url,
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: requsetEmail,
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } catch (error) {
        return false;
      }
    }

    return Scaffold(
      appBar: const TitleAppBar(
        title: "パスワード再設定",
        jedgeBuck: true,
      ),
      body: Center(
        child: Container(
          width: mediaQueryData.size.width,
          color: Colors.white,
          child: SingleChildScrollView(
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
                        width: 1.5),
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
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 20),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: SizedBox(
                          width: 10,
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              labelText: "メールアドレス",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                        onPressed: () async {
                          showLoadingDialog(context: context);

                          forgotPassword(email).then((success) {
                            Navigator.pop(context);

                            if (success) {
                              Navigator.pop(context, true);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FinishScreen(
                                    appbarText: "パスワード再設定",
                                    appIcon: Icons.mail_outlined,
                                    finishText: "送信完了",
                                    text:
                                        "ご入力いただいた、メールアドレスに、\nパスワード再設定用URLを記載したメールを送信いたしました。\nURLの有効期限は30分です。\n30分以内にアクセスいただけない場合、再度お手続きをお願いします。",
                                    buttonText: widget.loginJedge == true
                                        ? "ログイン画面に戻る"
                                        : "マイページに戻る",
                                    jedgeBottomAppBar: widget.loginJedge,
                                    popTimes: 0,
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("エラー"),
                                    content: const Text("メールアドレスが間違っています。"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
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
                      )
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
          widget.loginJedge == true ? const NormalBottomAppBar() : null,
    );
  }
}
