import 'package:flutter/material.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';

class JobFeeWatch extends StatefulWidget {
  const JobFeeWatch({
    super.key,
    required this.planId,
    required this.planPeriod,
    required this.eventJobJedge,
    required this.botommBarJedge,
  });

  final int planId;
  final int planPeriod;
  final bool eventJobJedge; //イベント:True,求人:False
  final bool botommBarJedge;

  @override
  State<JobFeeWatch> createState() => _JobFeeWatchState();
}

class _JobFeeWatchState extends State<JobFeeWatch> {
  Map<String, dynamic> plan = {
    "name": "string",
    "price": 3,
    "period": 30,
    "id": 1
  };

  void changePlan(dynamic e) {
    setState(() {
      for (int i = 0; i < e.length; i++) {
        if (e[i]["id"] == widget.planId) {
          plan = e[i];
        }
      }
    });
  }

  Future getPlan() async {
    Uri url = Uri.parse('${ChangeGeneralCorporation.apiUrl}/plans');
    final response =
        await http.get(url, headers: {'accept': 'application/json'});
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changePlan(json.decode(data));
    } else {
      throw Exception("Failed");
    }
  }

  @override
  void initState() {
    getPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return Scaffold(
        appBar: TitleAppBar(
          title: widget.eventJobJedge ? "イベント掲載料金プラン" : "求人掲載料金プラン",
          jedgeBuck: widget.botommBarJedge ? false : true,
        ),
        bottomNavigationBar:
            widget.botommBarJedge ? const NormalBottomAppBar() : null,
        body: SizedBox(
          height: mediaQueryData.size.height,
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                height: 700,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //空白
                    const SizedBox(height: 20), //余白調整
                    const Text(
                      "金額をご確認ください",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //空白
                    const SizedBox(height: 20), //余白調整
                    //内部
                    //プラン基本料金
                    Column(
                      children: [
                        Container(
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
                          width: 350,
                          height: 100,
                          //height: width * 0.7 / 2.5,
                          child: Column(
                            children: [
                              //上枠
                              Container(
                                width: 350,
                                height: 30,
                                color: Colors.blue,
                                child: const Center(
                                  child: Text("プラン基本料金",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ),
                              ),
                              //下文字
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text("${plan["price"]}円", //プラン基本料金
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!widget.eventJobJedge || widget.planId == 2)
                      const Text(
                        "×",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 102, 102, 102)),
                      ),
                    //合計金額
                    if (!widget.eventJobJedge || widget.planId == 2)
                      Column(
                        children: [
                          Container(
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
                            width: 350,
                            height: 100,
                            //height: width * 0.7 / 2.5,
                            child: Column(
                              children: [
                                //上枠
                                Container(
                                  width: 350,
                                  height: 30,
                                  color:
                                      const Color.fromARGB(255, 11, 198, 179),
                                  child: Center(
                                    child: Text(
                                        widget.planId != 5 ? "契約希望月" : "契約希望年",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ),
                                ),
                                //下文字
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text("${widget.planPeriod}ヶ月", //契約希望月
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox(
                        height: 100,
                      ),
                    if (!widget.eventJobJedge || widget.planId == 2)
                      Transform.rotate(
                        angle: -3.14 / 2,
                        child: const Text(
                          "＝",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 102, 102, 102)),
                        ),
                      ),
                    //プラン基本料金
                    if (!widget.eventJobJedge || widget.planId == 2)
                      Column(
                        children: [
                          Container(
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
                            width: 350,
                            height: 100,
                            //height: width * 0.7 / 2.5,
                            child: Column(
                              children: [
                                //上枠
                                Container(
                                  width: 350,
                                  height: 30,
                                  color: const Color.fromARGB(255, 235, 168, 13),
                                  child: const Center(
                                    child: Text("合計金額",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ),
                                ),
                                //下文字
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                      "${plan["price"] * widget.planPeriod}円", //合計金額
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox(
                        height: 100,
                      ),
                    //空白
                    const SizedBox(height: 20), //余白調整
                    const Text("※7日以内に指定の銀行口座に振込をお願いします。\n振込を確認次第投稿させていただきます。",
                        style:
                            TextStyle(color: Color.fromARGB(255, 226, 43, 30))),
                    //空白
                    const SizedBox(height: 20), //余白調整
                    const Text("振込先口座は、\nマイページの「振込口座確認」からご確認ください。"),
                    //空白
                    const SizedBox(height: 20), //余白調整
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(store.mainColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // ここで角の丸さを設定します
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 50)), // ここでボタンの大きさを設定します
                      ),
                      onPressed: () {
                        //pop
                        Navigator.of(context).pop();
                      },
                      child: const Text("プラン選択に戻る"),
                    ),

                    //空白
                    const SizedBox(height: 20), //余白調整
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
