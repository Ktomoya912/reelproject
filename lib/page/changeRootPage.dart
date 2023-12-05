import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:reelproject/appRouter/appRouter.dart';

@RoutePage()
class ChangeRootPage extends StatelessWidget {
  const ChangeRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
        routes: const [LoginRoute(), RootRoute()],
        builder: (context, child) {
          // タブが切り替わると発火します
          //final tabsRouter = context.tabsRouter;
          return Scaffold(
            body: child,
          );
        });
  }
}
