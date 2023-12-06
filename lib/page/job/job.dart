import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class JobRouterPage extends AutoRouter {
  const JobRouterPage({super.key});
}

@RoutePage()
class Job extends StatefulWidget {
  const Job({super.key});

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  final int index = 2; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
