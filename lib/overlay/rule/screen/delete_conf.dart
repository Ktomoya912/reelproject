import 'dart:async';
import 'package:flutter/material.dart';
import '../over_screen_controller.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)
class DeleteConf {
  factory DeleteConf() => _shared;
  static final DeleteConf _shared = DeleteConf._sharedInstance();

  DeleteConf._sharedInstance();

  OverScreenControl? controller;
  //追加1　start

  late bool enable; //
  String? selectedGender; //
  //追加1 end

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
                // constraints: BoxConstraints(
                //   maxWidth: size.width * 0.7,
                //   maxHeight: size.height * 1.5,
                //   minWidth: size.width * 0.2,
                // ),
                height: 350,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //ウィジェットを保管
                        Text(
                          "投稿を削除しますか？",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 20), //余白調整
                        Text(
                          "投稿を削除しても投稿料金は返金されません。\n 本当に削除しますか？",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11.5),
                        ),
                        const SizedBox(height: 20), //余白調整
//ラジオボタン start
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                                value: 'agree',
                                groupValue: selectedGender,
                                onChanged: (value) {}),
                            const Text('同意する',
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                            ),
                          ],
                        ),
//ラジオボタン　end
                        const SizedBox(height: 20), //余白調整
                        ElevatedButton(
                          // ボタンを作る関数
                          //ボタン設置
                          onPressed: () {
                            // ボタンが押されたときの処理をここに追加予定
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(240, 60), //ボタンの大きさ
                            backgroundColor: store.mainColor,
                          ),
                          child: const Text(
                            "削除する", //Elevateの子供
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20), //余白調整
                        ElevatedButton(
                          // ボタンを作る関数
                          //ボタン設置
                          onPressed: () {
                            // ボタンが押されたときの処理をここに追加予定
                            DeleteConf().hide();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(240, 60),
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text("キャンセル", //Elevateの子供
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      ], //
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
