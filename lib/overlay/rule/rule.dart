import 'package:flutter/material.dart';
import 'screen/rule_screen.dart'; //オーバレイで表示される画面のファイル
// import 'package:flutter/material.dart';

// 使わない

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '利用規約を確認してください',
            ),
            const SizedBox(
              height: 50,
            ),
            OutlinedButton(
              //ボタン設置
              onPressed: () {
                // ボタンが押されたときの処理をここに追加予定
                RuleScreen().show(
                  //これでおーばーれい表示
                  context: context,
                );
              },

              style: OutlinedButton.styleFrom(
                //下線付きボタンにするためoutlinedbuttonにしている
                side: BorderSide.none, //ここで周りの線を消している
              ),
              child: const Text("利用規約",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 0, 0),
                    decoration: TextDecoration.underline,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
