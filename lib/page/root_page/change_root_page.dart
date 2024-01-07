import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:reelproject/app_router/app_router.dart';

//アプリ全体を包括するレイヤー
@RoutePage()
class ChangeRootPage extends StatelessWidget {
  const ChangeRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
        routes: const [
          LoginRoute(),
          RootRoute(),
          SecessionFinishRoute()
        ], //このレイヤーから移動可能なRoute
        builder: (context, child) {
          // タブが切り替わると発火します
          //final tabsRouter = context.tabsRouter;
          return Scaffold(
            body: child, //bodyをroutesとする
          );
        });
  }
}
