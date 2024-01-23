import 'dart:async';
import 'package:flutter/material.dart';
import '../over_screen_controller.dart';
// import 'package:reelproject/provider/change_general_corporation.dart';
// import 'package:provider/provider.dart'; //パッケージをインポート

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している
// 画像挿入時に表示されるその画像を設定するかを問うオーバーレイ

class ImageOver {
  factory ImageOver() => _shared;
  static final ImageOver _shared = ImageOver._sharedInstance();
  ImageOver._sharedInstance();
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
        // final store = Provider.of<ChangeGeneralCorporation>(context);
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
                          "選択した画像に設定しますか？",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "設定後も変更は可能です",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: 280,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                //ボタン設置
                                onPressed: () {
                                  // store.changeOverlay(false);
                                  bool judgeImage = false;
                                  onInputChanged
                                      ?.call(judgeImage); // 呼び出し元へ反応さえるための要素
                                  ImageOver().hide();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(125, 45),
                                  // backgroundColor: store.greyColor,
                                ),
                                child: const Text("キャンセル",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                //ボタン設置
                                onPressed: () {
                                  // store.changeOverlay(false);
                                  bool judgeImage = true;
                                  onInputChanged
                                      ?.call(judgeImage); // 呼び出し元へ反応さえるための要素
                                  ImageOver().hide();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(125, 45),
                                  // backgroundColor: store.greyColor,
                                  backgroundColor:
                                      const Color.fromARGB(255, 143, 205, 255),
                                ),
                                child: const Text("設定",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13)),
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
