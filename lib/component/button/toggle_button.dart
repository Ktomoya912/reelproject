import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

//ToggleButtonにて使用するボタンが押されているか否かの判定bool
class ChangeToggleButton with ChangeNotifier {
  var _toggleList = <bool>[true, false];
  int onButtonIndex = 0;

  void changeToggleList(i) {
    switch (i) {
      case 0:
        if (_toggleList[1]) {
          _toggleList = [true, false];
          onButtonIndex = 0;
        }
        break;
      case 1:
        if (_toggleList[0]) {
          _toggleList = [false, true];
          onButtonIndex = 1;
        }
        break;
    }
    notifyListeners();
  }
}

//ToggleButtonを作成するクラス
class ToggleButton extends StatelessWidget {
  final MediaQueryData mediaQueryData;
  final String leftTitle;
  final String rightTitle;
  final double height;

  const ToggleButton({
    super.key,
    required this.mediaQueryData, //context
    required this.leftTitle, //左の文字
    required this.rightTitle, //右の文字
    required this.height, //ボタンの高さ
  });

  @override
  Widget build(BuildContext context) {
    final toggleStore = Provider.of<ChangeToggleButton>(context); //プロバイダ
    final colorStore = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Container(
        height: height, //高さ
        //下線
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorStore.greyColor),
          ),
        ),
        child: ToggleButtons(
            //ボタンの文字と枠
            color: colorStore.greyColor, //選択されていないときの色
            selectedColor: colorStore.mainColor, //選択されているときの色
            fillColor: colorStore.thinColor, //選択されているときの背景色
            borderColor: colorStore.thinColor, //枠線の色
            //selectedBorderColor: colorStore.thinColor, //選択時の枠線の色
            //borderWidth: 0, //枠線の太さ
            renderBorder: false, //枠線なし
            //ボタン選択関連
            isSelected: toggleStore._toggleList, //ボタンが反応しているか否か
            //ボタンが押された時の動作
            onPressed: (index) {
              toggleStore.changeToggleList(index);
            },
            //ボタンの文字と枠
            children: <Widget>[
              SizedBox(
                  width: mediaQueryData.size.width / 2,
                  child: Center(
                      child: Text(leftTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)))),
              SizedBox(
                  width: mediaQueryData.size.width / 2,
                  child: Center(
                      child: Text(rightTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15))))
            ]));
  }
}
