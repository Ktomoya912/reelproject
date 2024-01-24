import 'dart:async';

import 'package:flutter/material.dart';

import '../../over_screen_controller.dart';

import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:http/http.dart';

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)

class ConfConf {
  factory ConfConf() => _shared;
  static final ConfConf _shared = ConfConf._sharedInstance();

  ConfConf._sharedInstance();

  OverScreenControl? controller;

  //応募者確認
  Future confConf(int jobID, ChangeGeneralCorporation store, int userID) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/jobs/${jobID}/application/approve?user_id=${userID}');
    final response = await put(
      url,
      headers: {
        'accept': 'application/json',
        'authorization': 'Bearer ${store.accessToken}',
      },
    );
  }

  void show({
    // オーバーレイ表示動作
    required BuildContext context,
    required int userID,
    required int jobID,
  }) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        userID: userID,
        jobID: jobID,
      );
    }
  }

  void hide() {
    // オーバーレイを閉じる動作
    controller?.close();
    controller = null;
  }

  OverScreenControl showOverlay({
    required BuildContext context,
    required int userID,
    required int jobID,
  }) {
    final text0 = StreamController<String>();

    final state = Overlay.of(context);
    // final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        final store = Provider.of<ChangeGeneralCorporation>(context);

        String buttonText = "ホーム画面に戻る";
        if (store.rootIndex == 0) {
          buttonText = "ホーム画面に戻る";
        } else if (store.rootIndex == 1) {
          buttonText = "イベント画面に戻る";
        } else if (store.rootIndex == 2) {
          buttonText = "求人画面に戻る";
        } else if (store.rootIndex == 3) {
          buttonText = "マイページ画面に戻る";
        }
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
                // constraints: BoxConstraints(
                //   maxWidth: size.width * 0.7,
                //   maxHeight: size.height * 1.5,
                //   minWidth: size.width * 0.2,
                // ),
                height: 250,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //ウィジェットを保管
                        const Text(
                          "本当に確認しますか？",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20), //余白調整
                        ElevatedButton(
                          // ボタンを作る関数
                          //ボタン設置
                          onPressed: () {
                            // ボタンが押されたときの処理をここに追加予定
                            ConfConf().confConf(jobID, store, userID);
                            store.changeOverlay(false);
                            //Navigator.pop(context);
                            //Navigator.pop(context);
                            //Navigator.pop(context);
                            ConfConf().hide();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FinishScreen(
                                  appbarText: "応募者確認",
                                  appIcon: Icons.playlist_add_check,
                                  finishText: "確認完了",
                                  text:
                                      "この度は応募者確認をしていただきありがとうございます。\n今回行っていただいた応募者確認情報はアプリの機能改善に用いさせていただきます。",
                                  buttonText: "応募者一覧に戻る",
                                  jedgeBottomAppBar: false,
                                  popTimes: 2,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(220, 60), //ボタンの大きさ
                            backgroundColor: store.mainColor,
                          ),
                          child: const Text(
                            "確認", //Elevateの子供
                            style: TextStyle(
                                color: Colors.white,
                                //fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20), //余白調整
                        ElevatedButton(
                          // ボタンを作る関数
                          //ボタン設置
                          onPressed: () {
                            store.changeOverlay(false);
                            // ボタンが押されたときの処理をここに追加予定
                            ConfConf().hide();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(220, 60),
                            backgroundColor: Colors.grey[400],
                          ),
                          child: const Text("キャンセル", //Elevateの子供
                              style: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );

    state.insert(overlay);

    return OverScreenControl(
      close: () {
        text0.close();
        overlay.remove();
        return true;
      },
      update: () {
        return true;
      },
    );
  }
}
