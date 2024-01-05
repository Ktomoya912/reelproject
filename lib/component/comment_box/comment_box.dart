import 'package:flutter/material.dart';

//使い方
//ファイルの上部でimport 'comentBox.dart';と置く
//その後、body内で"const ComentBox();"のように宣言
class CommentBox extends StatelessWidget {
  final double boxWidth;
  final double boxHeight;
  // final int lenMax;//保留
  // static int leax = 30;

  const CommentBox({
    super.key,
    required this.boxWidth,
    required this.boxHeight,
    // required this.lenMax,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 203, 202, 202), width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          maxLines: null,
          maxLength: 100,
          style: TextStyle(fontSize: 13),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'ここに入力',

            counterText: '', //maxLengthによる"0/100"の表示を消すための処理
          ),
        ),
      ),
    );
  }
}
