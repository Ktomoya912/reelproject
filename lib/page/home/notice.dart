import 'package:flutter/material.dart';
import '/component/bottomAppBar/bNB.dart';
import '/component/appBar/titleAppBar.dart';

class Notice extends StatefulWidget {
  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final int index = 0; //BottomAppBarのIcon番号
  final String title = "通知"; //AppBarに表示する文字

  //イベント通知タイトルリスト
  var eventTitleList = ["【イベント開催間近】", "【イベント開催間近】", "【イベント開催間近】"];
  //イベント通知サブタイトルリスト
  var eventSubTitleList = ["開催間近", "開催間近", "開催間近"];
  //イベント通知アイコンリスト
  var eventIconList = [Icons.favorite, Icons.favorite, Icons.favorite];

  //イベント通知タイトルリスト
  var jobTitleList = ["【求人期限間近】", "【求人期限間近】", "【求人期限間近】"];
  //イベント通知サブタイトルリスト
  var jobSubTitleList = ["開催間近", "開催間近", "開催間近"];
  //イベント通知アイコンリスト
  var jobIconList = [Icons.work, Icons.work, Icons.work];

  bool jedge = true; //イベント:true, 求人:false

  //jedgeを変更し通知する
  void jedgeChange(bool j) {
    setState(() {
      jedge = j;
    });
  }

  //カラーをjedgeの値によって変更
  Color colorJedge(bool j, Color trueColor, Color falseColor) {
    if (j) {
      return trueColor;
    } else {
      return falseColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      //アップバー
      appBar: TitleAppBar(title: title),

      body: Column(
        children: [
          //イベント、求人切り替えボタン
          //四角で囲む(上ボタンの幅選択)
          Container(
            height: 50, //高さ
            decoration: const BoxDecoration(
              //枠線
              border: Border(
                bottom: BorderSide(color: Colors.grey), //リストを区別する線
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //イベントボタン
                SizedBox(
                  height: 50, //ボタン高さ(上と同じ値)
                  width: _mediaQueryData.size.width / 2, //幅調整
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorJedge(jedge, Colors.blue.shade300,
                          Colors.white), //jedgeの値によってボタンの色変更
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), //角の丸み
                      ),
                    ),
                    onPressed: () => jedgeChange(true), //jedgeの値をtrueとする
                    child: Text('イベント',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorJedge(jedge, Colors.white,
                                Colors.blue))), //jedgeの値によって文字の色変更
                  ),
                ),
                //求人ボタン
                SizedBox(
                  height: 50, //ボタン高さ(上と同じ値)
                  width: _mediaQueryData.size.width / 2, //幅調整
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: colorJedge(jedge, Colors.white,
                          Colors.blue.shade300), //jedgeの値によってボタンの色変更
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0), //角の丸み
                      ),
                    ),
                    onPressed: () => jedgeChange(false), //jedgeの値をtrueとする
                    child: Text('求人',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorJedge(jedge, Colors.blue,
                                Colors.white))), //jedgeの値によって文字の色変更
                  ),
                ),
              ],
            ),
          ),

          //リスト
          ListViewChange(
            jedge: jedge,
            eventTitleList: eventTitleList,
            eventSubTitleList: eventSubTitleList,
            eventIconList: eventIconList,
            jobTitleList: jobTitleList,
            jobSubTitleList: jobSubTitleList,
            jobIconList: jobIconList,
          ),
        ],
      ),

      //ボトムナビゲーションバー
      bottomNavigationBar: BNB(index: index),
    );
  }
}

//通知一覧クラス
class ListViewChange extends StatelessWidget {
  const ListViewChange({
    super.key,
    required this.eventTitleList,
    required this.eventSubTitleList,
    required this.eventIconList,
    required this.jobTitleList,
    required this.jobSubTitleList,
    required this.jobIconList,
    required this.jedge,
  });

  //引数
  final List<String> eventTitleList;
  final List<String> eventSubTitleList;
  final List<IconData> eventIconList;
  final List<String> jobTitleList;
  final List<String> jobSubTitleList;
  final List<IconData> jobIconList;
  final bool jedge;

  //使用するリスト一覧
  static var titleList = [];
  static var subTitleList = [];
  static var iconList = [];

  @override
  Widget build(BuildContext context) {
    //jedgeによって使用するリスト決定
    if (jedge) {
      titleList = eventTitleList;
      subTitleList = eventSubTitleList;
      iconList = eventIconList;
    } else {
      titleList = jobTitleList;
      subTitleList = jobSubTitleList;
      iconList = jobIconList;
    }

    return Expanded(
      //通知一覧
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return
              //四角作成(これの大きさがリストの高さをになっている)
              Container(
                  height: 90, //リストの高さ
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey), //リストを区別する線
                    ),
                  ),
                  //リストの内容
                  child: Expanded(
                      child: ListTile(
                          //左のアイコン
                          leading: Container(
                              height: 70, //アイコン高さ
                              width: 70, //アイコン幅
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, //円形に
                                  color: Colors.orange.shade100), //アイコン周囲円の色
                              //円内のアイコン
                              child: Icon(iconList[index],
                                  size: 45, color: Colors.orange)), //アイコンの色
                          //右側の矢印アイコン
                          trailing: Padding(
                            padding: const EdgeInsets.all(
                                15.0), //このままだと真ん中に来ないため空間を作る
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                          title: Text(titleList[index]), //タイトル
                          subtitle: Text(subTitleList[index]), //サブタイトル
                          visualDensity: VisualDensity(
                              vertical: 1.5), //listTitleの大きさを広げている(1.5倍)
                          onTap: () {}))); //ボタンを押した際の挙動
        },
        itemCount: titleList.length, //リスト数
      ),
    );
  }
}
