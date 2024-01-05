import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
//import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

import 'package:reelproject/app_router/app_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// //オーバーレイ
// import 'package:reelproject/overlay/rule/screen/delete_conf.dart';
// import 'package:reelproject/overlay/rule/screen/conf/conf_conf.dart';
// import 'package:reelproject/overlay/rule/screen/conf/conf_delete.dart';
// import 'package:reelproject/overlay/rule/screen/notpost_delete_conf.dart';
// import 'package:reelproject/overlay/rule/screen/rule_screen.dart';

//ログイン以外のアプリを包括するレイヤー
//ボトムアップバーは共有で、それ以外が変更される

@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override

  //移動可能なRoutes

  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return AutoTabsScaffold(
        //移動可能なRoutes
        routes: const [
          HomeRouterRoute(),
          EventRouterRoute(),
          JobRouterRoute(),
          MyPageRouterRoute(),
        ],

        //ボトムアップバー
        bottomNavigationBuilder: (_, tabsRouter) {
          return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            CurvedNavigationBar(
                color: store.mainColor,
                buttonBackgroundColor: store.mainColor,
                backgroundColor: Colors.white,
                animationCurve: Curves.easeInOutQuart,
                animationDuration:
                    const Duration(milliseconds: 400), //アニメーションの時間
                index: tabsRouter.activeIndex, //現在の位置,
                items: const <Widget>[
                  IconWithText(icon: Icons.home, text: 'ホーム'),
                  IconWithText(icon: Icons.celebration, text: 'イベント'),
                  IconWithText(icon: Icons.work, text: '　求人　'),
                  IconWithText(icon: Icons.person, text: 'マイページ'),
                ],
                onTap: (int index) {
                  //ネストされたルーターのスタック情報を破棄(初期化される)
                  //オーバーレイ
                  // ConfDelete().hide();
                  // ConfConf().hide();
                  // DeleteConf().hide();
                  // NotpostDeleteConf().hide();
                  // RuleScreen().hide();
                  tabsRouter
                      .innerRouterOf<StackRouter>(tabsRouter.current.name)
                      ?.popUntilRoot();
                  //選択したタブへ移動
                  // // 選択中じゃないタブをTapした場合
                  if (tabsRouter.activeIndex != index) {
                    //選択したタブへ移動
                    //context.pushRoute(pushRoutes[index]);
                    tabsRouter.setActiveIndex(index);
                  }
                }),
            //オーバーレイ表示時にボトムアップバーを触れなくする
            if (store.jedgeOverlay)
              Container(
                color: Colors.black.withAlpha(150),
                width: mediaQueryData.size.width,
                height: 105,
              ),
          ]);
          // return BottomNavigationBar(
          //     currentIndex: tabsRouter.activeIndex, //現在の位置
          //     type: BottomNavigationBarType.fixed, //見た目、動作をコントロール
          //     backgroundColor: store.subColor, //バーの色

          //     //選択されたアイコンとラベルの色
          //     selectedItemColor: store.mainColor,

          //     //選択されたアイコンのテーマ
          //     selectedIconTheme: const IconThemeData(size: 45),
          //     //選択されていないアイコンのテーマ
          //     unselectedIconTheme: const IconThemeData(size: 30),

          //     //選択されたタイトルのスタイル
          //     selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          //     //選択されていないタイトルのスタイル
          //     unselectedLabelStyle:
          //         const TextStyle(fontWeight: FontWeight.bold),
          //     selectedFontSize: 12, //選択されたフォントのスタイル

          //     //使用中アイコン情報
          //     items: const [
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.home),
          //         label: 'ホーム',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.celebration),
          //         label: 'イベント',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.work),
          //         label: '求人',
          //       ),
          //       BottomNavigationBarItem(
          //         icon: Icon(Icons.person),
          //         label: 'マイページ',
          //       ),
          //     ],
          //     onTap: (int index) {
          //       //ネストされたルーターのスタック情報を破棄(初期化される)
          //       tabsRouter
          //           .innerRouterOf<StackRouter>(tabsRouter.current.name)
          //           ?.popUntilRoot();
          //       //選択したタブへ移動
          //       // // 選択中じゃないタブをTapした場合
          //       if (tabsRouter.activeIndex != index) {
          //         //選択したタブへ移動
          //         //context.pushRoute(pushRoutes[index]);
          //         tabsRouter.setActiveIndex(index);
          //       }
          //       // // 選択中のタブをTapした場合
          //     });
        });
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconWithText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: Colors.white),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
