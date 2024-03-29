import 'package:reelproject/component/finish_screen/finish_screen.dart';

import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:http/http.dart';
import 'dart:convert';

// お問い合わせ画面

class AskPage extends StatefulWidget {
  const AskPage(
      {super.key,
      required this.loginJedge,
      required this.buttonTex,
      required this.popTimes});

  final bool loginJedge;
  final String buttonTex;
  final int popTimes;

  @override
  AskPageState createState() => AskPageState();
}

class AskPageState extends State<AskPage> {
  // bool _autoLogin = false; // チェックボックスの状態を管理する変数
  String email = ""; // メールアドレス
  String subject = ""; // 件名
  String body = ""; // メッセージ内容
  bool askJedge = false; // 送信ボタン押下判定

  Future ask(String email, String subject, String body) async {
    Uri url = Uri.parse(
        "${ChangeGeneralCorporation.apiUrl}/users/send-mail-to-admin");
    //ここの部分がないとエラーを吐く
    //https://ttydev.com/post/flutter/content-type-errorを参考にした
    final requestBody = json.encode({
      'email': email,
      'subject': subject,
      'body': body,
    });
    post(url,
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json'
            },
            body: requestBody)
        .then((response) {
      //thenは非同期処理が終わった後に実行される
      if (response.statusCode == 200 &&
          checkEmpty(email) && //メールアドレスが空でないか
          checkEmpty(body) && //メッセージ内容が空でないか
          checkEmpty(subject)) {
        //件名が空でないか
        askJedge = true;
      } else {
        //エラー処理
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("エラー"),
              content: const Text("送信に失敗しました。\n入力に不備がないか確認ください。"),
              actions: <Widget>[
                // ボタン領域
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      //ここでは上記のエラーとは違い、ネットワークエラーなどが発生した場合に実行される
      showAboutDialog(
        context: context,
        applicationName: "エラー",
        applicationVersion: "エラー",
        applicationIcon: const Icon(Icons.error),
        children: [
          const Text("ネットワークエラーまたは他のエラーが発生しました。"),
        ],
      );
    });
  }

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

              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'ご自身のメールアドレスを入力してください',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          validator: (value) {
                            if (!checkMail(value as String)) {
                              email = '';
                              return '適切な入力ではありません';
                            }
                            email = value;
                            // print(mail);
                            return null;
                          },
                          enabled: true,
                          maxLength: 50,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: 'メールアドレス',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: '例：info@example.com',
                            counterText: '50文字以内',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '件名',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          subject = value;
                        });
                      },
                      enabled: true,
                      maxLength: 100,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '件名',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        counterText: '100文字以内',
                      ),
                    ),
                  ],
                ),
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

              Container(
                width: 300.0,
                height: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      body = value;
                    });
                  },
                  maxLines: null,
                  maxLength: 100,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ここに入力',

                    counterText: '', //maxLengthによる"0/100"の表示を消すための処理
                  ),
                ),
              ),

              const SizedBox(
                height: 35,
              ),

              ElevatedButton(
                onPressed: () {
                  // ログインボタンが押されたときの処理をここに追加予定
                  ask(email, subject, body);

                  if (askJedge == true) {
                    Navigator.pop(context, true);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FinishScreen(
                          appbarText: "問い合わせ",
                          appIcon: Icons.mail_outlined,
                          finishText: "送信完了",
                          text:
                              "この度はお問い合わせいただきまして、\n誠にありがとうございました。\n弊社から折り返しご連絡を差し上げますので、\n今しばらくお待ちください。\nお問い合わせから１週間以上弊社からの返信がない場合は、メールのトラブルなどが考えられますので、再度お問い合わせいただくようお願いします。",
                          buttonText: widget.buttonTex,
                          jedgeBottomAppBar: widget.loginJedge,
                          popTimes: widget.popTimes,
                        ),
                      ),
                    );
                  }
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

bool checkMail(String mail) {
  //メールアドレスの正規表現
  final regEmail = RegExp(
    caseSensitive: false,
    r"^[\w!#$%&'*+/=?`{|}~^-]+(\.[\w!#$%&'*+/=?`{|}~^-]+)*@([A-Z0-9-]{2,9})\.(?:\w{3}|\w{2}\.\w{2})$",
  );
  return regEmail.hasMatch(mail);
}

bool checkEmpty(String value) {
  if (value.isEmpty) {
    return false;
  } else {
    return true;
  }
}
