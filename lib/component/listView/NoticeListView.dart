import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/changeGeneralCorporation.dart';

//通知一覧クラス
class NoticeListView extends StatelessWidget {
  const NoticeListView({
    super.key,
    required this.jedgeEJ,
    required this.noticeList,
  });

  final int jedgeEJ; //イベントか求人かジャッジ
  final List<List<Map<String, dynamic>>> noticeList; //通知タイトル

  //アイコン
  static List icon = [Icons.favorite, Icons.work];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    //ListViewをColumnの中にいれるにはExpandedを行う必要がある
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
                      bottom: BorderSide(color: store.greyColor), //リストを区別する線
                    ),
                  ),
                  //リストの内容
                  child: Expanded(
                      //リストの一つ一つを作成するListTitle
                      child: ListTile(
                          //左のアイコン
                          //Containerで円を作っている
                          leading: Container(
                              height: 70, //アイコン高さ
                              width: 70, //アイコン幅
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, //円形に
                                  color: store.subColor), //アイコン周囲円の色
                              //円内のアイコン
                              child: Icon(icon[jedgeEJ],
                                  size: 45, color: store.mainColor)), //アイコンの色
                          //右側の矢印アイコン
                          trailing: Padding(
                            padding: const EdgeInsets.all(
                                15.0), //このままだと真ん中に来ないため空間を作る
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 30,
                              color: store.greyColor,
                            ),
                          ),
                          title:
                              Text(noticeList[jedgeEJ][index]["title"]), //タイトル
                          subtitle: Text(
                              noticeList[jedgeEJ][index]["subtitle"]), //サブタイトル
                          visualDensity: VisualDensity(
                              vertical: 1.5), //listTitleの大きさを広げている(1.5倍)
                          onTap: () {}))); //ボタンを押した際の挙動
        },
        itemCount: noticeList[jedgeEJ].length, //リスト数
      ),
    );
  }
}
