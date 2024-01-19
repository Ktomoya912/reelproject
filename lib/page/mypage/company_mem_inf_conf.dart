import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '/provider/change_general_corporation.dart';
import '../login/pass_change.dart';
import 'company_mem_inf_change.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
//push先

@RoutePage()
class CompanyMemInfConfRouterPage extends AutoRouter {
  const CompanyMemInfConfRouterPage({super.key});
}

@RoutePage()
class CompanyMemInfConf extends StatefulWidget {
  const CompanyMemInfConf({super.key});

  @override
  State<CompanyMemInfConf> createState() => _CompanyMemInfConfState();
}

class _CompanyMemInfConfState extends State<CompanyMemInfConf> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store =
          Provider.of<ChangeGeneralCorporation>(context, listen: false);
      store.getMyUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: TitleAppBar(title: "会員情報", jedgeBuck: true),

      //内部
      body: ScrollCompanyMemInfConfDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollCompanyMemInfConfDetail extends StatefulWidget {
  const ScrollCompanyMemInfConfDetail({
    super.key,
  });

  @override
  State<ScrollCompanyMemInfConfDetail> createState() =>
      _ScrollCompanyMemInfConfDetailState();
}

class _ScrollCompanyMemInfConfDetailState
    extends State<ScrollCompanyMemInfConfDetail> {
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
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                      // これを追加
                      borderRadius: BorderRadius.circular(50), // これを追加
                      child: Image.network("${store.userInfo["image_url"]}",
                          fit: BoxFit.cover),
                    ),
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
                      '法人名',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    Text(
                      '　${store.userInfo["company"]["name"]}',
                      style: const TextStyle(
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
                      'ユーザ名',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    Text(
                      '　${store.userInfo["username"]}',
                      style: const TextStyle(
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
                    Text(
                      '　${store.userInfo["company"]["email"]}',
                      style: const TextStyle(
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
                      '電話番号',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    Text(
                      '　${store.userInfo["company"]["phone_number"]}',
                      style: const TextStyle(
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
                      '住所',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: store.greyColor,
                      ),
                    ),
                    Text(
                      '　${store.userInfo["company"]["prefecture"]}${store.userInfo["company"]["city"]}${store.userInfo["company"]["address"]}',
                      style: const TextStyle(
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
                    Text(
                      '　${store.userInfo["birthday"].substring(0, 4)}年 ${store.userInfo["birthday"].substring(5, 7)}月 ${store.userInfo["birthday"].substring(8, 10)}日',
                      style: const TextStyle(
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
                    Text(
                      '　${store.userInfo["sex"] == "m" ? "男性" : store.userInfo["sex"] == "f" ? "女性" : "その他"}',
                      style: const TextStyle(
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
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyMemInfConfChange(),
                  ),
                );
                store.getMyUserInfo();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: store.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(300, 50),
              ),
              child: const Text('会員情報を編集する',
                  style: TextStyle(color: Colors.white)),
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

//マイページリストを作成するクラス


