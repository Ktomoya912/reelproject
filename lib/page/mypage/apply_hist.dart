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
  static List<dynamic> jobList = [
    {
      "name": "strinqewrg",
      "image_url": "https://example.com",
      "salary": "時給1000円",
      "postal_code": "782-8502",
      "prefecture": "高知県",
      "city": "香美市",
      "address": "土佐山田町宮ノ口185",
      "description": "説明",
      "is_one_day": false,
      "additional_message": "追加メッセージ",
      "tags": [
        {"name": "タグ名", "id": 1}
      ],
      "job_times": [
        {
          "start_time": "2024-01-23T14:51:29",
          "end_time": "2024-01-23T15:51:29",
          "id": 1
        }
      ],
      "id": 2,
      "status": null
    },
  ];

  void changeJobList(List<dynamic> e) {
    setState(() {
      jobList = e;
    });
  }

  Future getJobList(ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/users/job-applications');
    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'authorization': 'Bearer ${store.accessToken}'
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
              ),
            ],
          ),
        ));
  }
}
