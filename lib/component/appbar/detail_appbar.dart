//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import '../../page/mypage/impression.dart';
import '../../page/Job/post_mem_list.dart';
import 'package:reelproject/overlay/rule/screen/delete_conf.dart';
import 'package:reelproject/overlay/rule/screen/job_app.dart';

class DetailAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DetailAppbar({
    super.key,
    required this.postJedge,
    required this.eventJobJedge,
    required this.postTerm,
    required this.mediaQueryData,
  });

  final bool postJedge;
  final String eventJobJedge;
  final String postTerm;
  final MediaQueryData mediaQueryData;

  static Color greyColor = Colors.grey[500]!;

  @override
  Size get preferredSize {
    return const Size(double.infinity, 50.0);
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return Scaffold(
      //アップバー
      appBar: AppBar(
        backgroundColor: Colors.white, //背景
        iconTheme: IconThemeData(color: store.greyColor), //戻るボタン
        centerTitle: true, //中央揃え
        toolbarHeight: 50, //アップバーの高さ
        actions: [
          if (postJedge)
            SizedBox(
              child: Row(
                children: [
                  TextButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '投稿詳細(投稿者限定) ',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                          Icon(Icons.menu, color: Colors.grey[700], size: 30),
                        ],
                      ),
                      onPressed: () {
                        //投稿したユーザーである場合表示
                        showModalBottomSheet<int>(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      width: mediaQueryData.size.width * 10,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: greyColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text("投稿情報")),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: greyColor,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      //右側の矢印アイコン
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: greyColor,
                                      ),
                                      tileColor: Colors.white, //背景
                                      leading:
                                          const Icon(Icons.signal_cellular_alt),
                                      title: const Text('インプレッション'),
                                      onTap: () {
                                        Navigator.of(context).pop(1);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Impressions(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (eventJobJedge == "job")
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: greyColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        //右側の矢印アイコン
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: greyColor,
                                        ),
                                        tileColor: Colors.white, //背景
                                        leading: const Icon(Icons.fact_check),
                                        title: const Text('応募者確認'),
                                        onTap: () => {
                                          Navigator.of(context).pop(2),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PostMemList(),
                                            ),
                                          ),
                                        },
                                      ),
                                    ),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      width: mediaQueryData.size.width * 10,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: greyColor,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: const Text("投稿内容編集・削除")),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: greyColor,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      //右側の矢印アイコン
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: greyColor,
                                      ),
                                      tileColor: Colors.white, //背景
                                      leading: const Icon(Icons.edit),
                                      title: const Text('投稿内容編集'),
                                      onTap: () => Navigator.of(context).pop(3),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: greyColor,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      //右側の矢印アイコン
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: greyColor,
                                      ),
                                      tileColor: Colors.white, //背景
                                      leading: const Icon(Icons.delete),
                                      title: const Text('投稿削除'),
                                      onTap: () => {
                                        //Navigator.of(context).pop(3),
                                        DeleteConf().show(context: context)
                                      },
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    color: Colors.white,
                                    width: mediaQueryData.size.width * 10,
                                    height: 40,
                                    child: Text("投稿期間 : $postTerm まで"),
                                  ),
                                ],
                              ));
                            });
                      }),
                ],
              ),
            )
          //応募ボタン
          else
            Row(
              children: [
                SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // print('Button pressed!');
                        JobApp().show(
                          //これでおーばーれい表示
                          context: context,
                        );
                      },

                      //色
                      style: ElevatedButton.styleFrom(
                        backgroundColor: store.mainColor,
                        //onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text('求人に応募する'),
                    )),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
        ],
      ),
    );
  }
}
