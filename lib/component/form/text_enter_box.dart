import 'package:flutter/material.dart';

class TextEnterBox extends StatelessWidget {
  //入力を生成するコード
  //labelは入力する項目の名前、hinttextは入力する項目の例
  //widthは入力する項目の幅、enabledは入力可能かどうかを判断する変数
  final String? label;
  final String? hinttext;
  final double width;
  final bool enabled;
  const TextEnterBox({
    required this.label,
    required this.hinttext,
    required this.width,
    required this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        enabled: enabled,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: !enabled ? '$labelは編集できません ' : label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          hintText: hinttext,
        ),
      ),
    );
  }
}
