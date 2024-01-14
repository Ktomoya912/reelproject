import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
//flutter pub add loading_animation_widgetを実行してインストールする

Future<void> showLoadingDialog({
  required BuildContext context,
}) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: false, // ダイアログ外をタップしても閉じない
      transitionDuration: const Duration(milliseconds: 250),
      barrierColor: Colors.black.withOpacity(0.5), // 画面マスクの透明度
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoadingAnimationWidget.waveDots(
                // ここでアニメーションを指定
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      });
}
