import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/overlay/rule/screen/rule_screen.dart'; //オーバレイで表示される画面のファイル
import 'package:reelproject/component/finish_screen/finish_screen.dart';

class NewMemberGeneral extends StatefulWidget {
  const NewMemberGeneral({super.key});

  @override
  NewMemberGeneralState createState() => NewMemberGeneralState();
}

class NewMemberGeneralState extends State<NewMemberGeneral> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
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
            const TextEnterBox(
                label: 'ユーザー名', hinttext: '英数字と_のみ使用可', width: 300),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            const TextEnterBox(
                label: 'メールアドレス', hinttext: '例：info@example.com', width: 300),
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
            const SizedBox(
              width: 300,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextEnterBox(label: '西暦', hinttext: '', width: 100),
                    Text('年', style: TextStyle(fontSize: 15)),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    TextEnterBox(label: '', hinttext: '', width: 50),
                    Text('月', style: TextStyle(fontSize: 15)),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    TextEnterBox(label: '', hinttext: '', width: 50),
                    Text('日', style: TextStyle(fontSize: 15)),
                  ]),
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
            ),
            const SizedBox(
              width: 300,
            ),
            const SizedBox(
              width: 300,
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
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            PasswordInput(
                labelText: 'パスワード', onVisibilityToggle: (isVisible) {}),
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            PasswordInput(
                labelText: 'パスワード（確認用）', onVisibilityToggle: (isVisible) {}),
            const Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // パスワードを忘れた場合の画面に遷移
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
                          )),
                );
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
          ],
        ),
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
    );
  }
}

class TextEnterBox extends StatelessWidget {
  //入力を生成するコード
  final String? label;
  final String? hinttext;
  final double width;
  const TextEnterBox({
    required this.label,
    required this.hinttext,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          hintText: hinttext,
        ),
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final String labelText;
  final bool isObscure;
  final ValueChanged<bool> onVisibilityToggle;

  const PasswordInput({
    super.key,
    required this.labelText,
    this.isObscure = true,
    required this.onVisibilityToggle,
  });

  @override
  PasswordInputState createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        obscureText: _isObscure,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                widget.onVisibilityToggle(_isObscure);
              });
            },
          ),
        ),
      ),
    );
  }
}
