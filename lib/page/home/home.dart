import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/page/home/notice.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}

@RoutePage()
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int index = 0; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: MainAppBar(nextPage: Notice()),
    );
  }
}

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
    return const Size(double.infinity, 80.0);
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
