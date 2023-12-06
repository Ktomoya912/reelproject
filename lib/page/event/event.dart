import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class EventRouterPage extends AutoRouter {
  const EventRouterPage({super.key});
}

@RoutePage()
class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final int index = 1; //BottomAppBarのIcon番号
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
