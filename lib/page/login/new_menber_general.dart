import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/overlay/rule/screen/rule_screen.dart'; //オーバレイで表示される画面のファイル
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:reelproject/component/form/general_form.dart';
import 'package:reelproject/component/form/password_input.dart';

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
            const GeneralForm(enable: true), //法人名とメールアドレスはへ変更できるならtrue
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
              child: const Text('同意する', style: TextStyle(color: Colors.white)),
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
