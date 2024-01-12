import 'package:flutter/material.dart';

// 他ファイルから使用するために、変数とメソッドの_を削除。
class ChangeGeneralCorporation with ChangeNotifier {
  // APIのリンク
  static const String apiUrl = "http://localhost:8000/api/v1";
  String accessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbiIsImV4cCI6MTcwNzY2NTI3Mn0.e3EhsKqWjv5XX_iAKs1M3hRcy3MORXFef7m64E4XsJ8";
  int myID = 1; //自分のID

  //一般と法人を判断する変数
  //一般:true,  法人:flase
  bool jedgeGC = true;

  //[jedgeGCに依存する色一覧]

  //一般の色(定数)
  static const Color generalMainColor = Color.fromARGB(255, 233, 146, 7);
  static const Color generalSubColor = Color.fromARGB(255, 239, 178, 102);
  static const Color generalThinColor = Color.fromARGB(255, 255, 226, 182);
  static const Color generalBlackColor = Color.fromARGB(255, 49, 30, 0);

  //法人の色(定数)
  static const Color corporationMainColor = Color(0xFF55A2E1);
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

  //以下はグラフの切り替えに使用する変数と関数
  Map<String, double> mainDataMap = {
    "20歳未満": 30,
    "20-24歳": 40,
    "25-29歳": 10,
    "30-34歳": 5,
    "35-39歳": 7,
    "40歳以上": 8,
  };

  Map<String, double> subDataMap1 = {
    "20歳未満": 5,
    "20-24歳": 3,
    "25-29歳": 2,
    "30-34歳": 2,
    "35-39歳": 2,
    "40歳以上": 2,
  };

  Map<String, double> subDataMap2 = {
    "20歳未満": 5,
    "20-24歳": 3,
    "25-29歳": 2,
    "30-34歳": 2,
    "35-39歳": 2,
    "40歳以上": 2,
  };

  Map<String, double> subDataMap3 = {
    "20歳未満": 5,
    "20-24歳": 3,
    "25-29歳": 2,
    "30-34歳": 2,
    "35-39歳": 2,
    "40歳以上": 2,
  };

  String mainTitle = "閲覧者の年代別グラフ";
  String subTitle1 = "男性の年代別グラフ";
  String subTitle2 = "女性の年代別グラフ";
  String subTitle3 = "その他の年代別グラフ";

  void toggleDataSelection(Map<String, double> dataMap) {
    Map<String, double> tempMap; //退避領域
    String tempTitle; //退避領域
    tempMap = mainDataMap;
    tempTitle = mainTitle;
    if (dataMap == mainDataMap) {
    } else if (dataMap == subDataMap1) {
      mainDataMap = subDataMap1;
      subDataMap1 = tempMap;
      mainTitle = subTitle1;
      subTitle1 = tempTitle;
    } else if (dataMap == subDataMap2) {
      mainDataMap = subDataMap2;
      subDataMap2 = tempMap;
      mainTitle = subTitle2;
      subTitle2 = tempTitle;
    } else if (dataMap == subDataMap3) {
      mainDataMap = subDataMap3;
      subDataMap3 = tempMap;
      mainTitle = subTitle3;
      subTitle3 = tempTitle;
    }
    notifyListeners();
  }

  //オーバーレイ表示判断
  bool jedgeOverlay = false;

  void changeOverlay(bool o) {
    jedgeOverlay = o;
    notifyListeners();
  }

  //現在のルート番号保存
  int rootIndex = 0;
  void changeRootIndex(int i) {
    rootIndex = i;
    notifyListeners();
  }
}
