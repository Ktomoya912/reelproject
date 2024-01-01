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
    return const Size(double.infinity, 140);
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
              ),
            ));
      }
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
            SizedBox(
              //height: 40, //検索バーの高さ,
              width: widget.mediaQueryData.size.width * widthPower, //検索バーの幅
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
              height: widget.mediaQueryData.size.height / 40,
            ),

            //タイトルバー
            Expanded(
                child: Container(
              width: widget.mediaQueryData.size.width,
              color: store.thinColor,
              child: Center(child: Text(widget.title)),
            )),
          ],
        ),
      ),
    );
  }
}
