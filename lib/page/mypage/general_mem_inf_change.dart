import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/page/mypage/mypage.dart';
import '/provider/change_general_corporation.dart';
import '../../component/form/general_form.dart';
import '../login/pass_change.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
//push先

@RoutePage()
class GeneralMemInfConfChangeRouterPage extends AutoRouter {
  const GeneralMemInfConfChangeRouterPage({super.key});
}

@RoutePage()
class GeneralMemInfConfChange extends StatefulWidget {
  const GeneralMemInfConfChange({super.key});

  @override
  State<GeneralMemInfConfChange> createState() =>
      _GeneralMemInfConfChangeState();
}

class _GeneralMemInfConfChangeState extends State<GeneralMemInfConfChange> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: TitleAppBar(title: "会員情報", jedgeBuck: true),

      //内部
      body: ScrollGeneralMemInfConfChangeDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollGeneralMemInfConfChangeDetail extends StatelessWidget {
  const ScrollGeneralMemInfConfChangeDetail({
    super.key,
  });

  //一般向けマイページリスト

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return ShaderMaskComponent(
      child: SingleChildScrollView(
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
                    builder: (context) => const PassChange(
                      loginJedge: false,
                    ), //写真編集画面を作成する必要あり
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

            const GeneralForm(enable: false),

            //空白
            const SizedBox(
              height: 50,
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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

            const Padding(padding: EdgeInsets.all(20)),
          ],
        ),
      )),
    );
  }
}

//一般向けマイページスクロール

//マイページリストを作成するクラス

