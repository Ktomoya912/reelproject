import 'package:flutter/material.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
//import 'package:reelproject/page/login/login_page.dart';

//使い方
//現在はログイン画面に戻る処理のみ
//このファイルは今後基本的には使わない！
//ファイルの上部でimport 'ButtonSet.dart';と置く
//その後、body内で"const ButtonSet();"のように宣言
class ButtonSet extends StatelessWidget {
  final String buttonName;
  final int popTimes; //何回popするか(0の場合はルートまで戻る)

  const ButtonSet({
    super.key,
    required this.buttonName,
    required this.popTimes,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    return ElevatedButton(
      onPressed: () {
        //最初の画面まで戻る
        if (popTimes == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          //Navigator.of(context).pop(popTimes);
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= popTimes);
        }
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
