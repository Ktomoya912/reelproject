import 'dart:async';
import 'package:flutter/material.dart';
import '../over_screen_controller.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart'; //パッケージをインポート
import 'package:reelproject/component/finish_screen/finish_screen.dart';
import 'package:http/http.dart';

// オーバーレイによって表示される画面である
// controllerによってこの画面の表示、閉じるを制御している(rule_screen_controller.dart)
class DeleteConf {
  factory DeleteConf() => _shared;
  static final DeleteConf _shared = DeleteConf._sharedInstance();

  DeleteConf._sharedInstance();

  OverScreenControl? controller;
  //追加1　start

  late bool enable; //enabledは入力可能かどうかを判断する変数
  //追加1 end

  //投稿削除
  Future deletePost(
      int id, ChangeGeneralCorporation store, String eventJobJedge) async {
    Uri url =
        Uri.parse('${ChangeGeneralCorporation.apiUrl}/${eventJobJedge}s/$id');
    final response = await delete(url, headers: {
      'accept': 'application/json',
      //'Authorization': 'Bearer ${store.accessToken}'
      'authorization': 'Bearer ${store.accessToken}'
    });
  }

  void show({
    // オーバーレイ表示動作
    required BuildContext context,
    required int id,
    required String eventJobJedge,
  }) {
    if (controller?.update() ?? false) {
      return;
    } else {
      controller = showOverlay(
        context: context,
        id: id,
        eventJobJedge: eventJobJedge,
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
    required String eventJobJedge,
  }) {
    final text0 = StreamController<String>();

    final state = Overlay.of(context);
    // final renderBox = context.findRenderObject() as RenderBox;
    // final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
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
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: ToggleRadio(id: id, eventJobJedge: eventJobJedge),
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

class ToggleRadio extends StatefulWidget {
  const ToggleRadio({
    super.key,
    required this.id,
    required this.eventJobJedge,
  });

  final int id;
  final String eventJobJedge;

  @override
  ToggleRadioState createState() => ToggleRadioState();
}

class ToggleRadioState extends State<ToggleRadio> {
  bool flag = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //ウィジェットを保管
        const Text(
          "投稿を削除しますか？",
          style: TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        const SizedBox(height: 20), //余白調整
        const Text(
          "投稿を削除しても投稿料金は返金されません。\n 本当に削除しますか？",
          style: TextStyle(
              //fontWeight: FontWeight.bold
              fontSize: 11.5),
        ),
        const SizedBox(height: 20), //余白調整
//ラジオボタン start
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: flag,
              onChanged: (bool? value) {
                setState(() {
                  flag = value ?? false;
                });
              },
            ),
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
            if (flag) {
              DeleteConf().deletePost(widget.id, store, widget.eventJobJedge);
              store.changeOverlay(false);
              Navigator.pop(context);
              //Navigator.pop(context);
              DeleteConf().hide();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FinishScreen(
                    appbarText: "投稿削除確認",
                    appIcon: Icons.playlist_add_check,
                    finishText: "投稿削除完了",
                    text:
                        "広告投稿の削除を完了いたしましたので、振込料金の支払いは不要となります。また、投稿削除に関するお問い合わせがありましたら下記のお問い合わせフォームからお問い合わせをして頂きますと幸いです。またの広告投稿をお待ちしております。",
                    buttonText:
                        buttonText, // 今は既存のfinish_screenをつかっているのでログイン画面に戻ってしまうが後に変更予定
                    jedgeBottomAppBar: false,
                    popTimes: 2,
                  ),
                ),
              );
              //消す作業記述
              //
            }
            // ボタンが押されたときの処理をここに追加予定
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minimumSize: const Size(240, 60), //ボタンの大きさ
            backgroundColor: flag == true ? store.mainColor : Colors.grey[400],
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
            DeleteConf().hide();
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
    // Checkbox(
    //   value: flag,
    //   onChanged: (bool? value) {
    //     setState(() {
    //       flag = value ?? false;
    //     });
    //   },
    // );
  }
}
