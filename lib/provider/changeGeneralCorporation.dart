import 'package:flutter/material.dart';

// 他ファイルから使用するために、変数とメソッドの_を削除。
class ChangeGeneralCorporation with ChangeNotifier {
  //一般と法人を判断する変数
  //一般:true,  法人:flase
  bool jedgeGC = true;

  //[jedgeGCに依存する色一覧]

  //一般の色(定数)
  static const Color generalMainColor = Color.fromARGB(255, 224, 119, 0);
  static const Color generalSubColor = Color.fromARGB(255, 238, 188, 126);
  static const Color generalThinColor = Color.fromARGB(255, 255, 214, 153);
  static const Color generalBlackColor = Color.fromARGB(255, 49, 30, 0);

  //法人の色(定数)
  static const Color corporationMainColor = Color.fromARGB(255, 0, 96, 175);
  static const Color corporationSubColor = Color.fromARGB(255, 114, 192, 255);
  static const Color corporationThinColor = Color.fromARGB(255, 187, 224, 255);
  static const Color corporationBlackColor = Color.fromARGB(255, 0, 34, 61);

  //実際に使用する変数
  Color mainColor = generalMainColor;
  Color subColor = generalSubColor;
  Color thinColor = generalThinColor;
  Color blackColor = generalBlackColor;

  Color whiteColor = Colors.white; //白色
  Color greyColor = Colors.grey; //灰色

  // 一般と法人を区別する変数jedgeGC変更を行う関数
  void changeGC(bool gc) {
    jedgeGC = gc; //一般法人変更

    //  一般・法人色変更
    if (gc) {
      mainColor = generalMainColor;
      subColor = generalSubColor;
      thinColor = generalThinColor;
      blackColor = generalBlackColor;
    } else {
      mainColor = corporationMainColor;
      subColor = corporationSubColor;
      thinColor = corporationThinColor;
      blackColor = corporationBlackColor;
    }
    notifyListeners();
  }
}
