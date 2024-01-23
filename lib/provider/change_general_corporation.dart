import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 他ファイルから使用するために、変数とメソッドの_を削除。
class ChangeGeneralCorporation with ChangeNotifier {
  //ロード待ち時間(アプリ内):1000 = 1秒
  static const int waitTime = 800;

  //イベント、求人スクロール更新関数
  bool reloadEventScroll = false;
  bool reloadJobScroll = false;

  //reloadEventScrollをtrueに変更する関数
  void changeReloadEventScrollOn(bool b) {
    Future.delayed(Duration.zero, () {
      reloadEventScroll = b;
      notifyListeners();
    });
  }

  //reloadJobScrollをtrueに変更する関数
  void changeReloadJobScrollOn(bool b) {
    Future.delayed(Duration.zero, () {
      reloadJobScroll = b;
      notifyListeners();
    });
  }

  //ルート更新用の関数
  bool reloadHomeJedge = false;
  bool reloadEventJedge = false;
  bool reloadJobJedge = false;
  bool reloadMypageJedge = false;

  //reloadHomeJedgeをtrueに変更する関数
  void changeReloadHomeJedgeOn(bool b) {
    reloadHomeJedge = b;
    notifyListeners();
  }

  //reloadEventJedgeをtrueに変更する関数
  void changeReloadEventJedgeOn(bool b) {
    reloadEventJedge = b;
    notifyListeners();
  }

  //reloadJobJedgeをtrueに変更する関数
  void changeReloadJobJedgeOn(bool b) {
    reloadJobJedge = b;
    notifyListeners();
  }

  //reloadMypageJedgeをtrueに変更する関数
  void changeReloadMypageJedgeOn(bool b) {
    reloadMypageJedge = b;
    notifyListeners();
  }

  // APIのリンク
  static const String apiUrl = "http://localhost:8000/api/v1";
  // static const String apiUrl = "http://34.196.90.77:8000/api/v1";
  //static const String apiUrl = "http://10.0.2.2:8000/api/v1"; //アンドロイドエミュレーター用

  //タイプ一覧(デバック中はすべてallとする)
  static const String typeAll = "status=all";
  static const String typeActive = "status=active";
  static const String typeInactive = "status=inactive";
  static const String typeDraft = "status=draft";
  static const String typePosted = "status=posted";

  //ソート一覧
  static const String sortRecent = "sort=recent";
  static const String sortReview = "sort=review";
  static const String sortFavorite = "sort=favorite";
  static const String sortPv = "sort=pv";
  static const String sortId = "sort=id";
  static const String sortLastWatched = "sort=last_watched";
  //ユーザ情報
  String? accessToken = dotenv.env['ACCESS_TOKEN']; //初期値はnull
  bool skiplogin = true; //ログインスキップ判断
  int myID = 2; //自分のID(一般ID)

  //自分のユーザ情報マップ(APIにて取得)
  Map<String, dynamic> userInfo = {
    "username": "",
    "image_url": "",
    "email": "",
    "sex": "",
    "birthday": "",
    "user_type": "",
    "id": 2,
    "company": {
      "name": "",
      "postal_code": "string",
      "prefecture": "string",
      "city": "string",
      "address": "string",
      "phone_number": "string",
      "email": "user@example.com",
      "homepage": "",
      "representative": "string",
      "id": 1
    },
    "is_active": true
  };

  //自分のユーザ情報マップを変更する関数
  changeUserInfo(Map<String, dynamic> info) {
    userInfo = info; //ユーザ情報変更
    myID = info["id"]; //自分のID変更
    //ユーザーの状態変更
    //一般
    if (info["user_type"] == "g") {
      changeGC(true);
    }
    //法人
    else {
      changeGC(false);
    }
    notifyListeners();
  }

  //自分のユーザ情報マップをAPIにて取得
  Future getMyUserInfo() async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/users/me');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${accessToken}'
    });
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeUserInfo(json.decode(data));
    } else {
      throw Exception("Failed");
    }
    notifyListeners();
  }

  //自分のユーザ情報を更新
  Future UpdateUserInfo() async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/users/${myID}');
    final response = await http.put(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${accessToken}',
      'Content-Type': 'application/json',
    }, body: {
      "password"
    });
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeUserInfo(json.decode(data));
    } else {
      throw Exception("Failed");
    }
    notifyListeners();
  }

  //=============================================

  //一般と法人を判断する変数
  //一般:true,  法人:flase
  bool jedgeGC = true;

  //[jedgeGCに依存する色一覧]

  //一般の色(定数)
  static const Color generalMainColor = Color.fromARGB(255, 233, 146, 7);
  static const Color generalSubColor = Color.fromARGB(255, 255, 195, 104);
  static const Color generalThinColor = Color.fromARGB(255, 255, 207, 134);
  static const Color generalBlackColor = Color.fromARGB(255, 49, 30, 0);

  //法人の色(定数)
  static const Color corporationMainColor = Color(0xFF55A2E1);
  static const Color corporationSubColor = Color.fromARGB(255, 114, 192, 255);
  static const Color corporationThinColor = Color.fromARGB(255, 187, 224, 255);
  static const Color corporationBlackColor = Color.fromARGB(255, 0, 34, 61);

  //半透明
  static const Color transparent = Color.fromARGB(60, 0, 0, 0);

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
