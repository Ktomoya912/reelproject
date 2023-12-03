import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/changeGeneralCorporation.dart';

//使い方
//ファイルの上部でimport '.mainAppBar.dart';と置く
//その後、Scaffold内で"appBar: MainAppBar(nextPage: notice())""のように宣言
//この時のnextPageには移動先クラスを置く
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget nextPage; //通知ボタンから移動するページ

  const MainAppBar({
    super.key,
    required this.nextPage,
  });

  @override
  Size get preferredSize {
    return Size(double.infinity, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return AppBar(
        //アップバータイトル
        title: Text(
          "REEL", //文字
          style: TextStyle(
              color: store.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 40), //書体
        ),
        backgroundColor: store.subColor,
        elevation: 0.0, //影なし
        toolbarHeight: 100, //アップバーの高さ
        automaticallyImplyLeading: false, //戻るボタンの非表示
        centerTitle: true,
        //アップバーアイコン
        actions: <Widget>[
          //通知ボタン
          IconButton(
            icon: const Icon(Icons.add_alert),
            color: store.mainColor,
            //通知ページへ移動(push)
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          nextPage));
            },
          )
        ]);
  }
}
