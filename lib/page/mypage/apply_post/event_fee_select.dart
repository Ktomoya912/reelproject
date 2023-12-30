import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:provider/provider.dart';
//import '/provider/change_general_corporation.dart';
//import "package:reelproject/component/button/SelectFeeButton.dart";

//イベント広告掲載プロバイダ
class EventApplyPostDetail with ChangeNotifier {
  String eventFee = ""; //掲載プラン
  //掲載プラン変更
  void changeEventFee(String feeTitle) {
    eventFee = feeTitle;
    notifyListeners();
  }
}

class EventFeeSelect extends StatefulWidget {
  const EventFeeSelect({super.key});

  @override
  State<EventFeeSelect> createState() => _EventFeeSelectState();
}

class _EventFeeSelectState extends State<EventFeeSelect> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    //final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    //横画面サイズにより幅設定
    double widthBlank = (mediaQueryData.size.width / 2) - 300;
    if (widthBlank < 0) {
      widthBlank = 0;
    }
    double width = mediaQueryData.size.width - (widthBlank * 2);

    double height = mediaQueryData.size.height * 0.75;
    if (height < 500) {
      height = 500;
    }

    return ChangeNotifierProvider(
        create: (context) => EventApplyPostDetail(),
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: const TitleAppBar(
              title: "イベント掲載料金プラン",
              jedgeBuck: true,
            ),
            body: SingleChildScrollView(
                child: Center(
              child: SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //SizedBox(height: width / 20), //空白
                    SelectFeeButton(
                      width: width,
                      title: "1回の掲載料金",
                      titleColor: Colors.blue,
                      textWidget: const Text('30,000円',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ),
                    //SizedBox(height: width / 10), //空白
                    SelectFeeButton(
                      width: width,
                      title: "イベント+求人広告掲載プラン",
                      titleColor: Colors.green[300]!,
                      textWidget: const Column(
                        children: [
                          Text('+ 20,000円',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          Text('で3か月求人掲載可能',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('合計',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 10), //空白
                              Text('50,000',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline, //下線
                                      decorationColor: Colors.lightGreen, //下線色
                                      decorationThickness: 4 // 下線の太さの設定
                                      )),
                              Text('円',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        }));
  }
}

class SelectFeeButton extends StatelessWidget {
  const SelectFeeButton({
    super.key,
    required this.width,
    required this.title,
    required this.titleColor,
    required this.textWidget,
  });

  final double width;
  //タイトル
  final String title;
  final Color titleColor;
  //下文字
  final Widget textWidget;

  @override
  Widget build(BuildContext context) {
    final eventStore = Provider.of<EventApplyPostDetail>(context); //プロバイダ
    //final jobStore = Provider.of<JobApplyPostDetail>(context); //プロバイダ
    return InkWell(
      onTap: () => {
        eventStore.changeEventFee(title),
      },
      child:
          //内部
          Column(
        children: [
          Container(
            //padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomCenter, //下ぞろえ
            //影
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, //色
                  //spreadRadius: 5,//拡散
                  blurRadius: 5, //ぼかし
                  offset: Offset(3, 3), //影の位置
                ),
              ],
              color: Colors.white,
            ),
            width: width * 0.7,
            //height: width * 0.7 / 2.5,
            child: Column(
              children: [
                //上枠
                Container(
                  width: width * 0.7,
                  height: width * 0.7 / 10,
                  color: titleColor,
                  child: Center(
                    child: Text(title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                //下文字
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: textWidget,
                ),
                Container(
                  width: width * 0.7 * 0.55,
                  height: width * 0.7 / 3 * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: titleColor,
                  ),
                  child: const Center(
                    child: Text("このプランで進める",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                SizedBox(height: width / 40), //空白
              ],
            ),
          ),
        ],
      ),
    );
  }
}
