import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

//検索アップバー
//ただし、bodyにて使用すること
class EventJobSearchBar extends StatefulWidget {
  const EventJobSearchBar({
    super.key,
    required this.tagList,
    required this.favoriteHistoryList,
    required this.title,
  });

  final List tagList; //表示するタグのリスト
  final List<Map<String, dynamic>> favoriteHistoryList; //表示するお気に入り、閲覧履歴リスト
  final String title; //タイトル

  @override
  State<EventJobSearchBar> createState() => EventJobSearchBarState();
}

//アップバーを動的とするためのクラス
class EventJobSearchBarState extends State<EventJobSearchBar> {
  final _controller = TextEditingController(); //検索バーのコントローラー

  //検索ボタンを押したときの処理
  void _submission(text) {
    setState(() {
      //print(text);
    });
  }

  static double widthPower = 11 / 12; //検索バーの幅の割合
  static double lineWidth = 1.3; //線の太さ定数

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    //タイトルバーの最大、最小サイズ
    double titleSize = mediaQueryData.size.height / 25;
    //最大
    if (titleSize > 50.0) {
      titleSize = 50;
    }
    //最小
    else if (titleSize < 30.0) {
      titleSize = 30;
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //高さ調整(一番上の空間)
            SizedBox(
              height: mediaQueryData.size.height / 20,
            ),
            //検索バー
            SizedBox(
              height: 40, //検索バーの高さ,
              width: mediaQueryData.size.width * widthPower, //検索バーの幅
              child: TextField(
                cursorColor: store.mainColor, //カーソルの色
                controller: _controller,
                //検索バーの装飾
                decoration: InputDecoration(
                  //背景色
                  fillColor: store.thinColor,
                  filled: true,
                  hintText: "   キーワードで検索",
                  hintStyle: TextStyle(color: store.blackColor),
                  //選択時の動作
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), //角丸
                    borderSide: BorderSide(
                      color: store.thinColor,
                    ),
                  ),
                  //未選択時の動作
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), //角丸
                      borderSide: BorderSide(
                        color: store.thinColor,
                      )),

                  //検索バーアイコン
                  prefixIcon: Icon(Icons.search, color: store.blackColor),
                  //消去アイコン
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controller.clear(); //検索バーの文字を消去
                    },
                    icon: Icon(Icons.clear, color: store.blackColor),
                  ),
                  isDense: true,
                ),
                //検索ボタンを押したときの処理
                //上に記述
                onSubmitted: (text) => _submission(text),
              ),
            ),
            //高さ調整
            SizedBox(
              height: mediaQueryData.size.height / 80,
            ),
            //タグリスト
            //横スクロール
            //マウスでのスクロールができない===============================================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //タグをリストの内容だけ表示
                  for (String tag in widget.tagList)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 40), //最小サイズ
                          elevation: 0, //影の濃さ
                          backgroundColor: store.thinColor,
                          foregroundColor: store.blackColor,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {},
                        child: Text(tag),
                      ),
                    ),
                ],
              ),
            ),

            //高さ調整
            SizedBox(
              height: mediaQueryData.size.height / 80,
            ),

            //お気に入り、閲覧履歴リスト
            SizedBox(
                width: mediaQueryData.size.width,
                //height: 100,
                child: FavoriteHistoryList(
                  mediaQueryData: mediaQueryData,
                  store: store,
                  list: widget.favoriteHistoryList,
                )),

            //タイトルバー
            Container(
              height: titleSize,
              width: mediaQueryData.size.width,
              color: store.thinColor,
              child: Center(child: Text(widget.title)),
            )
          ],
        ),
      ),
    );
  }
}

//閲覧履歴、お気に入りリストを作成するクラス
class FavoriteHistoryList extends StatelessWidget {
  const FavoriteHistoryList({
    super.key,
    required MediaQueryData mediaQueryData,
    required this.store,
    required this.list,
  }) : _mediaQueryData = mediaQueryData;

  final MediaQueryData _mediaQueryData;
  final ChangeGeneralCorporation store;
  final List<Map<String, dynamic>> list;

  static double widthPower = 11 / 12; //横幅の倍率定数
  static double lineWidth = 1.3; //線の太さ定数

  @override
  Widget build(BuildContext context) {
    //アイコンの最大、最小サイズ
    double iconSize = _mediaQueryData.size.height / 25;
    if (iconSize > 40.0) {
      iconSize = 40;
    } else if (iconSize < 33.0) {
      iconSize = 33;
    }
    return Column(
      children: [
        //上の線
        Container(
          width: _mediaQueryData.size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: store.greyColor, width: lineWidth), //リストを区別する線
            ),
          ),
        ),
        //リスト
        //閲覧履歴=========================================
        ListTile(
            //左のアイコン
            leading: Icon(
              list[0]["icon"],
              size: iconSize,
              color: store.mainColor,
            ),
            //右側の矢印アイコン
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: store.greyColor,
            ),
            title: Text(
              list[0]["title"],
              style: const TextStyle(fontSize: 15),
            ), //タイトル
            contentPadding: EdgeInsets.symmetric(
                horizontal: _mediaQueryData.size.width / 20), //タイル内の余白
            onTap: () {
              // Navigator.push(
              //     context,
              //     PageRouteBuilder(
              //         pageBuilder: (context, animation,
              //                 secondaryAnimation) =>
              //             ));
            }),
        Container(
          width: _mediaQueryData.size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: store.greyColor, width: lineWidth), //リストを区別する線
            ),
          ),
        ),
        //お気に入り===============================
        ListTile(
            //左のアイコン
            leading: Icon(
              list[1]["icon"],
              size: iconSize,
              color: store.mainColor,
            ),
            //右側の矢印アイコン
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: store.greyColor,
            ),
            title: Text(
              list[1]["title"],
              style: const TextStyle(fontSize: 15),
            ), //タイトル
            contentPadding: EdgeInsets.symmetric(
                horizontal: _mediaQueryData.size.width / 20), //タイル内の余白
            onTap: () {
              // Navigator.push(
              //     context,
              //     PageRouteBuilder(
              //         pageBuilder: (context, animation,
              //                 secondaryAnimation) =>
              //             ));
            }),
        // Container(
        //   width: _mediaQueryData.size.width,
        //   decoration: BoxDecoration(
        //     border: Border(
        //       bottom: BorderSide(
        //           color: store.greyColor, width: lineWidth), //リストを区別する線
        //     ),
        //   ),
        // )
      ],
    );
  }
}