import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:reelproject/appRouter/appRouter.dart';

//ログイン以外のアプリレイヤー
//ボトムアップバーは共有で、それ以外が変更される
@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      //このレイヤーから移動可能なRoute
      //ホーム、イベント、求人、マイページに移動可能
      routes: const [
        HomeRouterRoute(),
        EventRouterRoute(),
        JobRouterRoute(),
        MyPageRouterRoute(),
      ],
      builder: (context, child) {
        // タブが切り替わると発火します
        final tabsRouter = context.tabsRouter;
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'ホーム',
              ),
              NavigationDestination(
                icon: Icon(Icons.celebration),
                label: 'イベント',
              ),
              NavigationDestination(
                icon: Icon(Icons.work),
                label: '求人',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'マイページ',
              ),
            ],
            onDestinationSelected: tabsRouter.setActiveIndex,
          ),
        );
      },
    );
  }
}
