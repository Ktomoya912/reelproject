import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/new_member_appbar.dart';
import 'package:reelproject/component/bottom_appbar/new_member_bottombar.dart';
import 'package:reelproject/component/loading/show_loading_dialog.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/overlay/rule/screen/rule_screen.dart'; //オーバレイで表示される画面のファイル
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:math';

class NewMemberGeneral extends StatefulWidget {
  final bool isObscure;
  final bool isObscureCheck;
  final ValueChanged<bool> onVisibilityToggle;
  const NewMemberGeneral({
    super.key,
    this.isObscure = true,
    this.isObscureCheck = true,
    required this.onVisibilityToggle,
  });

  @override
  NewMemberGeneralState createState() => NewMemberGeneralState();
}

class NewMemberGeneralState extends State<NewMemberGeneral> {
  String? selectedGender;
  late bool _isObscure;
  late bool _isObscureCheck;

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
    _isObscure = widget.isObscure;
    _isObscureCheck = widget.isObscureCheck;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);

    Future<bool> createUser(
      String username,
      String password,
      String email,
      String imageUrl,
      String year,
      String months,
      String days,
      String sex,
    ) async {
      Uri url = Uri.parse("${ChangeGeneralCorporation.apiUrl}/users/");
      Random random = Random();

      // 0から2までのランダムな数を生成
      int randomNumber = random.nextInt(8);

      // 選択肢となるURLリスト
      List<String> urls = [
        'https://soco-st.com/wp-content/uploads/clownfish_16502_color.png',
        'https://soco-st.com/wp-content/uploads/squirrel_16433_color.png',
        'https://soco-st.com/wp-content/uploads/stoat_16441_color.png',
        'https://soco-st.com/wp-content/uploads/budgerigar_16451_color.png',
        'https://soco-st.com/wp-content/uploads/penguin_16457_color.png',
        'https://soco-st.com/wp-content/uploads/squirrel_16425_color.png',
        'https://soco-st.com/wp-content/uploads/2020/11/cow_4749_color-2.png',
        'https://soco-st.com/wp-content/uploads/pigeon_olive_17322_color.png'
      ];

      imageUrl = urls[randomNumber];

      try {
        final response = await post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode({
            'username': username,
            'password': password,
            'image_url': imageUrl,
            'email': email,
            'sex': sex,
            'birthday': '$year-$months-$days',
            'user_type': 'g',
          }),
        );

        if (response.statusCode == 200) {
          return true; // 成功時は true を返す
        } else {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data["detail"] == "Username already registered") {
            // 既にユーザー名が登録されている場合//pop

            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('エラー'),
                  content: const Text('登録予定のユーザー名は既に登録されています'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
            return false; // エラー時は false を返す
          } else if (data["detail"] == "Email already registered") {
            // 既にメールアドレスが登録されている場合
            Navigator.pop(context); //
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('エラー'),
                  content: const Text('登録予定のメールアドレスは既に登録されています'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
            return false; // エラー時は false を返す
          } else {
            // その他のエラーの場合
            return false; // エラー時は false を返す
          }
        }
      } catch (error) {
        // 通信エラーなどの例外が発生した場合
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('エラー'),
              content: const Text('通信エラーが発生しました'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
        return false; // エラー時は false を返す
      }
    }

    return Scaffold(
      appBar: const NewMemberAppBar(
        title: "新規会員登録",
        jedgeBuck: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '以下に必要事項をご記入ください。',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                        labelText: 'メールアドレス',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：info@example.com',
                        counterText: '50文字以内',
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                const SizedBox(
                  width: 300,
                  child: Text(
                    '生年月日',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  maxLength: 20,
                  obscureText: _isObscure,
                  validator: (value) {
                    if (!checkPassword(value as String)) {
                      password = '';
                      //print('パスワードが正しくありません');
                      return '適切な入力ではありません';
                    }
                    password = value;
                    //print(password);
                    return null;
                  },
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'パスワード',
                    hintText: '8文字以上の英数字',
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                          widget.onVisibilityToggle(_isObscure);
                        });
                      },
                    ),
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
                    if (!checkPassword(value as String)) {
                      passwordCheck = '';
                      //print('パスワードが正しくありません');
                      return '適切な入力ではありません';
                    }
                    passwordCheck = value;
                    //print(passwordCheck);
                    return null;
                  },
                  obscureText: _isObscureCheck,
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'パスワード確認用',
                    hintText: '8文字以上の英数字',
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscureCheck
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscureCheck = !_isObscureCheck;
                          widget.onVisibilityToggle(_isObscureCheck);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            //空白
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // パスワードを忘れた場合の画面に遷移
                    ruleCheck = true;
                    RuleScreen().show(
                      //これでおーばーれい表示
                      context: context,
                    );
                  },
                  splashColor: Colors.transparent, // splashColorを透明にする。
                  child: const Text(
                    '利用規約',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const Text(
                  'を確認ください',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            ElevatedButton(
              onPressed: () async {
                // ログインボタンが押されたときの処理をここに追加予定
                if (checkUserName(username) &&
                    checkMail(mail) &&
                    checkYear(year) &&
                    checkMonth(month) &&
                    checkDay(day) &&
                    selectedGender != null &&
                    checkPassword(password) &&
                    checkPassword(passwordCheck) &&
                    checkPasswordMatch(password, passwordCheck) &&
                    ruleCheck == true) {
                  showLoadingDialog(context: context);
                  await createUser(username, password, mail, "", year, month,
                          day, selectedGender as String)
                      .then((success) {
                    //ここでローディング画面を表示
                    if (success) {
                      Navigator.pop(context); //pop
                      Navigator.push(
                        context,
                        // MaterialPageRoute(builder: (context) => Home()),
                        MaterialPageRoute(
                            builder: (context) => const FinishScreen(
                                  appbarText: "会員登録完了",
                                  appIcon: Icons.task_alt,
                                  finishText: "会員登録が完了いたしました。",
                                  text:
                                      "会員登録ありがとうございます。\nご登録メールアドレスへご確認メールをお送りしました。\n万が一メールが届かない場合、ご登録メールアドレスが正しいかご確認ください。\nメールアドレスが受け取り可能なものにもかかわらずご確認メールが届かない場合、お問い合わせホームにてお問い合わせをしていただくと幸いです。",
                                  buttonText: "ログイン画面に戻る",
                                  jedgeBottomAppBar: true,
                                  popTimes: 0,
                                )),
                      );
                    }
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('エラー'),
                        content: const Text('入力内容に誤りがあります'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
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
              child: const Text('同意する', style: TextStyle(color: Colors.white)),
            ),
            //空白
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NewMemberBottomBar(),
    );
  }
}

bool checkUserName(String username) {
  //ユーザー名の正規表現
  final regName = RegExp(
    caseSensitive: false,
    r"^[a-zA-Z0-9_]+$",
  );
  return regName.hasMatch(username) && username.length >= 8;
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

// 既にユーザー名が登録されている例外クラス
class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException(this.message);
}

// 既にメールアドレスが登録されている例外クラス
class EmailAlreadyExistsException implements Exception {
  final String message;
  EmailAlreadyExistsException(this.message);
}
