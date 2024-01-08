import 'package:auto_route/auto_route.dart';

import 'package:reelproject/page/root_page/root_page.dart';
import 'package:reelproject/page/home/home.dart';
import 'package:reelproject/page/event/event.dart';
import 'package:reelproject/page/job/job.dart';
import 'package:reelproject/page/mypage/mypage.dart';
import 'package:reelproject/page/root_page/change_root_page.dart';
import 'package:reelproject/page/login/login_page.dart';
import 'package:reelproject/page/login/secession_finish.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/', page: ChangeRootRoute.page, children: [
          AutoRoute(path: 'login', page: LoginRoute.page),
          AutoRoute(path: 'secession', page: SecessionFinishRoute.page),
          AutoRoute(
            path: 'app',
            page: RootRoute.page,
            children: [
              //ホーム
              AutoRoute(
                path: 'home',
                page: HomeRouterRoute.page,
                children: [
                  AutoRoute(
                    initial: true,
                    page: HomeRoute.page,
                  ),
                ],
              ),
              //イベント
              AutoRoute(
                path: 'event',
                page: EventRouterRoute.page,
                children: [
                  AutoRoute(
                    initial: true,
                    page: EventRoute.page,
                  ),
                ],
              ),
              //求人
              AutoRoute(
                path: 'job',
                page: JobRouterRoute.page,
                children: [
                  AutoRoute(
                    initial: true,
                    page: JobRoute.page,
                  ),
                ],
              ),
              //イベント
              AutoRoute(
                path: 'mypage',
                page: MyPageRouterRoute.page,
                children: [
                  AutoRoute(
                    initial: true,
                    page: MyPageRoute.page,
                  ),
                ],
              ),
            ],
          )
        ]),
      ];
}
