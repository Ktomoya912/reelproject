import 'dart:async';

import 'package:flutter/material.dart';

import '../over_screen_controller.dart';

import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/page/mypage/apply_post/event_fee_select.dart';
import 'package:reelproject/page/mypage/apply_post/job_fee_select.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:reelproject/app_router/app_router.dart';
//import 'package:reelproject/component/finish_screen/finish_screen.dart';

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)

class SelectPost {
  factory SelectPost() => _shared;
  static final SelectPost _shared = SelectPost._sharedInstance();

  SelectPost._sharedInstance();

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
        //final store = Provider.of<ChangeGeneralCorporation>(context);

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
                height: 400,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(child: ToggleRadio()),
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

enum City {
  event('イベント'),
  job('求人');

  final String displayName;
  const City(this.displayName);
}

class ToggleRadio extends StatefulWidget {
  const ToggleRadio({
    super.key,
  });

  @override
  ToggleRadioState createState() => ToggleRadioState();
}

class ToggleRadioState extends State<ToggleRadio> {
  City? _city = City.event; //初期値
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //ウィジェットを保管
        const Text(
          "投稿する",
          style: TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        const SizedBox(height: 20), //余白調整
        const Text(
          "どちらを投稿しますか？",
          style: TextStyle(
              //fontWeight: FontWeight.bold
              fontSize: 18),
        ),
        const SizedBox(height: 20), //余白調整
        SizedBox(
          width: 200,
          height: 40,
          child: ListTile(
            title: Text(City.event.displayName),
            leading: Radio<City>(
              value: City.event,
              groupValue: _city,
              onChanged: (City? value) {
                setState(() {
                  _city = value;
                });
              },
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: ListTile(
            title: Text(City.job.displayName),
            leading: Radio<City>(
              value: City.job,
              groupValue: _city,
              onChanged: (City? value) {
                setState(() {
                  _city = value;
                });
              },
            ),
          ),
        ),
//ラジオボタン　end
        const SizedBox(height: 20), //余白調整
        ElevatedButton(
          // ボタンを作る関数
          //ボタン設置
          onPressed: () {
            // if () {
            //   store.changeOverlay(false);
            //   SelectPost().hide();

            //   //消す作業記述
            //   //
            // }
            // ボタンが押されたときの処理をここに追加予定
            if (_city == City.event) {
              store.changeOverlay(false);
              SelectPost().hide();
              //イベントプラン選択画面移動
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EventFeeSelect()),
              );
            } else {
              store.changeOverlay(false);
              SelectPost().hide();
              //求人プラン選択画面移動
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const JobFeeSelect()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minimumSize: const Size(240, 60), //ボタンの大きさ
            backgroundColor: store.mainColor,
          ),
          child: const Text(
            "投稿する", //Elevateの子供
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
            SelectPost().hide();
            store.changeOverlay(false);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minimumSize: const Size(240, 60),
            backgroundColor: Colors.grey[400],
          ),
          child: const Text("キャンセル", //Elevateの子供
              style: TextStyle(
                  color: Colors.white,
                  //fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
      ], //
    );
  }
}
