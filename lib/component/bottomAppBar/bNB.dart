import 'package:flutter/material.dart';
import '/page/home/home.dart';
import '/page/event/event.dart';
import '/page/job/job.dart';
import '/page/myPage/myPage.dart';

//BottomAppBarを作成するクラス
//用いる時は上に"import '../bottomAppBar/bNB.dart';"と宣言を行い、
//scafforld内で"bottomNavigationBar: BNB(index: 1));"と宣言する
//このとき、index: 1とするのではなく、@override上で
//final int index;と宣言してindex: indexとするのが望ましい
//この時用いる数字は0:ホーム,1:イベント,2:求人,3:マイページと対応しており、
//下に表示したアイコンに沿って挿入を行う必要がある。
//また、このファイルの上部における参照ファイルは適切なものひ変更する必要がある。
class BNB extends StatelessWidget {
  final int index; //引数に対応する番号を入れる

  const BNB({
    super.key,
    required this.index,
  });

  static var _pages = <Widget>[
    Home(),
    Event(),
    Job(),
    MyPage(),
  ];

  //ページ移動関数
  static void _onItemTapped(int i, BuildContext con) {
    Navigator.push(
        con,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _pages[i]));
  }

  // build()
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, //見た目、動作をコントロール
      backgroundColor: Colors.orange.shade200, //バーの色

      //選択されたアイコンとラベルの色
      selectedItemColor: Color.fromARGB(255, 255, 140, 0),

      //選択されたアイコンのテーマ
      selectedIconTheme: const IconThemeData(size: 45),
      //選択されていないアイコンのテーマ
      unselectedIconTheme: const IconThemeData(size: 30),

      //選択されたタイトルのスタイル
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      //選択されていないタイトルのスタイル
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

      selectedFontSize: 12, //選択されたフォントのスタイル

      //使用中アイコン情報
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'ホーム',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.celebration),
          label: 'イベント',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: '求人',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'マイページ',
        ),
      ],
      currentIndex: index,
      onTap: (int i) => _onItemTapped(i, context),
    );
  }
}
