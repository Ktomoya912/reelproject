import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/overlay/rule/screen/rule_screen.dart'; //オーバレイで表示される画面のファイル
import 'package:reelproject/component/finish_screen/finish_screen.dart';

class NewMemberCompany extends StatefulWidget {
  final bool isObscure;
  final bool isObscureCheck;
  final ValueChanged<bool> onVisibilityToggle;

  const NewMemberCompany({
    super.key,
    this.isObscure = true,
    this.isObscureCheck = true,
    required this.onVisibilityToggle,
  });

  @override
  NewMemberCompanyState createState() => NewMemberCompanyState();
}

class NewMemberCompanyState extends State<NewMemberCompany> {
  String? selectedGender;
  late bool _isObscure;
  late bool _isObscureCheck;

  String name = '';
  String username = '';
  String mail = '';
  String phoneNumber = '';
  String postalCode = '';
  String prefecture = '';
  String city = '';
  String address = '';
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

    return Scaffold(
      appBar: const TitleAppBar(
        title: "新規会員登録",
        jedgeBuck: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
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
                        if (!checkName(value as String)) {
                          name = '';
                          return '法人名が正しくありません';
                        }
                        name = value;
                        // print(name);
                        return null;
                      },
                      enabled: true,
                      maxLength: 20,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '法人名',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：ChaO！株式会社',
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

                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      validator: (value) {
                        if (!checkPhoneNumber(value as String)) {
                          phoneNumber = '';
                          return '電話番号が正しくありません';
                        }
                        phoneNumber = value;
                        // print(phoneNumber);
                        return null;
                      },
                      enabled: true,
                      maxLength: 11,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '電話番号',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：09012345678',
                        counterText: '11文字以内',
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),

                // ここから住所入力

                const SizedBox(
                  width: 300,
                  child: Text(
                    '住所',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
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
                        if (!checkPostalCode(value as String)) {
                          postalCode = '';
                          return '郵便番号が正しくありません';
                        }
                        postalCode = value;
                        // print(postal_code);
                        return null;
                      },
                      enabled: true,
                      maxLength: 8,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '郵便番号',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：123-4567',
                        counterText: '',
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
                        if (!checkPrefecture(value as String)) {
                          prefecture = '';
                          return '都道府県が正しくありません';
                        }
                        prefecture = value;
                        //print(prefecture);
                        return null;
                      },
                      enabled: true,
                      maxLength: 4,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '都道府県',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：高知県',
                        counterText: '',
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
                        if (!checkCity(value as String)) {
                          city = '';
                          return '市区町村が正しくありません';
                        }
                        city = value;
                        // print(city);
                        return null;
                      },
                      enabled: true,
                      maxLength: 7,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '市区町村',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：高知市',
                        counterText: '',
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
                        if (!checkAddress(value as String)) {
                          address = '';
                          return '番地が正しくありません';
                        }
                        address = value;
                        // print(address);
                        return null;
                      },
                      enabled: true,
                      maxLength: 7,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: '番地・建物名',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '例：1-1-1',
                        counterText: '',
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                const SizedBox(
                  width: 300,
                  child: Text(
                    '生年月日',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
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
                Text(
                  // エラーメッセージを表示する変数などを使用する
                  checkBrithday(year, month, day),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
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

                Text(
                  checkSelectedGender(selectedGender),
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ), //法人名とメールアドレスはへ変更できるならtrue
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                width: 300,
                child: TextFormField(
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
                  decoration: InputDecoration(
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
            const Padding(
              padding: EdgeInsets.all(20.0),
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
              onPressed: () {
                // ログインボタンが押されたときの処理をここに追加予定
                if (checkName(name) &&
                    checkUserName(username) &&
                    checkMail(mail) &&
                    checkPhoneNumber(phoneNumber) &&
                    checkPostalCode(postalCode) &&
                    checkYear(year) &&
                    checkMonth(month) &&
                    checkDay(day) &&
                    checkSelectedGender(selectedGender) != '' &&
                    checkPassword(password) &&
                    checkPassword(passwordCheck) &&
                    checkPasswordMatch(password, passwordCheck) &&
                    ruleCheck) {
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
                                  "法人会員登録ありがとうございます。\nこちらで法人確認を行ったあと、法人会員登録完了メールをご登録メールアドレスへと送信いたしますので、メールが届くまで今しばらくお待ちください。\n万が一法人会員登録完了メールが１か月以上届かない場合、お問い合わせホームにてお問い合わせをしていただくと幸いです。",
                              buttonText: "ログイン画面に戻る",
                              jedgeBottomAppBar: true,
                              popTimes: 0,
                            )),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('入力内容に誤りがあります。'),
                        content: const Text('入力内容をご確認ください。'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
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
              child: const Text('同意する'),
            ),
            const SizedBox(
              height: 20,
            ),
            //空白
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
    );
  }
}

bool checkName(String name) {
  return name.isNotEmpty;
}

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

bool checkPhoneNumber(String phoneNumber) {
  //電話番号の正規表現
  final regPhoneNumber = RegExp(
    caseSensitive: false,
    r"^[0-9]{10,11}$",
  );
  return regPhoneNumber.hasMatch(phoneNumber);
}

bool checkPostalCode(String postalCode) {
  //住所の正規表現
  final regPostalCode = RegExp(
    caseSensitive: false,
    r"^[0-9]{3}-[0-9]{4}$",
  );
  return regPostalCode.hasMatch(postalCode);
}

bool checkPrefecture(String value) {
  //都道府県の正規表現
  return value.isNotEmpty;
}

bool checkCity(String city) {
  //市区町村の正規表現
  return city.isNotEmpty;
}

bool checkAddress(String address) {
  //番地の正規表現
  return address.isNotEmpty;
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
