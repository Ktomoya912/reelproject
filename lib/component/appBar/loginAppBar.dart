import 'package:flutter/material.dart';
import '/provider/changeGeneralCorporation.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //アップバータイトル
      title: const Text(
        "REEL", //文字
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 44,
            color: Colors.white), //書体
      ),
      backgroundColor: store.mainColor, //背景
      iconTheme: const IconThemeData(color: Colors.grey), //戻るボタン
      centerTitle: true, //中央揃え
      toolbarHeight: 80, //アップバーの高さ
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 50),
          child: InkWell(
            onTap: () {
              store.changeGC(!store.jedgeGC);
            },
            splashColor: Colors.transparent, // splashColorを透明にする。
            child: store.jedgeGC
                ? const Text(
                    '法人の方はこちら',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    '個人の方はこちら',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
