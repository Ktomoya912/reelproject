import 'package:flutter/material.dart';
import 'package:reelproject/component/form/text_enter_box.dart';

//enabledは入力可能かどうかを判断する変数
//enabledがtrueなら入力可能、falseなら入力不可
//enabledをtextEnterBoxに渡すことで入力可能かどうかを判断する
//表示するのはユーザ名、メールアドレス、電話番号、住所、生年月日、性別
class CompanyForm extends StatefulWidget {
  final bool enable;
  const CompanyForm({super.key, required this.enable});

  @override
  CompanyFormState createState() => CompanyFormState();
}

class CompanyFormState extends State<CompanyForm> {
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
        const SizedBox(
          height: 50,
        ),
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
        TextEnterBox(
            label: '法人名', hinttext: '例：ChaO！株式会社', width: 300, enabled: enable),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        const TextEnterBox(
            label: 'ユーザー名', hinttext: '例：ChaO！株式会社', width: 300, enabled: true),
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
        const TextEnterBox(
            label: '電話番号',
            hinttext: '例：09012345678',
            width: 300,
            enabled: true),
        const Padding(
          padding: EdgeInsets.all(20.0),
        ),

        // ここから住所入力
        const SizedBox(
          width: 300,
          child: Text(
            '住所',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(5.0),
        ),
        const TextEnterBox(
            label: '郵便番号', hinttext: '例：1234567', width: 300, enabled: true),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        const TextEnterBox(
            label: '都道府県', hinttext: '例：高知県', width: 300, enabled: true),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        const TextEnterBox(
            label: '市区町村', hinttext: '例：高知市', width: 300, enabled: true),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        const TextEnterBox(
            label: '番地', hinttext: '例：1-1-1', width: 300, enabled: true),
        const Padding(
          padding: EdgeInsets.all(20.0),
        ),
        const SizedBox(
          width: 300,
          child: Text(
            '生年月日',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
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
