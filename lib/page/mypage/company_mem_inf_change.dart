import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import '../login/pass_change.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:http/http.dart';
import 'dart:convert';
import "package:reelproject/component/finish_screen/finish_screen.dart";
//push先

class CompanyMemInfConfChange extends StatefulWidget {
  const CompanyMemInfConfChange({
    super.key,
  });

  @override
  State<CompanyMemInfConfChange> createState() =>
      _CompanyMemInfConfChangeState();
}

class _CompanyMemInfConfChangeState extends State<CompanyMemInfConfChange> {
  String? selectedGender = "";

  String username = '';
  String mymail = '';
  String phoneNumber = '';
  String postalCode = '';
  String prefecture = '';
  String city = '';
  String address = '';
  String year = '';
  String month = '';
  String day = '';

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
          "email": store.userInfo["company"]["email"],
          "sex": selectedGender,
          "birthday":
              "$year-${month.length == 2 ? month : "0$month"}-${day.length == 2 ? day : "0$day"}",
          "user_type": "c"
        }));
  }

  @override
  void initState() {
    super.initState();
    final store = Provider.of<ChangeGeneralCorporation>(context, listen: false);
    username = store.userInfo["username"];
    mymail = store.userInfo["email"];
    phoneNumber = store.userInfo["company"]["phone_number"];
    postalCode = store.userInfo["company"]["postal_code"];
    prefecture = store.userInfo["company"]["prefecture"];
    city = store.userInfo["company"]["city"];
    address = store.userInfo["company"]["address"];
    year = store.userInfo["birthday"].substring(0, 4);
    month = store.userInfo["birthday"].substring(5, 7);
    day = store.userInfo["birthday"].substring(8, 10);
    selectedGender = store.userInfo["sex"];
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                    ),

                    const Padding(
                      padding: EdgeInsets.all(5.0),
                    ),

                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          initialValue: store.userInfo["company"]["name"],
                          enabled: false,
                          maxLength: 20,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '法人名は変更できません',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
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
                          initialValue: store.userInfo["username"],
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
                          initialValue: store.userInfo["company"]["email"],
                          validator: (value) {
                            if (!checkMail(value as String)) {
                              mymail = '';
                              return '適切な入力ではありません';
                            }
                            mymail = value;
                            // print(mail);
                            return null;
                          },
                          enabled: false,
                          maxLength: 50,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '法人用メールアドレス',
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
                    // const Padding(
                    //   padding: EdgeInsets.all(10.0),
                    // ),

                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          initialValue: store.userInfo["company"]
                              ["phone_number"],
                          validator: (value) {
                            if (!checkPhoneNumber(value as String)) {
                              phoneNumber = '';
                              return '電話番号が正しくありません';
                            }
                            phoneNumber = value;
                            // print(phoneNumber);
                            return null;
                          },
                          enabled: false,
                          maxLength: 11,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '電話番号は変更できません',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
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
                          initialValue: store.userInfo["company"]
                              ["postal_code"],
                          validator: (value) {
                            if (!checkPostalCode(value as String)) {
                              postalCode = '';
                              return '郵便番号が正しくありません';
                            }
                            postalCode = value;
                            // print(postalCode);
                            return null;
                          },
                          enabled: false,
                          maxLength: 8,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '郵便番号は変更できません',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
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
                          initialValue: store.userInfo["company"]["prefecture"],
                          validator: (value) {
                            if (!checkPrefecture(value as String)) {
                              prefecture = '';
                              return '都道府県が正しくありません';
                            }
                            prefecture = value;
                            //print(prefecture);
                            return null;
                          },
                          enabled: false,
                          maxLength: 4,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '都道府県は変更できません',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
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
                          initialValue: store.userInfo["company"]["city"],
                          validator: (value) {
                            if (!checkCity(value as String)) {
                              city = '';
                              return '市区町村が正しくありません';
                            }
                            city = value;
                            // print(city);
                            return null;
                          },
                          enabled: false,
                          maxLength: 7,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '市区町村は変更できません',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
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
                          initialValue: store.userInfo["company"]["address"],
                          validator: (value) {
                            if (!checkAddress(value as String)) {
                              address = '';
                              return '番地が正しくありません';
                            }
                            address = value;
                            // print(address);
                            return null;
                          },
                          enabled: false,
                          maxLength: 7,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            labelText: '番地・建物名は変更できません',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
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
                                  initialValue: store.userInfo["birthday"]
                                      .substring(0, 4),
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
                                  initialValue: store.userInfo["birthday"]
                                      .substring(5, 7),
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
                                  initialValue: store.userInfo["birthday"]
                                      .substring(8, 10),
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

                    Text(
                      checkSelectedGender(selectedGender),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ), //法人名とメールアドレスはへ変更できるならtrue
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                if (checkUserName(username) &&
                    // checkPhoneNumber(phoneNumber) &&
                    // checkPostalCode(postalCode) &&
                    checkYear(year) &&
                    checkMonth(month) &&
                    checkDay(day) &&
                    selectedGender != '') {
                  userInfoUpdata(store); //ユーザー情報更新
                  store.getMyUserInfo();
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
  if (selectedGender == "") {
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
