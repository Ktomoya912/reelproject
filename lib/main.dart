import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/app_router/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChangeGeneralCorporation(),
        child: Builder(builder: (BuildContext context) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routerConfig: _appRouter.config(), //auto_route
          );
        }));
  }
}
