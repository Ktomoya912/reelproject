import 'package:flutter/material.dart';
import '../../component/appbar/main_appbar.dart';
import 'package:auto_route/auto_route.dart';
import '/page/home/notice.dart';

@RoutePage()
class HomeRouterPage extends AutoRouter {
  const HomeRouterPage({super.key});
}

@RoutePage()
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int index = 0; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //アップバー
      appBar: MainAppBar(nextPage: Notice()),
    );
  }
}
