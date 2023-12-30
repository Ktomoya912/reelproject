import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

class ApplyConf extends StatefulWidget {
  const ApplyConf({
    super.key,
  });

  @override
  ApplyConfState createState() => ApplyConfState();
}

class ApplyConfState extends State<ApplyConf> {
  // bool _autoLogin = false; // チェックボックスの状態を管理する変数

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);

    return Scaffold(
      appBar: const TitleAppBar(
        title: "問い合わせ",
        jedgeBuck: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              '応募者プロフィール',
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
    );
  }
}
