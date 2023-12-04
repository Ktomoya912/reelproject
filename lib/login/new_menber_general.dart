// 男性、女性、その他を選択する欄を横に並べるコード

import 'package:flutter/material.dart';
import 'package:reelproject/page/home/home.dart';
import 'package:reelproject/provider/changeGeneralCorporation.dart';
import 'package:provider/provider.dart';

class NewMemberGeneral extends StatefulWidget {
  const NewMemberGeneral({Key? key}) : super(key: key);

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
    return ChangeNotifierProvider(
        create: (context) => ChangeGeneralCorporation(),
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('新規登録'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TextEnterBox(label: 'ユーザー名', hinttext: '氏名', width: 300),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                const TextEnterBox(
                    label: 'メールアドレス',
                    hinttext: '例：info@example.com',
                    width: 300),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextEnterBox(label: '西暦', hinttext: '', width: 100),
                      Text('年'),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      TextEnterBox(label: '', hinttext: '', width: 50),
                      Text('月'),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      TextEnterBox(label: '', hinttext: '', width: 50),
                      Text('日'),
                    ]),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
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
                        Text('男性')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'female',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        Text('女性')
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'other',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),
                        Text('その他')
                      ],
                    ),
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
                    labelText: 'パスワード（確認用）',
                    onVisibilityToggle: (isVisible) {}),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        '利用規約',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Text(
                      'に同意する',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
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
                    backgroundColor: store.subColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(300, 50),
                  ),
                  child: const Text('同意する'),
                ),
              ],
            ),
          );
        }));
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
    Key? key,
  }) : super(key: key);

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
    Key? key,
    required this.labelText,
    this.isObscure = true,
    required this.onVisibilityToggle,
  }) : super(key: key);

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