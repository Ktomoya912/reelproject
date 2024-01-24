import 'dart:async';

import 'package:flutter/material.dart';

import '../over_screen_controller.dart';

import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:http/http.dart';

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)

class NoticeDelete {
  factory NoticeDelete() => _shared;
  static final NoticeDelete _shared = NoticeDelete._sharedInstance();

  NoticeDelete._sharedInstance();

  OverScreenControl? controller;

  //投稿削除
  Future deletePost(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/notices/$id/read');
    final response = await post(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
  }

  void show({
    // オーバーレイ表示動作
    required BuildContext context,
    required int id,
  }) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        id: id,
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
    required int id,
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
                height: 290,
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
                        //空白
                        const SizedBox(height: 20), //余白調整
                        //ウィジェットを保管
                        const Text(
                          "本当に削除しますか？",
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        const SizedBox(height: 40), //余白調整
                        ElevatedButton(
                          // ボタンを作る関数
                          //ボタン設置
                          onPressed: () {
                            deletePost(id, store);
                            store.changeOverlay(false);
                            //Navigator.pop(context);
                            //Navigator.pop(context);
                            NoticeDelete().hide();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FinishScreen(
                                  appbarText: "通知削除完了",
                                  appIcon: Icons.playlist_add_check,
                                  finishText: "通知の削除を完了しました",
                                  text:
                                      "対象通知の削除を完了いたしました。\n削除した通知は元に戻すことができませんのでご注意ください。",
                                  buttonText:
                                      "通知一覧に戻る", // 今は既存のfinish_screenをつかっているのでログイン画面に戻ってしまうが後に変更予定
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
                            "削除する", //Elevateの子供
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
                            // ボタンが押されたときの処理をここに追加予定
                            store.changeOverlay(false);
                            NoticeDelete().hide();
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
