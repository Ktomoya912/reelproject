import 'dart:async';
import 'package:flutter/material.dart';
import '../over_screen_controller.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している
// 開発中の画面へ遷移した時に表示する画面

class NoScreen {
  factory NoScreen() => _shared;
  static final NoScreen _shared = NoScreen._sharedInstance();
  NoScreen._sharedInstance();
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
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
                height: 220,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly, // ここで子要素の配置を均等に設定します
                      //mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //空白
                        const SizedBox(height: 10),
                        const Text(
                          "申し訳ありませんが\nこの画面はβテスト段階では開発中になります。",
                          style: TextStyle(
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          //ボタン設置
                          onPressed: () {
                            store.changeOverlay(false);
                            NoScreen().hide();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(200, 45),
                            backgroundColor: store.greyColor,
                          ),
                          child: const Text("戻る",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
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
