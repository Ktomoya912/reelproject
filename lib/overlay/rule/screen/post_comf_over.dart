import 'dart:async';
import 'package:flutter/material.dart';
import '../over_screen_controller.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
// import 'package:reelproject/provider/change_general_corporation.dart';
// import 'package:provider/provider.dart'; //パッケージをインポート

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している
// 画像挿入時に表示されるその画像を設定するかを問うオーバーレイ

class PostComfOver {
  factory PostComfOver() => _shared;
  static final PostComfOver _shared = PostComfOver._sharedInstance();
  PostComfOver._sharedInstance();
  OverScreenControl? controller;
  void show({
    // オーバーレイ表示動作
    required BuildContext context,
    Function(bool)? onInputChanged, // 呼び出し元へ反応さえるための要素
  }) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
          context: context, onInputChanged: onInputChanged // 呼び出し元へ反応さえるための要素
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
    Function(bool)? onInputChanged, // 呼び出し元へ反応さえるための要素
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
                height: 240,
                width: 310,
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
                          "この内容で投稿しますか？",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 280,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                //ボタン設置
                                onPressed: () {
                                  // store.changeOverlay(false);
                                  bool judgeImage = true;
                                  onInputChanged
                                      ?.call(judgeImage); // 呼び出し元へ反応さえるための要素
                                  PostComfOver().hide();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(200, 60),
                                  // backgroundColor: store.greyColor,
                                  backgroundColor: store.mainColor, //一般・法人色変更
                                ),
                                child: const Text("投稿する",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                //ボタン設置
                                onPressed: () {
                                  // store.changeOverlay(false);
                                  bool judgeImage = false;
                                  onInputChanged
                                      ?.call(judgeImage); // 呼び出し元へ反応さえるための要素
                                  PostComfOver().hide();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(200, 60),
                                  // backgroundColor: store.greyColor,
                                ),
                                child: const Text("戻る",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                            ],
                          ),
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
