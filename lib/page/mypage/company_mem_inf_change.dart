import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/page/mypage/mypage.dart';
import '/provider/change_general_corporation.dart';
import '../../component/form/company_form.dart';
import '../login/pass_change.dart';
//push先

@RoutePage()
class CompanyMemInfConfChangeRouterPage extends AutoRouter {
  const CompanyMemInfConfChangeRouterPage({super.key});
}

@RoutePage()
class CompanyMemInfConfChange extends StatefulWidget {
  const CompanyMemInfConfChange({super.key});

  @override
  State<CompanyMemInfConfChange> createState() =>
      _CompanyMemInfConfChangeState();
}

class _CompanyMemInfConfChangeState extends State<CompanyMemInfConfChange> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: CompanyMemInfConfChangeAppBar(
        title: "会員情報",
        jedgeBuck: true,
      ),

      //内部
      body: ScrollCompanyMemInfConfChangeDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollCompanyMemInfConfChangeDetail extends StatelessWidget {
  const ScrollCompanyMemInfConfChangeDetail({
    super.key,
  });

  //一般向けマイページリスト

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return SingleChildScrollView(
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
                  builder: (context) => const PassChange(), //写真編集画面を作成する必要あり
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

          const CompanyForm(enable: false),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: store.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(300, 50),
            ),
            child: const Text('編集内容を決定'),
          ),

          const Padding(padding: EdgeInsets.all(10)),
        ],
      ),
    ));
  }
}

//一般向けマイページスクロール

//マイページリストを作成するクラス

//appbar
class CompanyMemInfConfChangeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title; //ページ名
  final bool jedgeBuck; //戻るボタンを表示するか否か

  const CompanyMemInfConfChangeAppBar({
    super.key,
    required this.title,
    required this.jedgeBuck,
  });

  @override
  Size get preferredSize {
    return const Size(double.infinity, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(

        //アップバー
        appBar: AppBar(
      //アップバータイトル
      title: Text(
        "REEL", //文字
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: store.mainColor), //書体
      ),
      automaticallyImplyLeading: jedgeBuck, //戻るボタンの非表示
      backgroundColor: Colors.white, //背景
      elevation: 0.0, //影なし
      iconTheme: IconThemeData(color: store.greyColor), //戻るボタン
      centerTitle: true, //中央揃え
      toolbarHeight: 100, //アップバーの高さ

      //画面説明アップバー
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: SizedBox(
            height: 30,
            child: AppBar(
              //アップバー内にアップバー(ページ説明のため)
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: store.blackColor,
                ),
              ), //ページ説明文字
              centerTitle: true, //中央揃え
              automaticallyImplyLeading: false, //戻るボタンの非表示
              backgroundColor: store.subColor, //背景
              elevation: 0.0, //影なし
            ), //高さ
          )), //高さ
    ));
  }
}
