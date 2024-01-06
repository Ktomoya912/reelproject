import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

//使い方
//ファイルの上部でimport 'normalBottomAppBar.dart';と置く
//その後、Scaffold内で"appBar: NormalBottomAppBar()""のように宣言
class NormalBottomAppBar extends StatelessWidget {
  const NormalBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return BottomAppBar(
      color: store.mainColor,
      height: 40,
    );
  }
}
