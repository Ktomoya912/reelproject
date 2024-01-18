import 'dart:async';

import 'package:flutter/material.dart';

import '../over_screen_controller.dart';

import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/component/rule_screen/general_rule_screen.dart';
import 'package:reelproject/component/rule_screen/company_rule_screen.dart';

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)

class RuleScreen {
  factory RuleScreen() => _shared;
  static final RuleScreen _shared = RuleScreen._sharedInstance();

  RuleScreen._sharedInstance();

  OverScreenControl? controller;

  //一般向け利用規約
  final String ruleGeneral = generalRuleScreenText;
//企業向け利用規約
  final String ruleCompany = companyRuleScreenText;

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
                height: 600,
                width: 350,
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
                        const SizedBox(height: 20),
                        const Text(
                          "利用規約",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        //-------利用規約（現在はtextのみ）を表示している部分------------
                        Container(
                          height: 400,
                          width: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 203, 202, 202),
                                width: 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (store.jedgeGC)
                                  Text(ruleGeneral)
                                else
                                  Text(ruleCompany)
                              ],
                            ),
                          ),
                        ),
                        //-----------------------------------------------------------
                        const SizedBox(height: 30),
                        ElevatedButton(
                          //ボタン設置
                          onPressed: () {
                            store.changeOverlay(false);
                            // ボタンが押されたときの処理をここに追加予定
                            RuleScreen().hide();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(130, 40),
                            backgroundColor: store.mainColor,
                          ),
                          child: const Text("閉じる",
                              style: TextStyle(color: Colors.white)),
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
