import 'dart:async';

import 'package:flutter/material.dart';

import '../over_screen_controller.dart';

import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/app_router/app_router.dart';
//import 'package:reelproject/component/finish_screen/finish_screen.dart';

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)

class Logout {
  factory Logout() => _shared;
  static final Logout _shared = Logout._sharedInstance();

  Logout._sharedInstance();

  OverScreenControl? controller;

  void show({
    // オーバーレイ表示動作
    required BuildContext context,
  }) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
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
  }) {
    final text0 = StreamController<String>();

    final state = Overlay.of(context);
    // final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        final store = Provider.of<ChangeGeneralCorporation>(context);

        // String buttonText = "ホーム画面に戻る";
        // if (store.rootIndex == 0) {
        //   buttonText = "ホーム画面に戻る";
        // } else if (store.rootIndex == 1) {
        //   buttonText = "イベント画面に戻る";
        // } else if (store.rootIndex == 2) {
        //   buttonText = "求人画面に戻る";
        // } else if (store.rootIndex == 3) {
        //   buttonText = "マイページ画面に戻る";
        // }
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
                width: 350,
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
                          "本当にログアウトしますか？",
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 20), //余白調整
                        ElevatedButton(
                          // ボタンを作る関数
                          //ボタン設置
                          onPressed: () {
                            // ボタンが押されたときの処理をここに追加予定
                            store.changeOverlay(false);

                            Logout().hide();
                            context.navigateTo(const LoginRoute());
                            //しょうえい
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(220, 60), //ボタンの大きさ
                            backgroundColor: store.mainColor,
                          ),
                          child: const Text(
                            "ログアウト", //Elevateの子供
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
                            Logout().hide();
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
