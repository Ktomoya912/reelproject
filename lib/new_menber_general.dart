import 'package:flutter/material.dart';

class NewMemberGeneral extends StatefulWidget {
  const NewMemberGeneral({Key? key}) : super(key: key);

  @override
  NewMemberGeneralState createState() => NewMemberGeneralState();
}

class NewMemberGeneralState extends State<NewMemberGeneral> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: const Center(
        child: Text('新規登録ページ'),
      ),
    );
  }
}
