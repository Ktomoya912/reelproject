import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/app_router/app_router.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント

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
              //フォント
              textTheme: GoogleFonts.mPlus1pTextTheme(
                Theme.of(context).textTheme,
              ),
              primarySwatch: Colors.blue,
            ),
            routerConfig: _appRouter.config(), //auto_route
          );
        }));
  }
}
