import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/job/job_post_detail.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//求人広告リストコンポーネント
class JobAdvertisementList extends StatefulWidget {
  const JobAdvertisementList({
    super.key,
    required this.advertisementList,
    required this.mediaQueryData,
  });

  final List<dynamic> advertisementList;
  final MediaQueryData mediaQueryData;

  static double lineWidth = 0.7; //線の太さ定数

  static String dayString = "時給 : ";
  static String timeString = "時間 : ";
  static String placeString = "場所 : ";

  static String enString = "円";

  @override
  State<JobAdvertisementList> createState() => _JobAdvertisementListState();
}

class _JobAdvertisementListState extends State<JobAdvertisementList> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    double buttonWidthPower = widget.mediaQueryData.size.width / 4; //ボタンの縦横幅
    //画像の縦横幅の最大、最小値
    if (buttonWidthPower > 230) {
      buttonWidthPower = 230;
    } else if (buttonWidthPower < 170) {
      buttonWidthPower = 170;
    }
    double imageWidthPower =
        buttonWidthPower - widget.mediaQueryData.size.width / 40; //画像の縦横幅
    //横幅が想定より大きくなった場合、横の幅を広げる
    //その時足し加える値
    double addWidth = 0;
    //横のほうが広くなった場合
    if (widget.mediaQueryData.size.width > widget.mediaQueryData.size.height) {
      addWidth = (widget.mediaQueryData.size.width -
              widget.mediaQueryData.size.height) /
          3;
    }

    return Expanded(
      child: ListView.builder(
        itemCount: widget.advertisementList.length, //要素数

        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              //ボタン
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  JobPostDetail(
                                    id: widget.advertisementList
                                        .elementAt(index)["id"],
                                    tStore: store,
                                  )));
                  //タップ処理
                },
                child:
                    //ボタン全体のサイズ
                    SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //横方向真ん中寄寄せ
                    children: [
                      SizedBox(
                          width: (widget.mediaQueryData.size.width / 100) +
                              addWidth),
                      //左の文
                      SizedBox(
                        width: (widget.mediaQueryData.size.width / 12 * 6) -
                            (addWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
                          mainAxisSize: MainAxisSize.min, //縦方向真ん中寄せ
                          children: [
                            //タイトル
                            Text(
                              widget.advertisementList.elementAt(index)["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, //左寄せ
                              children: [
                                //時給
                                Text(
                                    "時給 : ${widget.advertisementList.elementAt(index)["salary"].substring(2)}",
                                    style: const TextStyle(fontSize: 18)),
                                //時間
                                if (widget.advertisementList
                                    .elementAt(index)["is_one_day"])
                                  Text(
                                    "時間 : ${widget.advertisementList.elementAt(index)["job_times"][0]["start_time"].substring(11, 16)}~${widget.advertisementList.elementAt(index)["job_times"][0]["end_time"].substring(11, 16)}",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                //場所
                                Text(
                                    JobAdvertisementList.placeString +
                                        widget.advertisementList
                                            .elementAt(index)["prefecture"] +
                                        widget.advertisementList
                                            .elementAt(index)["city"] +
                                        widget.advertisementList
                                            .elementAt(index)["address"],
                                    style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //画像
                      SizedBox(
                        height: buttonWidthPower + 10, //ボタン全体の高さ,
                        width: (widget.mediaQueryData.size.width / 12 * 5) -
                            (addWidth) +
                            10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, //右寄せ
                          children: [
                            //重ねる
                            Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: <Widget>[
                                  SizedBox(
                                    height: imageWidthPower + 10,
                                    width: imageWidthPower + 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center, //中央寄せ
                                      children: [
                                        SizedBox(
                                            height: imageWidthPower,
                                            width: imageWidthPower,
                                            //画像
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: store.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Image.network(
                                                    widget.advertisementList
                                                        .elementAt(
                                                            index)["image_url"]
                                                        .toString(),
                                                    fit: BoxFit.cover))),
                                      ],
                                    ),
                                  ),
                                  //長期、短期タグ
                                  //長期短期の判定は時間がnullかどうかで判定
                                  //長期
                                  if (widget.advertisementList
                                          .elementAt(index)["is_one_day"] ==
                                      false)
                                    Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "長期",
                                          style: GoogleFonts.mochiyPopOne(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    )
                                  //短期
                                  else
                                    Container(
                                      height: 40,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[500],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "短期",
                                          style: GoogleFonts.mochiyPopOne(
                                            fontSize: 20,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    )
                                ]),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: (widget.mediaQueryData.size.width / 100) +
                              addWidth),
                    ],
                  ),
                ),
              ),
              //下線
              Container(
                width: widget.mediaQueryData.size.width -
                    (widget.mediaQueryData.size.width / 20) -
                    addWidth * 2,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: store.greyColor,
                        width: JobAdvertisementList.lineWidth),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
