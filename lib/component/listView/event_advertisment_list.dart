import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

//イベント広告リスト
class EventAdvertisementList extends StatelessWidget {
  const EventAdvertisementList({
    super.key,
    required this.advertisementList,
    required this.mediaQueryData,
  });

  final List<Map<String, dynamic>> advertisementList;
  final MediaQueryData mediaQueryData;

  static double lineWidth = 1.3; //線の太さ定数

  static String dayString = "開催日     : ";
  static String timeString = "開催時間 : ";
  static String placeString = "開催場所 : ";

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    double buttonWidthPower = mediaQueryData.size.width / 4; //ボタンの縦横幅
    //画像の縦横幅の最大、最小値
    if (buttonWidthPower > 230) {
      buttonWidthPower = 230;
    } else if (buttonWidthPower < 170) {
      buttonWidthPower = 170;
    }
    double imageWidthPower =
        buttonWidthPower - mediaQueryData.size.width / 40; //画像の縦横幅
    //横幅が想定より大きくなった場合、横の幅を広げる
    //その時足し加える値
    double addWidth = 0;
    //横のほうが広くなった場合
    if (mediaQueryData.size.width > mediaQueryData.size.height) {
      addWidth = (mediaQueryData.size.width - mediaQueryData.size.height) / 15;
    }

    return ListView.builder(
      itemCount: advertisementList.length, //要素数
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            //ボタン
            InkWell(
              onTap: () {
                //タップ処理
              },
              child:
                  //ボタン全体のサイズ
                  SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, //横方向真ん中寄寄せ
                  children: [
                    SizedBox(
                        width: (mediaQueryData.size.width / 100) + addWidth),
                    //左の文
                    SizedBox(
                      width:
                          (mediaQueryData.size.width / 12 * 6) - (addWidth / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
                        mainAxisSize: MainAxisSize.min, //縦方向真ん中寄せ
                        children: [
                          //タイトル
                          Text(
                            advertisementList.elementAt(index)["title"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //左寄せ
                            children: [
                              //開催日
                              Text(
                                  dayString +
                                      advertisementList.elementAt(index)["day"],
                                  style: const TextStyle(fontSize: 18)),
                              //開催時
                              Text(
                                  timeString +
                                      advertisementList
                                          .elementAt(index)["time"],
                                  style: const TextStyle(fontSize: 18)),
                              //開催場所
                              Text(
                                  placeString +
                                      advertisementList
                                          .elementAt(index)["place"],
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //画像
                    SizedBox(
                      height: buttonWidthPower + 10, //ボタン全体の高さ,
                      width:
                          (mediaQueryData.size.width / 12 * 5) - (addWidth / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, //右寄せ
                        children: [
                          Container(
                            height: imageWidthPower,
                            width: imageWidthPower,
                            decoration: BoxDecoration(
                              color: store.mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: (mediaQueryData.size.width / 100) + addWidth),
                  ],
                ),
              ),
            ),
            //下線
            Container(
              width: mediaQueryData.size.width -
                  (mediaQueryData.size.width / 20) -
                  addWidth,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: store.greyColor, width: lineWidth), //リストを区別する線
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
