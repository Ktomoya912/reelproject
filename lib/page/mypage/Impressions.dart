import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '/provider/change_general_corporation.dart';

@RoutePage()
class ImpressionsRouterPage extends AutoRouter {
  const ImpressionsRouterPage({super.key});
}

@RoutePage()
class Impressions extends StatefulWidget {
  const Impressions({super.key});

  @override
  State<Impressions> createState() => _ImpressionsState();
}

class _ImpressionsState extends State<Impressions> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: ImpressionsAppBar(
        title: "マイページ",
        jedgeBuck: true,
      ),

      //内部
      body: ScrollImpressionsDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollImpressionsDetail extends StatelessWidget {
  const ScrollImpressionsDetail({
    super.key,
  });

  //一般向けマイページリスト

  //法人向けマイページリスト

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    final List<Color> colorList = [
      store.mainColor,
      store.subColor,
      const Color(0xff6c5ce7),
      const Color(0x86B6F6),
      const Color(0x35A29F),
      store.greyColor
    ];

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

    return SingleChildScrollView(
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '閲覧者総数',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '100人',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Divider(
              color: store.greyColor,
              thickness: 1,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'お気に入り登録者数',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '50人',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                  width: MediaQuery.of(context).size.width / 1.02,
                  
                  // child:Card(
                    child: Column(
                  
                    children: [
                      const Padding(padding: EdgeInsets.all(15)),
                      Pie_Chart(
                        key: ValueKey(store.mainDataMap),
                        dataMap: store.mainDataMap,
                        mainflag: true,
                        onTap: () => store.toggleDataSelection(store.mainDataMap),
                      ),
                      const Padding(padding: EdgeInsets.all(15)),
                      Text(store.mainTitle,
                          style:const TextStyle(
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
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Column(
                    children: [
                      Pie_Chart(
                        key: ValueKey(store.subDataMap1),
                        dataMap: store.subDataMap1,
                        mainflag: false,
                        onTap: () =>
                            store.toggleDataSelection(store.subDataMap1),
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
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Column(
                    children: [
                      Pie_Chart(
                        key: ValueKey(store.subDataMap2),
                        dataMap: store.subDataMap2,
                        mainflag: false,
                        onTap: () =>
                            store.toggleDataSelection(store.subDataMap2),
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
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Pie_Chart(
                        key: ValueKey(store.subDataMap3),
                        dataMap: store.subDataMap3,
                        mainflag: false,
                        onTap: () =>
                            store.toggleDataSelection(store.subDataMap3),
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
          ],
        ),
      ),
    );
  }
}

class Pie_Chart extends StatelessWidget {
  const Pie_Chart({
    Key? key,
    required this.dataMap,
    // required this.gradientList,
    required this.mainflag,
    required this.onTap,
  }) : super(key: key);

  final Map<String, double> dataMap;
  // final List<List<Color>> gradientList;
  final bool mainflag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 64,
            chartRadius: mainflag
                ? MediaQuery.of(context).size.width / 2.9
                : MediaQuery.of(context).size.width / 4.9,
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
              legendTextStyle: TextStyle(
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
