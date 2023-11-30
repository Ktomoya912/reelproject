import 'package:flutter/material.dart';

//使い方
//ファイルの上部でimport 'normalBottomAppBar.dart';と置く
//その後、Scaffold内で"appBar: NormalBottomAppBar()""のように宣言
class NormalBottomAppBar extends StatelessWidget {
  const NormalBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      height: 40,
    );
  }
}
