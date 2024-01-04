import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/page/event/search_page.dart';

//検索アップバー
//ただしbodyにて使用すること
class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppbar({
    super.key,
    required this.title,
    required this.mediaQueryData,
    required this.eventJobJedge,
  });

  final String title; //タイトル
  final MediaQueryData mediaQueryData;
  final String eventJobJedge;

  @override
  Size get preferredSize {
    return const Size(double.infinity, 135);
  }

  @override
  State<SearchAppbar> createState() => SearchAppbarState();
}

//アップバーを動的とするためのクラス
class SearchAppbarState extends State<SearchAppbar> {
  final _controller = TextEditingController(); //検索バーのコントローラー

  //検索ボタンを押したときの処理
  void _submission(text) {
    setState(() {
      if (text != "") {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SearchPage(
                text: text,
                eventJobJedge: widget.eventJobJedge,
                sort: "新着順",
              ),
            ));
      }
    });
  }

  //並び順
  String sort = "新着順";
  void changeSort(String sortTitle) {
    setState(() {
      sort = sortTitle;
    });
  }

  static double widthPower = 11 / 12; //検索バーの幅の割合
  static double lineWidth = 1.3; //線の太さ定数

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //高さ調整(一番上の空間)
            SizedBox(
              height: widget.mediaQueryData.size.height / 20,
            ),
            //検索バー
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 45, //検索バーの高さ,
                  width: widget.mediaQueryData.size.width *
                      widthPower *
                      0.95, //検索バーの幅
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
              ],
            ),
            //高さ調整
            SizedBox(
              height: widget.mediaQueryData.size.height / 40,
            ),

            //タイトルバー
            Expanded(
              child: Container(
                  width: widget.mediaQueryData.size.width,
                  color: store.thinColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        //右寄せ
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.menu, color: store.thinColor, size: 30),
                          Text(
                            sort,
                            style: TextStyle(
                              color: store.thinColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          const Text("「"),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: widget.mediaQueryData.size.width / 5,
                            ),
                            child: Text(
                              widget.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Text("」検索結果"),
                        ],
                      ),

                      //並べ替え
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            child: Row(
                              //右寄せ
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.sort,
                                    color: Colors.grey[700], size: 30),
                                Text(
                                  sort,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showModalBottomSheet<int>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                            leading: const Icon(Icons.schedule),
                                            title: const Text('新着順'),
                                            onTap: () => {
                                                  Navigator.pop(context, 0),
                                                  changeSort("新着順"),
                                                }),
                                        if (widget.eventJobJedge == "おすすめイベント")
                                          ListTile(
                                              leading:
                                                  const Icon(Icons.schedule),
                                              title: const Text('開催期間順'),
                                              onTap: () => {
                                                    Navigator.pop(context, 1),
                                                    changeSort("開催期間順"),
                                                  }),
                                        if (widget.eventJobJedge == "おすすめ求人")
                                          ListTile(
                                              leading: const Icon(
                                                  Icons.attach_money),
                                              title: const Text('時給順'),
                                              onTap: () => {
                                                    Navigator.pop(context, 1),
                                                    changeSort("時給順"),
                                                  }),
                                        ListTile(
                                            leading: const Icon(Icons.favorite),
                                            title: const Text('いいね数順'),
                                            onTap: () => {
                                                  Navigator.pop(context, 2),
                                                  changeSort("いいね数順"),
                                                }),
                                        ListTile(
                                            leading: const Icon(Icons.star),
                                            title: const Text('レビュー順'),
                                            onTap: () => {
                                                  Navigator.pop(context, 2),
                                                  changeSort("レビュー順"),
                                                }),
                                      ],
                                    ));
                                  });
                            }),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
