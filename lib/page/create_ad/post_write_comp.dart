import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:reelproject/component/bottom_appbar/normal_bottom_appbar.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import '/provider/change_general_corporation.dart';

// XFile?は？がつくことでnull許容型にしている

class PostWriteComp extends StatefulWidget {
  const PostWriteComp({
    super.key,
    required this.jobList,
    required this.image,
  });

  final Map<String, dynamic> jobList;
  final XFile? image;

  @override
  State<PostWriteComp> createState() => _PostWriteCompState();
}

class _PostWriteCompState extends State<PostWriteComp> {
  late Map<String, dynamic> jobDetailList;
  late XFile? image;

  @override
  void initState() {
    super.initState();
    jobDetailList = widget.jobList;
    image = widget.image;
  }

  bool favoriteJedge = false; //お気に入り判定
  String termText = "";

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context);

    //短期or長期の色
    MaterialColor termColor = Colors.green;
    if (jobDetailList["is_one_day"]) {
      termColor = Colors.lightGreen;
      termText = "短期";
    } else {
      termColor = Colors.yellow;
      termText = "長期";
    }

    //横画面サイズにより幅設定
    double widthBlank = (mediaQueryData.size.width / 2) - 300;
    if (widthBlank < 0) {
      widthBlank = 0;
    }
    //double blank = mediaQueryData.size.width / 20;
    double width = mediaQueryData.size.width - (widthBlank * 2);
    // final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(
      //アップバー
      // appBar: DetailAppbar(
      //   postJedge: jobDetailList["postJedge"],
      //   eventJobJedge: "job",
      //   postTerm: jobDetailList["postTerm"],
      //   mediaQueryData: mediaQueryData,
      // ),
      //body
      appBar: const TitleAppBar(
        title: "広告完成図確認",
        jedgeBuck: true,
      ),
      bottomNavigationBar: const NormalBottomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: width + widthBlank / 10,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Color.fromARGB(255, 207, 207, 207),
                  width: 2,
                ),
                left: BorderSide(
                  color: Color.fromARGB(255, 207, 207, 207),
                  width: 2,
                ),
              ), // 枠線の幅を設定
            ),
            child: Center(
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    //上の空間

                    //画像
                    Stack(children: [
                      jobDetailList["image_url"].toString() !=
                              "NO" // imageが入っているかの判定
                          ? SizedBox(
                              height: width * 0.6,
                              width: width,
                              child: ClipRRect(
                                // これを追加
                                borderRadius:
                                    BorderRadius.circular(10), // これを追加
                                child: Image.network(
                                    jobDetailList["image_url"].toString(),
                                    fit: BoxFit.cover),
                              ))
                          : Container(
                              // nullである(偽)
                              alignment: Alignment.topRight,
                              height: width * 0.6,
                              //width: width,
                              color: Colors.blue,
                            ),
                    ]),
                    //タイトル
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //タイトル
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            jobDetailList["name"],
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        //お気に入りボタン
                        Row(
                          children: [
                            ToggleButtons(
                              borderWidth: 0.01, // 枠線をなくす
                              color: Colors.grey[500], //選択していない時の色
                              selectedColor: store.mainColor, //選択時の色
                              fillColor: Colors.white, //選択時の背景色
                              splashColor: store.mainColor, //選択時のアクションの色
                              borderRadius: BorderRadius.circular(50.0), //角丸
                              isSelected: [favoriteJedge], //on off
                              //ボタンを押した時の処理
                              onPressed: (int index) => setState(() {
                                favoriteJedge = !favoriteJedge;
                              }),
                              //アイコン
                              children: <Widget>[
                                favoriteJedge
                                    ? const Icon(Icons.favorite, size: 40)
                                    : const Icon(Icons.favorite_border,
                                        size: 40),
                              ],
                            ),
                            //空白
                            SizedBox(
                              width: width / 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                    //ハッシュタグ
                    if (jobDetailList["tags"].length != 0)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: width, // 最小幅をwidthに設定
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0;
                                  i < jobDetailList["tags"].length;
                                  i++)
                                TextButton(
                                    onPressed: () => {},
                                    child: Text(
                                        "#${jobDetailList["tags"][i]["name"]}")),
                            ],
                          ),
                        ),
                      ),

                    //空白
                    SizedBox(
                      height: mediaQueryData.size.height / 200,
                    ),

                    //イベント詳細
                    SizedBox(
                      width: width - 20,
                      child: Text(jobDetailList["description"]),
                    ),

                    //空白
                    SizedBox(
                      height: mediaQueryData.size.height / 50,
                    ),

                    //勤務期間
                    SizedBox(
                      width: width - 20,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                        children: [
                          Row(
                            children: [
                              const Text(
                                "勤務期間",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: width / 30,
                              ),
                              //短期or長期
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: termColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(termText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          //空白
                          SizedBox(
                            height: mediaQueryData.size.height / 100,
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            children: [
                              for (int i = 0;
                                  i < jobDetailList["job_times"].length;
                                  i++)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // 子ウィジェットを左詰めに配置
                                  children: [
                                    //時間
                                    //短期の場合
                                    // if (jobDetailList["term"] == "短期")
                                    //   Text(jobDetailList["day"][i] +
                                    //       "   " +
                                    //       jobDetailList["time"][i])
                                    // //長期の場合
                                    // else if (jobDetailList["term"] == "長期")
                                    //   Text(jobDetailList["time"][i]),
                                    Text(jobDetailList["job_times"][i]
                                        ["start_time"]),
                                  ],
                                ),
                            ],
                          )
                        ],
                      ),
                    ),

                    //空白
                    SizedBox(
                      height: mediaQueryData.size.height / 50,
                    ),

                    //勤務場所
                    SizedBox(
                        width: width - 20,
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            children: [
                              const Text(
                                "勤務場所",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //空白
                              SizedBox(
                                height: mediaQueryData.size.height / 100,
                              ),
                              Text(
                                  "〒${jobDetailList["postalNumber"]}  ${jobDetailList["prefecture"]}${jobDetailList["city"]}${jobDetailList["houseNumber"]}")
                            ])),

                    //空白
                    SizedBox(
                      height: mediaQueryData.size.height / 50,
                    ),

                    //給与
                    SizedBox(
                        width: width - 20,
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            children: [
                              const Text(
                                "給与",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //空白
                              SizedBox(
                                height: mediaQueryData.size.height / 100,
                              ),
                              Text("時給 : ${jobDetailList["salary"]}円")
                            ])),

                    //空白
                    SizedBox(
                      height: mediaQueryData.size.height / 50,
                    ),

                    //イベント詳細
                    //任意入力が一つでもある場合のみ表示
                    if (jobDetailList["additional_message"] != null)
                      SizedBox(
                        width: width - 20,
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
                            children: [
                              const Text(
                                "イベント詳細",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //空白
                              SizedBox(
                                height: mediaQueryData.size.height / 100,
                              ),

                              //追加メッセージ
                              if (jobDetailList["additional_message"] != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // 子ウィジェットを左詰めに配置
                                  children: [
                                    const Text("追加メッセージ："),
                                    Text(jobDetailList["additional_message"]),
                                  ],
                                ),
                              //空白
                              SizedBox(
                                height: mediaQueryData.size.height / 50,
                              ),
                            ]),
                      ),
                    //空白
                    SizedBox(
                      height: mediaQueryData.size.height / 30,
                    ),

                    // ElevatedButton(
                    //     child: Text("閉じる"),
                    //     onPressed: () async {
                    //       Navigator.pop(context);
                    //     }),

                    // SizedBox(
                    //   height: 50,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
