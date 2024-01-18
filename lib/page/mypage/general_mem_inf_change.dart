import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:reelproject/page/mypage/mypage.dart';
import '/provider/change_general_corporation.dart';

import '../login/pass_change.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';

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

  @override
  void initState() {
    super.initState();
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
                          validator: (value) {
                            if (!checkMail(value as String)) {
                              mail = '';
                              return '適切な入力ではありません';
                            }
                            mail = value;
                            // print(mail);
                            return null;
                          },
                          enabled: true,
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
                                  onChanged: (value) {
                                    if (checkMonth(value)) {
                                      setState(() {
                                        month = value;
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
                                  onChanged: (value) {
                                    if (checkDay(value)) {
                                      setState(() {
                                        day = value;
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
                          value: 'male',
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
                          value: 'female',
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
                          value: 'other',
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
                  //一つ戻る
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: store.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(300, 50),
              ),
              child: const Text('編集内容を決定'),
            ),

            const Padding(padding: EdgeInsets.all(10)),
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
    r"^[\w!#$%&'*+/=?`{|}~^-]+(\.[\w!#$%&'*+/=?`{|}~^-]+)*@([A-Z0-9-]{2,6})\.(?:\w{3}|\w{2}\.\w{2})$",
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
