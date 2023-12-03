import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/changeGeneralCorporation.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/TitleAppBar.dart';

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static const title = "マイページ";
  final int index = 3; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: TitleAppBar(title: title),

      //内部
      body: ScrollMyPageDetail(),

      //ボトムナビゲーションバー
      bottomNavigationBar: BNB(index: index),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollMyPageDetail extends StatelessWidget {
  const ScrollMyPageDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Column(
              children: [
                //上のアイコン部分
                //上に空白
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 150, //アイコン高さ
                    width: 150, //アイコン幅
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, //円形に
                        color: store.subColor), //アイコン周囲円の色
                  ),
                ),
                //アイコンと名前の間に空白
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("ユーザ名",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ) //ユーザー名
              ],
            ),
            //空白
            const SizedBox(
              height: 10,
            ),
            //下の詳細部分
            //アイコン部分との空白
            Container(
                width: _mediaQueryData.size.width,
                height: 1000,
                color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //左詰め
                  children: [
                    Text("ユーザー設定",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
