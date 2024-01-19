import 'package:flutter/material.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/appbar/title_appbar.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:provider/provider.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplyHist extends StatefulWidget {
  const ApplyHist({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  State<ApplyHist> createState() => _ApplyHistState();
}

class _ApplyHistState extends State<ApplyHist> {
  List<dynamic> jobList = [];

  void changeJobList(List<dynamic> e) {
    setState(() {
      jobList = e;
    });
  }

  Future getJobList(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.sortLastWatched}&order=asc&offset=0&limit=50&${ChangeGeneralCorporation.typeActive}&user_id=${store.myID}&target=apply');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeJobList(json.decode(data));
    } else {
      throw Exception("Failed");
    }
  }

  //初期化
  @override
  void initState() {
    getJobList(widget.store);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得

    return Scaffold(
        appBar: const TitleAppBar(
          title: "応募履歴",
          jedgeBuck: true,
        ),
        body: ShaderMaskComponent(
          child: Column(
            children: [
              JobAdvertisementList(
                advertisementList: jobList,
                mediaQueryData: mediaQueryData,
                notPostJedge: false,
                functionCall: () => getJobList(widget.store),
              ),
            ],
          ),
        ));
  }
}
