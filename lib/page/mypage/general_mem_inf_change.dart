import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import '../login/pass_change.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:http/http.dart';
import 'dart:convert';
import "package:reelproject/component/finish_screen/finish_screen.dart";

//push先

class GeneralMemInfConfChange extends StatefulWidget {
  const GeneralMemInfConfChange({
    super.key,
  });

  @override
  GeneralMemInfConfChangeState createState() => GeneralMemInfConfChangeState();
}

class GeneralMemInfConfChangeState extends State<GeneralMemInfConfChange> {
  String? selectedGender;

  String username = '';
  String mail = '';
  String year = '';
  String month = '';
  String day = '';
  String password = '';
  String passwordCheck = '';
  bool ruleCheck = false;

  //会員情報更新関数
  Future userInfoUpdata(ChangeGeneralCorporation store) async {
    Uri url =
        Uri.parse('${ChangeGeneralCorporation.apiUrl}/users/${store.myID}');
    final response = await put(url,
        headers: {
          'accept': 'application/json',
          'authorization': 'Bearer ${store.accessToken}',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "password": "password",
          "username": username,
          "image_url": store.userInfo["image_url"],
          "email": store.userInfo["email"],
          "sex": selectedGender,
          "birthday":
              "$year-${month.length == 2 ? month : "0$month"}-${day.length == 2 ? day : "0$day"}",
          "user_type": "g"
        }));
  }

  @override
  void initState() {
    super.initState();
    // initState 内でプロバイダーから初期値を取得する
    final store = Provider.of<ChangeGeneralCorporation>(context, listen: false);

    username = store.userInfo["username"] ?? '';
    mail = store.userInfo["email"] ?? '';
    year = store.userInfo["birthday"]?.substring(0, 4) ?? '';
    month = store.userInfo["birthday"]?.substring(5, 7) ?? '';
    day = store.userInfo["birthday"]?.substring(8, 10) ?? '';
    selectedGender = store.userInfo["sex"] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return Scaffold(
      //アップバー
      appBar: const TitleAppBar(title: "会員情報", jedgeBuck: true),

      //内部
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            //上のアイコン部分
            //上に空白
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 150, //アイコン高さ
                    width: 150, //アイコン幅
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, //円形に
                        color: store.subColor), //アイコン周囲円の色
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PassChange(
                      loginJedge: false,
                    ), //写真編集画面を作成する必要あり
                  ),
                );
              },
              splashColor: Colors.transparent,
              child: const Text(
                '写真を編集する',
                style: TextStyle(color: Colors.blue),
              ),
            ),

            //アイコンと名前の間に空白

            //空白
            const SizedBox(
              height: 30,
            ),
            //下の詳細部分
            //アイコン部分との空白

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          initialValue: '${store.userInfo["username"]}',
                          validator: (value) {
                            if (!checkUserName(value as String)) {
                              username = '';
                              return '適切な入力ではありません';
                            }
                            username = value;
                            // print(username);
                            return null;
                          },
                          enabled: true,
                          maxLength: 20,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: 'ユーザー名',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: '英数字と_のみ使用可能',
                            counterText: '20文字以内',
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          initialValue: '${store.userInfo["email"]}',
                          validator: (value) {
                            if (!checkMail(value as String)) {
                              mail = '';
                              return '適切な入力ではありません';
                            }
                            mail = value;
                            // print(mail);
                            return null;
                          },
                          enabled: false,
                          maxLength: 50,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '個人用メールアドレス',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: '例：info@example.com',
                            counterText: '50文字以内',
                          ),
                        ),
                      ),
                    ),
                    // Form(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   child: SizedBox(
                    //     width: 300,
                    //     child: TextFormField(
                    //       enabled: true,
                    //       maxLength: 50,
                    //       textAlign: TextAlign.start,
                    //       decoration: const InputDecoration(
                    //         labelText: 'メールアドレス',
                    //         border: OutlineInputBorder(),
                    //         contentPadding: EdgeInsets.symmetric(
                    //             vertical: 8, horizontal: 10),
                    //         hintText: '例：info@example.com',
                    //         counterText: '50文字以内',
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    const SizedBox(
                      width: 300,
                      child: Text(
                        '生年月日',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  initialValue:
                                      '${store.userInfo["birthday"].substring(0, 4)}',
                                  onChanged: (value) {
                                    if (checkYear(value)) {
                                      setState(() {
                                        year = value;
                                      });
                                      //print(value);
                                    } else {
                                      setState(() {
                                        year = '';
                                      });
                                      //print('年が正しくありません');
                                    }
                                  },
                                  enabled: true,
                                  maxLength: 4,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    labelText: '西暦',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    counterText: '',
                                  ),
                                ),
                              ),
                              const Text('年', style: TextStyle(fontSize: 15)),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  initialValue:
                                      '${store.userInfo["birthday"].substring(5, 7)}',
                                  onChanged: (value) {
                                    if (checkMonth(value)) {
                                      setState(() {
                                        month = value;
                                        if (month.length == 1) {
                                          month = '0$month';
                                        }
                                      });

                                      //print(value);
                                    } else {
                                      setState(() {
                                        month = '';
                                      });
                                      //print('月が正しくありません');
                                    }
                                  },
                                  enabled: true,
                                  maxLength: 2,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    counterText: '',
                                  ),
                                ),
                              ),
                              const Text('月', style: TextStyle(fontSize: 15)),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  initialValue:
                                      '${store.userInfo["birthday"].substring(8, 10)}',
                                  onChanged: (value) {
                                    if (checkDay(value)) {
                                      setState(() {
                                        day = value;
                                        if (day.length == 1) {
                                          day = '0$day';
                                        }
                                      });
                                      //print(value);
                                    } else {
                                      setState(() {
                                        day = '';
                                      });
                                      //print('日が正しくありません');
                                    }
                                  },
                                  enabled: true,
                                  maxLength: 2,
                                  textAlign: TextAlign.start,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    counterText: '',
                                  ),
                                ),
                              ),
                              const Text('日', style: TextStyle(fontSize: 15)),
                            ]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      // エラーメッセージを表示する変数などを使用する
                      checkBrithday(year, month, day),
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 'm',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        const Text('男性',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                        Radio(
                          value: 'f',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        const Text('女性',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                        Radio(
                          value: 'o',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        const Text('その他',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                      ],
                    ),
                  ],
                ),
                Text(
                  checkSelectedGender(selectedGender),
                  style: const TextStyle(color: Colors.red),
                ),

                //空白
              ],
            ),

            //空白
            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
              onPressed: () {
                if (checkUserName(username) &&
                    checkYear(year) &&
                    checkMonth(month) &&
                    checkDay(day) &&
                    selectedGender != null) {
                  //更新
                  userInfoUpdata(store);
                  //完了画面
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FinishScreen(
                        appbarText: "会員情報編集完了",
                        appIcon: Icons.playlist_add_check,
                        finishText: "会員情報の変更を確認しました。",
                        text:
                            "会員情報の変更を完了しました。\n先ほど入力を行った内容以外にも変更したい点がある際には、下のお問合せよりお願いいたします。",
                        buttonText:
                            "会員情報確認画面に戻る", // 今は既存のfinish_screenをつかっているのでログイン画面に戻ってしまうが後に変更予定
                        jedgeBottomAppBar: false,
                        popTimes: 2,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: store.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(300, 50),
              ),
              child:
                  const Text('編集内容を決定', style: TextStyle(color: Colors.white)),
            ),

            const Padding(padding: EdgeInsets.all(20)),
          ],
        ),
      )),
    );
  }
}

//一般向けマイページスクロール

//マイページリストを作成するクラス

bool checkUserName(String username) {
  //ユーザー名の正規表現
  final regName = RegExp(
    caseSensitive: false,
    r"^[a-zA-Z0-9_]+$",
  );
  return regName.hasMatch(username);
}

bool checkMail(String mail) {
  //メールアドレスの正規表現
  final regEmail = RegExp(
    caseSensitive: false,
    r"^[\w!#$%&'*+/=?`{|}~^-]+(\.[\w!#$%&'*+/=?`{|}~^-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.([A-Za-z]{2,}|\.[A-Za-z]{2}\.[A-Za-z]{2})$",
  );
  return regEmail.hasMatch(mail);
}

bool checkYear(String year) {
  //年の正規表現
  final regYear = RegExp(
    caseSensitive: false,
    r"^[0-9]{4}$",
  );
  return regYear.hasMatch(year);
}

bool checkMonth(String month) {
  //月の正規表現
  final regMonth = RegExp(
    caseSensitive: false,
    r"^[0-9]{1,2}$",
  );
  return regMonth.hasMatch(month) && int.parse(month) <= 12 && month != '';
}

bool checkDay(String day) {
  //日の正規表現
  final regDay = RegExp(
    caseSensitive: false,
    r"^[0-9]{1,2}$",
  );
  return regDay.hasMatch(day);
}

String checkSelectedGender(String? selectedGender) {
  //性別の正規表現
  if (selectedGender == null) {
    return '性別を選択してください';
  } else {
    return '';
  }
}

String checkBrithday(String? year, String? month, String? day) {
  // 誕生日の検証
  if (year == '' || month == '' || day == '') {
    return '誕生日を入力してください';
  }
  return '';
}

bool checkPassword(String password) {
  //パスワードの正規表現
  final regPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)');
  return regPassword.hasMatch(password) && password.length >= 8;
}

bool checkPasswordMatch(String password, String passwordCheck) {
  //パスワードの正規表現
  return password == passwordCheck;
}
