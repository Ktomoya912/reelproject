import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
//import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';

import 'package:reelproject/app_router/app_router.dart';

//ログイン以外のアプリを包括するレイヤー
//ボトムアップバーは共有で、それ以外が変更される
@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
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
          // return ConvexAppBar(
          //   //見た目
          //   backgroundColor: store.mainColor, //背景
          //   items: const [
          //     TabItem(icon: Icons.home, title: 'ホーム'),
          //     TabItem(icon: Icons.celebration, title: 'イベント'),
          //     TabItem(icon: Icons.work, title: '求人'),
          //     TabItem(icon: Icons.person, title: 'マイページ'),
          //   ],
          //   onTap: (int index) => {
          //     // 選択中じゃないタブをTapした場合
          //     if (tabsRouter.activeIndex != index)
          //       {
          //         //ネストされたルーターのスタック情報を破棄(初期化される)
          //         tabsRouter
          //             .innerRouterOf<StackRouter>(tabsRouter.current.name)
          //             ?.popUntilRoot(),
          //         //選択したタブへ移動
          //         tabsRouter.setActiveIndex(index)
          //       }
          //     // 選択中のタブをTapした場合
          //     else
          //       {
          //         // ネストされたルーターのスタック情報を破棄(初期化される)
          //         tabsRouter
          //             .innerRouterOf<StackRouter>(tabsRouter.current.name)
          //             ?.popUntilRoot()
          //       }
          //   },
          // );
          //以前のボトムアップバー
          return BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex, //現在の位置
              type: BottomNavigationBarType.fixed, //見た目、動作をコントロール
              backgroundColor: store.subColor, //バーの色

              //選択されたアイコンとラベルの色
              selectedItemColor: store.mainColor,

              //選択されたアイコンのテーマ
              selectedIconTheme: const IconThemeData(size: 45),
              //選択されていないアイコンのテーマ
              unselectedIconTheme: const IconThemeData(size: 30),

              //選択されたタイトルのスタイル
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              //選択されていないタイトルのスタイル
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
              selectedFontSize: 12, //選択されたフォントのスタイル

              //使用中アイコン情報
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'ホーム',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.celebration),
                  label: 'イベント',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: '求人',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'マイページ',
                ),
              ],
              onTap: (int index) {
                // 選択中じゃないタブをTapした場合
                if (tabsRouter.activeIndex != index) {
                  //ネストされたルーターのスタック情報を破棄(初期化される)
                  tabsRouter
                      .innerRouterOf<StackRouter>(tabsRouter.current.name)
                      ?.popUntilRoot();
                  //選択したタブへ移動
                  tabsRouter.setActiveIndex(index);
                }
                // 選択中のタブをTapした場合
                else {
                  // ネストされたルーターのスタック情報を破棄(初期化される)
                  tabsRouter
                      .innerRouterOf<StackRouter>(tabsRouter.current.name)
                      ?.popUntilRoot();
                }
              });
        });
  }
}
