import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '/provider/change_general_corporation.dart';
import 'general_mem_inf_change.dart';
import '../login/pass_change.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
//push先

@RoutePage()
class GeneralMemInfConfRouterPage extends AutoRouter {
  const GeneralMemInfConfRouterPage({super.key});
}

@RoutePage()
class GeneralMemInfConf extends StatefulWidget {
  const GeneralMemInfConf({super.key});

  @override
  State<GeneralMemInfConf> createState() => _GeneralMemInfConfState();
}

class _GeneralMemInfConfState extends State<GeneralMemInfConf> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: TitleAppBar(title: "会員情報", jedgeBuck: true),

      //内部
      body: ScrollGeneralMemInfConfDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollGeneralMemInfConfDetail extends StatelessWidget {
  const ScrollGeneralMemInfConfDetail({
    super.key,
  });

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
            //アイコンと名前の間に空白
            //空白
            const SizedBox(
              height: 30,
            ),
            //下の詳細部分
            //アイコン部分との空白

            SizedBox(
              width: 300,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ユーザ名',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    const Text(
                      '　ユーザ名',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: store.greyColor,
                      thickness: 1,
                      endIndent: 20,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(
                      'メールアドレス',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    const Text(
                      '　メールアドレス',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: store.greyColor,
                      thickness: 1,
                      endIndent: 20,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(
                      '生年月日',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    const Text(
                      '　生年月日',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: store.greyColor,
                      thickness: 1,
                      endIndent: 20,
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    Text(
                      '性別',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    const Text(
                      '　男性',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    Divider(
                      color: store.greyColor,
                      thickness: 1,
                      endIndent: 20,
                    ),
                  ]),
            ),
            const Padding(padding: EdgeInsets.all(30)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeneralMemInfConfChange(),
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
              child: const Text('会員情報を編集する'),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PassChange(
                      loginJedge: false,
                    ), //今はログイン前のパスワード再設定画面に遷移
                  ),
                );
              },
              splashColor: Colors.transparent,
              child: const Text(
                'パスワードを変更する',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
          ],
        ),
      )),
    );
  }
}

//一般向けマイページスクロール
