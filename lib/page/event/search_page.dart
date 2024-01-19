import 'package:flutter/material.dart';
//import 'package:auto_route/auto_route.dart';
//import 'package:reelproject/component/appbar/event_job_appbar.dart';
import 'package:reelproject/component/listView/event_advertisment_list.dart';
import 'package:reelproject/component/listView/job_advertisment_list.dart';
import 'package:reelproject/component/listView/shader_mask_component.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.text,
    required this.eventJobJedge,
    required this.sort,
    required this.sortType,
    required this.store,
  });

  final String text;
  final String eventJobJedge;
  final String sort;
  final String sortType;
  final store;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final int index = 1; //BottomAppBarのIcon番号

  //求人広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> jobList = [];
  //イベント広告のリスト
  //titleに文字数制限を設ける
  static List<dynamic> eventList = [];

  void changeEventList(List<dynamic> e) {
    setState(() {
      eventList = e;
    });
  }

  final _controller = TextEditingController(); //検索バーのコントローラー

  //並び順
  late String sort = widget.sort;
  String sortType = "id";
  void changeSort(String sortTitle) {
    setState(() {
      sort = sortTitle;
      switch (sortTitle) {
        case "新着順":
          sortType = "id";
          break;
        case "開催期間順":
          sortType = "recent";
          break;
        case "いいね数順":
          sortType = "favorite";
          break;
        case "レビュー順":
          sortType = "review";
          break;
        case "閲覧数順":
          sortType = "pv";
          break;
      }
      if (widget.eventJobJedge == "おすすめイベント") {
        getEventList(widget.store);
      } else {
        getJobList(widget.store);
      }
    });
  }

  static double widthPower = 11 / 12; //検索バーの幅の割合
  static double lineWidth = 1.3; //線の太さ定数

  Future getEventList(ChangeGeneralCorporation store) async {
    Uri url;
    if (widget.text.startsWith('#') || widget.text.startsWith('＃')) {
      url = Uri.parse(
          '${ChangeGeneralCorporation.apiUrl}/events/?tag=${Uri.encodeFull(widget.text.substring(1))}&${ChangeGeneralCorporation.typeActive}&sort=${sortType}&order=asc&offset=0&limit=60');
    } else {
      url = Uri.parse(
          '${ChangeGeneralCorporation.apiUrl}/events/?${ChangeGeneralCorporation.typeActive}&keyword=${Uri.encodeFull(widget.text)}&sort=${sortType}&order=asc&offset=0&limit=60');
    }

    //print(url);

    final response =
        await http.get(url, headers: {'accept': 'application/json'});
    final data = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      changeEventList(json.decode(data));
    } else {
      List<dynamic> eventList = [];
      changeEventList(eventList);
    }
  }

  void changeJobList(List<dynamic> e) {
    setState(() {
      jobList = e;
    });
  }

  Future getJobList(ChangeGeneralCorporation store) async {
    Uri url;
    if (widget.text.startsWith('#') || widget.text.startsWith('＃')) {
      url = Uri.parse(
          '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.typeActive}&tag=${Uri.encodeFull(widget.text.substring(1))}&sort=${sortType}&order=asc&offset=0&limit=60');
    } else {
      url = Uri.parse(
          '${ChangeGeneralCorporation.apiUrl}/jobs/?${ChangeGeneralCorporation.typeActive}&keyword=${Uri.encodeFull(widget.text)}&sort=${sortType}&order=asc&offset=0&limit=60');
    }
    final response = await http.get(url, headers: {
      'accept': 'application/json',
    });
    final data = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      changeJobList(json.decode(data));
    } else {
      List<dynamic> jobList = [];
      changeJobList(jobList);
    }
  }

  //初期化
  @override
  void initState() {
    if (widget.eventJobJedge == "おすすめイベント") {
      getEventList(widget.store);
    } else {
      getJobList(widget.store);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context); //画面サイズ取得
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ

    //検索ボタンを押したときの処理
    void _submission(text) {
      setState(() {
        if (text != "") {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SearchPage(
                        text: text,
                        eventJobJedge: widget.eventJobJedge,
                        sort: sort,
                        sortType: sortType,
                        store: store),
              ));
        }
      });
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 135),
          child: Center(
            child: Column(
              children: [
                //高さ調整(一番上の空間)
                SizedBox(
                  height: mediaQueryData.size.height / 20,
                ),
                //検索バー
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 45, //検索バーの高さ,
                      width: mediaQueryData.size.width *
                          widthPower *
                          0.95, //検索バーの幅
                      child: TextField(
                        cursorColor: store.mainColor, //カーソルの色
                        controller: _controller,
                        //検索バーの装飾
                        decoration: InputDecoration(
                          //背景色
                          fillColor: store.thinColor,
                          filled: true,
                          hintText: "   キーワードで検索",
                          hintStyle: TextStyle(color: store.blackColor),
                          //選択時の動作
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), //角丸
                            borderSide: BorderSide(
                              color: store.thinColor,
                            ),
                          ),
                          //未選択時の動作
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30), //角丸
                              borderSide: BorderSide(
                                color: store.thinColor,
                              )),

                          //検索バーアイコン
                          prefixIcon:
                              Icon(Icons.search, color: store.blackColor),
                          //消去アイコン
                          suffixIcon: IconButton(
                            onPressed: () {
                              _controller.clear(); //検索バーの文字を消去
                            },
                            icon: Icon(Icons.clear, color: store.blackColor),
                          ),
                          isDense: true,
                        ),
                        //検索ボタンを押したときの処理
                        //上に記述
                        onSubmitted: (text) => _submission(text),
                      ),
                    ),
                  ],
                ),
                //高さ調整
                SizedBox(
                  height: mediaQueryData.size.height / 40,
                ),

                //タイトルバー
                Expanded(
                  child: Container(
                      width: mediaQueryData.size.width,
                      color: store.mainColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   //右寄せ
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     Container(
                          //       constraints: BoxConstraints(
                          //         maxWidth: mediaQueryData.size.width / 2,
                          //       ),
                          //       child: Text(
                          //         "検索結果　:　${widget.text}",
                          //         overflow: TextOverflow.ellipsis,
                          //         maxLines: 1,
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 15,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          Row(
                            children: [
                              const Text("      検索結果  :  「",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17)),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: mediaQueryData.size.width / 4,
                                ),
                                child: Text(widget.text,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17)),
                              ),
                              const Text(
                                "」",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            ],
                          ),

                          //並べ替え
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                child: Row(
                                  //右寄せ
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    const Icon(Icons.sort,
                                        color: Colors.white, size: 25),
                                    Text(
                                      sort,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  showModalBottomSheet<int>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                                leading:
                                                    const Icon(Icons.schedule),
                                                title: const Text('新着順'),
                                                onTap: () => {
                                                      Navigator.pop(context, 0),
                                                      changeSort("新着順"),
                                                    }),
                                            ListTile(
                                                leading:
                                                    const Icon(Icons.schedule),
                                                title: const Text('開催期間順'),
                                                onTap: () => {
                                                      Navigator.pop(context, 1),
                                                      changeSort("開催期間順"),
                                                    }),
                                            ListTile(
                                                leading:
                                                    const Icon(Icons.favorite),
                                                title: const Text('いいね数順'),
                                                onTap: () => {
                                                      Navigator.pop(context, 2),
                                                      changeSort("いいね数順"),
                                                    }),
                                            ListTile(
                                                leading: const Icon(Icons.star),
                                                title: const Text('レビュー順'),
                                                onTap: () => {
                                                      Navigator.pop(context, 2),
                                                      changeSort("レビュー順"),
                                                    }),
                                            ListTile(
                                                leading: const Icon(Icons.star),
                                                title: const Text('閲覧数順'),
                                                onTap: () => {
                                                      Navigator.pop(context, 2),
                                                      changeSort("閲覧数順"),
                                                    }),
                                          ],
                                        ));
                                      });
                                }),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        body: ShaderMaskComponent(
          child: Column(
            children: [
              if (widget.eventJobJedge == "おすすめイベント")
                EventAdvertisementList(
                  advertisementList: eventList,
                  mediaQueryData: mediaQueryData,
                  notPostJedge: false,
                  functionCall: () => getEventList(store),
                )
              else if (widget.eventJobJedge == "おすすめ求人")
                JobAdvertisementList(
                  advertisementList: jobList,
                  mediaQueryData: mediaQueryData,
                  notPostJedge: false,
                  functionCall: () => getJobList(store),
                )
            ],
          ),
        ));
  }
}
