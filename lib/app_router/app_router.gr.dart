// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HomeRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeRouterPage(),
      );
    },
    EventRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EventRouterPage(),
      );
    },
    JobRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const JobRouterPage(),
      );
    },
    MyPageRouterRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyPageRouterPage(),
      );
    },
    //ページ
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPage(),
      );
    },
    SecessionFinishRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SecessionFinish(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Home(),
      );
    },
    EventRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Event(),
      );
    },
    JobRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: Job(),
      );
    },
    MyPageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyPage(),
      );
    },
    RootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RootPage(),
      );
    },
    ChangeRootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChangeRootPage(),
      );
    },
  };
}

//ルーター

/// generated route for
/// [HomeRouterPage]
class HomeRouterRoute extends PageRouteInfo<void> {
  const HomeRouterRoute({List<PageRouteInfo>? children})
      : super(
          HomeRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// [EventRouterPage]
class EventRouterRoute extends PageRouteInfo<void> {
  const EventRouterRoute({List<PageRouteInfo>? children})
      : super(
          EventRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// [JobRouterPage]
class JobRouterRoute extends PageRouteInfo<void> {
  const JobRouterRoute({List<PageRouteInfo>? children})
      : super(
          JobRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'JobRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyPageRouterPage]
class MyPageRouterRoute extends PageRouteInfo<void> {
  const MyPageRouterRoute({List<PageRouteInfo>? children})
      : super(
          MyPageRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyPageRouterRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

//ページ
/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

class SecessionFinishRoute extends PageRouteInfo<void> {
  const SecessionFinishRoute({List<PageRouteInfo>? children})
      : super(
          SecessionFinishRoute.name,
          initialChildren: children,
        );

  static const String name = 'SecessionFinishRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EventPage]
class EventRoute extends PageRouteInfo<void> {
  const EventRoute({List<PageRouteInfo>? children})
      : super(
          EventRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [JobPage]
class JobRoute extends PageRouteInfo<void> {
  const JobRoute({List<PageRouteInfo>? children})
      : super(
          JobRoute.name,
          initialChildren: children,
        );

  static const String name = 'JobRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyPagePage]
class MyPageRoute extends PageRouteInfo<void> {
  const MyPageRoute({List<PageRouteInfo>? children})
      : super(
          MyPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyPageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RootPage]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChangeRootPage]
class ChangeRootRoute extends PageRouteInfo<void> {
  const ChangeRootRoute({List<PageRouteInfo>? children})
      : super(
          ChangeRootRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChangeRootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
