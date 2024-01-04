import 'package:flutter/material.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:provider/provider.dart';
//import '/provider/change_general_corporation.dart';
//import "package:reelproject/component/button/SelectFeeButton.dart";
import 'package:reelproject/component/listView/shader_mask_component.dart';

//イベント広告掲載プロバイダ
class JobApplyPostDetail with ChangeNotifier {
  String jobFee = ""; //掲載プラン
  //掲載プラン変更
  void changeJobFee(String feeTitle) {
    jobFee = feeTitle;
    notifyListeners();
  }

  //掲載期間
  int jobPeriod = 1;
  //掲載期間変更
  void changeJobPeriod(int period) {
    jobPeriod = period;
    notifyListeners();
  }
}

class JobFeeSelect extends StatefulWidget {
  const JobFeeSelect({super.key});

  @override
  State<JobFeeSelect> createState() => _JobFeeSelectState();
}

class _JobFeeSelectState extends State<JobFeeSelect> {
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
        create: (context) => JobApplyPostDetail(),
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: const TitleAppBar(
              title: "求人掲載料金プラン",
              jedgeBuck: true,
            ),
            body: ShaderMaskComponent(
              child: SingleChildScrollView(
                  child: Center(
                child: SizedBox(
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //SizedBox(height: width / 20), //空白
                      SelectFeeButton(
                        width: width,
                        title: "1か月掲載契約",
                        titleColor: Colors.blue,
                        textWidget: const Text(
                          '20,000円/月',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      //SizedBox(height: width / 20), //空白
                      SelectFeeButton(
                        width: width,
                        title: "半年以上掲載契約",
                        titleColor: const Color.fromARGB(255, 129, 199, 193),
                        textWidget: const Text('19,000円/月',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                      //SizedBox(height: width / 20), //空白
                      SelectFeeButton(
                        width: width,
                        title: "1年掲載契約",
                        titleColor: Colors.green[300]!,
                        textWidget: const Text('200,000円/年',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
        }));
  }
}

class SelectFeeButton extends StatefulWidget {
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
  State<SelectFeeButton> createState() => _SelectFeeButtonState();
}

class _SelectFeeButtonState extends State<SelectFeeButton> {
  @override
  Widget build(BuildContext context) {
    //final eventStore = Provider.of<EventApplyPostDetail>(context); //プロバイダ
    final jobStore = Provider.of<JobApplyPostDetail>(context); //プロバイダ

    return InkWell(
      onTap: () => {
        //print(jobStore.jobPeriod),
        jobStore.changeJobFee(widget.title), //プロバイダ変更
        //１か月以上、半年以上契約の場合
        if (widget.title != "1年掲載契約")
          {
            //jobPireod変更
            if (widget.title == "1か月掲載契約")
              {
                jobStore.changeJobPeriod(1),
              }
            else
              {
                jobStore.changeJobPeriod(6),
              },
            //ポップアップ
            showDialog(
              context: context,
              builder: (BuildContext context) {
                //ダイアログ表示
                return AlertDialog(
                  content: SizedBox(
                    width: widget.width * 0.5,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "掲載する期間を選択してください",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) =>
                                  DropdownButton(
                            value: jobStore.jobPeriod,
                            onChanged: (int? value) {
                              setState(() {
                                jobStore.changeJobPeriod(value!);
                              });
                            },
                            items: [
                              if (widget.title == "1か月掲載契約")
                                for (int i = 1; i <= 12; i++)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text('$iか月'),
                                  )
                              else
                                for (int i = 6; i <= 12; i++)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text('$iか月'),
                                  )
                            ],
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                            ),
                            onPressed: () {
                              //Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('プラン確認'),
                                    content: const Text('本当にこのプランで進めますか？'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('進める'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          //Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('キャンセル'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                                width: widget.width * 0.7 * 0.35,
                                height: widget.width * 0.7 / 3 * 0.3,
                                child: const Center(child: Text("確定")))),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                                width: widget.width * 0.7 * 0.35,
                                height: widget.width * 0.7 / 3 * 0.3,
                                child: const Center(child: Text("キャンセル")))),
                      ],
                    ),
                  ),
                );
              },
            ).then((value) => setState(() {})),
          }
        else
          {
            jobStore.changeJobPeriod(12),
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('プラン確認'),
                  content: const Text('本当にこのプランで進めますか？'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('進める'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('キャンセル'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            )
          }
        //ダイアログ表示
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
            width: widget.width * 0.7,
            //height: width * 0.7 / 2.5,
            child: Column(
              children: [
                //上枠
                Container(
                  width: widget.width * 0.7,
                  height: widget.width * 0.7 / 10,
                  color: widget.titleColor,
                  child: Center(
                    child: Text(widget.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                //下文字
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.textWidget,
                ),
                Container(
                  width: widget.width * 0.7 * 0.55,
                  height: widget.width * 0.7 / 3 * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: widget.titleColor,
                  ),
                  child: const Center(
                    child: Text("このプランで進める",
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                SizedBox(height: widget.width / 40), //空白
              ],
            ),
          ),
        ],
      ),
    );
  }
}
