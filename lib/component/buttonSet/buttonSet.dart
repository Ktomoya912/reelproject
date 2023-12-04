import 'package:flutter/material.dart';
import 'package:reelproject/provider/changeGeneralCorporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/login/login_page.dart';

//使い方
//現在はログイン画面に戻る処理のみ
//このファイルは今後基本的には使わない！
//ファイルの上部でimport 'ButtonSet.dart';と置く
//その後、body内で"const ButtonSet();"のように宣言
class ButtonSet extends StatelessWidget {
  final String buttonName;

  const ButtonSet({
    super.key,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    return ElevatedButton(
      onPressed: () {
        // ボタンが押されたときの処理をここに追加予定
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(130, 40),
        backgroundColor: store.mainColor,
      ),
      child: Text(buttonName, style: const TextStyle(color: Colors.white)),
    );
  }
}
