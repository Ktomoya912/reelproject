import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  const Review({
    super.key,
    required this.width,
    required this.eventDetailList,
  });

  final double width;
  final Map<String, dynamic> eventDetailList;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width - 20,
        //height: 400,
        //color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 子ウィジェットを左詰めに配置
          children: [
            //タイトル
            const Text(
              "評価とレビュー",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: width / 20), //空白

            Row(
              children: [
                SizedBox(width: width / 15), //空白
                //平均評価
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${eventDetailList["reviewPoint"].toString()} ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: width / 8,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, //下線
                        decorationThickness: 2, // 下線の太さの設定
                      ),
                    ),
                    Text(
                      " 5段階評価中",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: width / 35,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                SizedBox(width: width / 9), //空白

                //評価分布
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 4; i >= 0; i--)
                      Row(
                        children: [
                          Text(
                            "${i + 1} ",
                            style: TextStyle(
                              fontSize: width / 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Stack(children: [
                            Container(
                              height: width / 40,
                              width: width / 2,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              height: width / 40,
                              width: width /
                                  2 *
                                  eventDetailList["ratioStarReviews"][i],
                              decoration: BoxDecoration(
                                color: Colors.yellow[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          ])
                        ],
                      ),
                    Text("${eventDetailList["reviewNumber"]}件のレビュー")
                  ],
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextButton(
                  child: Text('タップして評価    ★★★★★',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: width / 25,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {},
                ),
              ),
            ),

            TextButton(
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.edit_square,
                      color: Colors.yellow[800],
                    )), //引数「child」で表示するアイコンを指定
                    TextSpan(
                        text: '  レビューを書く',
                        style: TextStyle(
                            color: Colors.yellow[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ),
              ),
              onPressed: () {},
            ),

            SizedBox(height: width / 20), //空白

            //仕切り線
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[400]!, //枠線の色
                    width: 2, //枠線の太さ
                  ),
                ),
              ),
            ),

            //レビューがない場合
            if (eventDetailList["review"].length == 0)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text("レビューはまだありません"),
                ),
              ),

            //レビュー本体
            SizedBox(
              height: (160 * eventDetailList["review"].length).toDouble(),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 130, //最小の高さ
                        ),
                        child: Container(
                          //height: 150,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[400]!, //枠線の色
                                width: 2, //枠線の太さ
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //ユーザー情報
                              Row(
                                children: [
                                  //ユーザー画像
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  SizedBox(width: width / 50), //空白
                                  //ユーザー名
                                  Text(eventDetailList["review"][index]
                                      ["reviewerName"]),
                                ],
                              ),
                              SizedBox(height: width / 60), //空白
                              //評価
                              Row(
                                children: [
                                  //星(色あり)
                                  for (int i = 0;
                                      i <
                                          eventDetailList["review"][index]
                                              ["reviewPoint"];
                                      i++)
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow[800],
                                      size: 15,
                                    ),
                                  //星(色なし)
                                  for (int i = 0;
                                      i <
                                          5 -
                                              eventDetailList["review"][index]
                                                  ["reviewPoint"];
                                      i++)
                                    Icon(Icons.star,
                                        color: Colors.grey[400], size: 15),
                                  SizedBox(width: width / 60), //空白
                                  //評価日時
                                  Text(
                                      eventDetailList["review"][index]
                                              ["reviewDate"]
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[500])),
                                ],
                              ),
                              SizedBox(height: width / 60), //空白
                              //レビュー内容
                              Text(eventDetailList["review"][index]
                                  ["reviewDetail"]),
                            ],
                          ),
                        ),
                      ));
                },
                itemCount: eventDetailList["review"].length,
              ),
            ),
          ],
        ));
  }
}
