import 'package:flutter/material.dart';
import 'package:reelproject/component/form/text_enter_box.dart';

//enabledは入力可能かどうかを判断する変数
//enabledがtrueなら入力可能、falseなら入力不可
//enabledをtextEnterBoxに渡すことで入力可能かどうかを判断する
//表示するのはユーザ名、メールアドレス、電話番号、住所、生年月日、性別
class GeneralForm extends StatefulWidget {
  final bool enable;
  const GeneralForm({super.key, required this.enable});

  @override
  GeneralFormState createState() => GeneralFormState();
}

class GeneralFormState extends State<GeneralForm> {
  late bool enable;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    enable = widget.enable;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          '以下に必要事項をご記入ください。',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
        ),
        const TextEnterBox(
            label: 'ユーザー名', hinttext: '英数字と_のみ使用可', width: 300, enabled: true),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        TextEnterBox(
            label: 'メールアドレス',
            hinttext: '例：info@example.com',
            width: 300,
            enabled: enable),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        const SizedBox(
          width: 300,
          child: Text(
            '生年月日',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
        ),
        const SizedBox(
          width: 300,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextEnterBox(
                    label: '西暦', hinttext: '', width: 100, enabled: true),
                Text('年', style: TextStyle(fontSize: 15)),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                TextEnterBox(label: '', hinttext: '', width: 50, enabled: true),
                Text('月', style: TextStyle(fontSize: 15)),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                TextEnterBox(label: '', hinttext: '', width: 50, enabled: true),
                Text('日', style: TextStyle(fontSize: 15)),
              ]),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
        ),
        const SizedBox(
          width: 300,
        ),
        const SizedBox(
          width: 300,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: 'male',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const Text('男性',
                style: TextStyle(
                  fontSize: 15,
                )),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Radio(
              value: 'female',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const Text('女性',
                style: TextStyle(
                  fontSize: 15,
                )),
            const Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Radio(
              value: 'other',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
            const Text('その他',
                style: TextStyle(
                  fontSize: 15,
                )),
          ],
        ),
      ],
    );
  }
}
