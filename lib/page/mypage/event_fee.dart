import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

class EventFee extends StatefulWidget {
  const EventFee({super.key});
  @override
  State<EventFee> createState() => _EventFeeState();
}

class _EventFeeState extends State<EventFee> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: EventFeeAppBar(
        title: "求人掲載料金確認画面",
        jedgeBuck: true,
      ),

      //内部
      body: ScrollEventFeeDetail(),
    );
  }
}

//スクロール可能なマイページの一覧画面
class ScrollEventFeeDetail extends StatelessWidget {
  const ScrollEventFeeDetail({
    super.key,
  });

  //一般向けマイページリスト

  //法人向けマイページリスト

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    // final EventStore = Provider.of<EventApplyPostDetail>(context);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
          child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Text(
                "以下の料金をご確認ください",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              FeeEvent(mediaQueryData, store, "合計金額", Colors.amber, "20,000円"),
              const Padding(padding: EdgeInsets.only(top: 300)),
              SizedBox(
                width: mediaQueryData.size.width * 0.7,
                child: const Text(
                  "※7日以内に指定の銀行への振り込みをお願いします。振り込みが確認でき次第投稿させていただきます",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: store.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(300, 50),
                ),
                child: const Text('振り込み口座を確認する'),
              ),
            ]),
      )),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox FeeEvent(MediaQueryData mediaQueryData,
      ChangeGeneralCorporation store, String Title, Color color, String text) {
    return SizedBox(
      height: mediaQueryData.size.height * 0.1,
      width: mediaQueryData.size.width * 0.9,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: mediaQueryData.size.width,
                color: color,
                child: Center(
                  child: Text(
                    Title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: store.blackColor,
                    ),
                  ),
                )),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              // EventStore.EventPeriod as String,
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: store.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//appbar
class EventFeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; //ページ名
  final bool jedgeBuck; //戻るボタンを表示するか否か

  const EventFeeAppBar({
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
                title,
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
