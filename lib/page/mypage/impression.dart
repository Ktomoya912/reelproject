import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
//タイトルアップバー
import 'package:reelproject/component/appbar/title_appbar.dart';

@RoutePage()
class ImpressionsRouterPage extends AutoRouter {
  const ImpressionsRouterPage({super.key});
}

@RoutePage()
class Impressions extends StatefulWidget {
  const Impressions({super.key, required this.impressionData});

  final Map<String, dynamic> impressionData;

  @override
  State<Impressions> createState() => _ImpressionsState();
}

class _ImpressionsState extends State<Impressions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //アップバー
      appBar: const TitleAppBar(
        title: 'インプレッション',
        jedgeBuck: true,
      ),

      //内部
      body: ScrollImpressionsDetail(
        impressionData: widget.impressionData,
      ),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollImpressionsDetail extends StatelessWidget {
  const ScrollImpressionsDetail({
    super.key,
    required this.impressionData,
  });

  final Map<String, dynamic> impressionData;

  //一般向けマイページリスト

  //法人向けマイページリスト

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    // final List<Color> colorList = [
    //   store.mainColor,
    //   store.subColor,
    //   const Color(0xff6c5ce7),
    //   const Color(0x86B6F6FF),
    //   const Color(0x35A29FFF),
    //   store.greyColor
    // ];

    // final gradientList = <List<Color>>[
    //   [
    //     Color.fromRGBO(223, 250, 92, 1),
    //     Color.fromRGBO(129, 250, 112, 1),
    //   ],
    //   [
    //     Color.fromRGBO(100, 250, 92, 1),
    //     Color.fromRGBO(129, 250, 112, 1),
    //   ],
    //   [
    //     Color.fromRGBO(129, 182, 205, 1),
    //     Color.fromRGBO(91, 253, 199, 1),
    //   ],
    //   [
    //     Color.fromRGBO(175, 63, 62, 1.0),
    //     Color.fromRGBO(254, 154, 92, 1),
    //   ],
    // ];

// Pass gradient to PieChart

    return ShaderMaskComponent(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: store.greyColor,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '  閲覧者総数',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${impressionData["pv"]}人  ',
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Divider(
                color: store.greyColor,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '  お気に入り登録者数',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '${impressionData["favorite_user_count"]}人  ',
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Divider(
                color: store.greyColor,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '  性別割合',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 0,
                  ),
                  Text(
                    '男性:${(impressionData["sex"]["mJedge"] / impressionData["sex"]["allJedge"] * 100).ceil()}%',
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    '女性:${(impressionData["sex"]["fJedge"] / impressionData["sex"]["allJedge"] * 100).ceil()}%',
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'その他:${(impressionData["sex"]["oJedge"] / impressionData["sex"]["allJedge"] * 100).ceil()}%  ',
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Divider(
                color: store.greyColor,
                thickness: 1,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 400,

                    // child:Card(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(15)),
                        MyPieChart(
                          key: ValueKey(store.mainDataMap),
                          dataMap: impressionData["sex"]["all"],
                          mainflag: true,
                          onTap: () =>
                              store.toggleDataSelection(store.mainDataMap),
                          jedgeZero: impressionData["pv"] == 0 ? true : false,
                        ),
                        const Padding(padding: EdgeInsets.all(15)),
                        Text(store.mainTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ],
                      // )
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    child: Column(
                      children: [
                        MyPieChart(
                          key: ValueKey(store.subDataMap1),
                          dataMap: impressionData["sex"]["m"],
                          mainflag: false,
                          onTap: () =>
                              store.toggleDataSelection(store.subDataMap1),
                          jedgeZero: impressionData["sex"]["mJedge"] == 0
                              ? true
                              : false,
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(store.subTitle1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    width: 110,
                    child: Column(
                      children: [
                        MyPieChart(
                          key: ValueKey(store.subDataMap2),
                          dataMap: impressionData["sex"]["f"],
                          mainflag: false,
                          onTap: () =>
                              store.toggleDataSelection(store.subDataMap2),
                          jedgeZero: impressionData["sex"]["fJedge"] == 0
                              ? true
                              : false,
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(store.subTitle2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    width: 110,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MyPieChart(
                          key: ValueKey(store.subDataMap3),
                          dataMap: impressionData["sex"]["o"],
                          mainflag: false,
                          onTap: () =>
                              store.toggleDataSelection(store.subDataMap3),
                          jedgeZero: impressionData["sex"]["oJedge"] == 0
                              ? true
                              : false,
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Text(store.subTitle3,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(30)),
            ],
          ),
        ),
      ),
    );
  }
}

class MyPieChart extends StatelessWidget {
  const MyPieChart({
    super.key,
    required this.dataMap,
    // required this.gradientList,
    required this.mainflag,
    required this.onTap,
    required this.jedgeZero,
  });

  final Map<String, double> dataMap;
  // final List<List<Color>> gradientList;
  final bool mainflag;
  final VoidCallback onTap;
  final bool jedgeZero;

  @override
  Widget build(BuildContext context) {
    //データがない場合
    return jedgeZero
        ? SizedBox(
            width: !mainflag
                ? 150
                : MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.height /
                    5000,
            height: !mainflag
                ? 107
                : MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.height /
                    5000,
            child: const Center(
              child: Text(
                'データがありません',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          )

        //データがある場合
        : GestureDetector(
            onTap: onTap,
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 64,
                  chartRadius: mainflag
                      ? 150
                      : MediaQuery.of(context).size.width *
                          MediaQuery.of(context).size.height /
                          5250,
                  colorList: const [
                    Color(0xff6c5ce7),
                    Color(0xff0984e3),
                    Color(0xff00cec9),
                    Color(0xff00b894),
                    Color(0xfffdcb6e),
                    Color(0xffff7675),
                  ],
                  // gradientList: gradientList,
                  // emptyColorGradient: [
                  //   Color(0xff6c5ce7),
                  //   Colors.blue,
                  // ],
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: mainflag ? 52 : 35,
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: mainflag,
                    // legendShape: _BoxShape.circle,
                    legendTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: mainflag,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                )),
          );
  }
}

//appbar
class ImpressionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; //ページ名
  final bool jedgeBuck; //戻るボタンを表示するか否か

  const ImpressionsAppBar({
    super.key,
    required this.title,
    required this.jedgeBuck,
  });

  @override
  Size get preferredSize {
    return const Size(double.infinity, 80.0);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(

        //アップバー
        appBar: AppBar(
      //アップバータイトル
      title: Text(
        "REEL", //文字
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: store.mainColor), //書体
      ),
      automaticallyImplyLeading: jedgeBuck, //戻るボタンの非表示
      backgroundColor: Colors.white, //背景
      elevation: 0.0, //影なし
      iconTheme: IconThemeData(color: store.greyColor), //戻るボタン
      centerTitle: true, //中央揃え
      toolbarHeight: 100, //アップバーの高さ

      //画面説明アップバー
      bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: SizedBox(
            height: 30,
            child: AppBar(
              //アップバー内にアップバー(ページ説明のため)
              title: Text(
                "インプレッション",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: store.blackColor,
                ),
              ), //ページ説明文字
              centerTitle: true, //中央揃え
              automaticallyImplyLeading: false, //戻るボタンの非表示
              backgroundColor: store.subColor, //背景
              elevation: 0.0, //影なし
            ), //高さ
          )), //高さ
    ));
  }
}
