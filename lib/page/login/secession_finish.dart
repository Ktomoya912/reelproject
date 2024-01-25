import 'package:flutter/material.dart';
import 'package:reelproject/app_router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';

@RoutePage()
class SecessionFinish extends StatefulWidget {
  const SecessionFinish({super.key});
  @override
  SecessionFinishState createState() => SecessionFinishState();
}

class SecessionFinishState extends State<SecessionFinish> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const TitleAppBar(
        title: "退会完了",
        jedgeBuck: false,
      ),
      body: Container(
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Icon(Icons.done,
                    size: 180, color: Color.fromARGB(255, 137, 137, 137)),
                const Text(
                  "退会完了",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 300,
                  height: 270,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 203, 202, 202),
                        width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 15),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          "REEL会員退会手続き完了のメールを送信いたしましたので、\n内容をご確認ください。\nご利用ありがとうございました。\n \nまたの機会のご利用をお待ちしております。",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 134, 134, 134)),
                        ),
                      ),
                      const ButtonSet(buttonName: "ログイン画面に戻る"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // questionButtonWidget,
                //空白
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
    );
  }
}

class ButtonSet extends StatelessWidget {
  final String buttonName;

  const ButtonSet({
    super.key,
    required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    return ElevatedButton(
      onPressed: () {
        //最初の画面まで戻る
        context.navigateTo(const LoginRoute());
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(130, 40),
        backgroundColor: store.mainColor,
      ),
      child: Text(buttonName, style: const TextStyle(color: Colors.white)),
    );
  }
}
