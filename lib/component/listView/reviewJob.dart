import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Review extends StatefulWidget {
  const Review({
    super.key,
    required this.width,
    required this.jobDetailList,
  });

  final double width;
  final Map<String, dynamic> jobDetailList;

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  int review_point = 1;
  String title = "";
  String detail = "";

  //タイトル入力時の処理
  void titleWrite(text) {
    setState(() {
      if (text != "") {
        title = text;
      }
    });
  }

  //詳細入力時の処理
  void detailWrite(text) {
    setState(() {
      if (text != "") {
        detail = text;
      }
    });
  }

  //レビュー
  Future reviewWrite(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse('http://localhost:8000/api/v1/jobs/${id}/review');
    final response = await post(url,
        headers: {
          'accept': 'application/json',

          //'Authorization': 'Bearer ${store.accessToken}'
          'authorization': 'Bearer ${store.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'review': detail,
          'review_point': review_point,
        }));
  }

  //レビュー削除
  Future reviewDelite(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        'http://localhost:8000/api/v1/jobs/${id}/review?user_id=${store.myID}');
    final response = await delete(url, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${store.accessToken}',
    });
  }

  //レビュー編集
  Future reviewEdit(int id, ChangeGeneralCorporation store) async {
    Uri url = Uri.parse(
        'http://localhost:8000/api/v1/jobs/${id}/review?user_id=${store.myID}');
    final response = await put(url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${store.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'review': detail,
          'review_point': review_point,
        }));
  }

  final List<bool> _isSelected = [
    true,
    false,
    false,
    false,
    false
  ]; //星の色を変えるための変数
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context); //プロバイダ
    return SizedBox(
        width: widget.width - 20,
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
            SizedBox(height: widget.width / 20), //空白

            Row(
              children: [
                SizedBox(width: widget.width / 15), //空白
                //平均評価
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.jobDetailList["reviewPoint"].toString()} ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: widget.width / 8,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, //下線
                        decorationThickness: 2, // 下線の太さの設定
                      ),
                    ),
                    Text(
                      " 5段階評価中",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: widget.width / 35,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),

                SizedBox(width: widget.width / 9), //空白

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
                              fontSize: widget.width / 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Stack(children: [
                            Container(
                              height: widget.width / 40,
                              width: widget.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              height: widget.width / 40,
                              width: widget.width /
                                  2 *
                                  widget.jobDetailList["ratioStarReviews"][i],
                              decoration: BoxDecoration(
                                color: Colors.yellow[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          ])
                        ],
                      ),
                    Text("${widget.jobDetailList["reviewNumber"]}件のレビュー")
                  ],
                ),
              ],
            ),
            SizedBox(height: widget.width / 20), //空白

            Center(
              child: TextButton(
                child: Text('タップして評価    ★★★★★',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: widget.width / 25,
                        fontWeight: FontWeight.bold)),
                //評価ポップアップ
                onPressed: () {
                  //_isSelected初期化
                  _isSelected[0] = true;
                  for (int buttonIndex = 1; buttonIndex < 5; buttonIndex++) {
                    _isSelected[buttonIndex] = false;
                  }
                  //投稿済み
                  if (widget.jobDetailList["reviewId"] != 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('投稿済みです'),
                          content: const Text('このイベント広告にはレビューを投稿済みです。'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('閉じる'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  //未投稿
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('評価を選択してください'),
                          content: SizedBox(
                            width: widget.width * 0.7,
                            height: 400,
                            child: Column(
                              children: [
                                Text("※レビューは一般公開され、あなたのアカウント情報が含まれます",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[600])),
                                //空白
                                SizedBox(height: widget.width / 40),
                                //動的に星の色を変える
                                StatefulBuilder(
                                  builder: (BuildContext context,
                                          StateSetter setState) =>
                                      ToggleButtons(
                                    fillColor: Colors.white, //選択中の色
                                    borderWidth: 0, //枠線の太さ
                                    borderColor: Colors.white, //枠線の色
                                    selectedBorderColor:
                                        Colors.white, //選択中の枠線の色,

                                    onPressed: (int index) {
                                      setState(() {
                                        review_point = index + 1;
                                        for (int buttonIndex = 0;
                                            buttonIndex <= index;
                                            buttonIndex++) {
                                          _isSelected[buttonIndex] = true;
                                        }
                                        for (int buttonIndex = index + 1;
                                            buttonIndex < 5;
                                            buttonIndex++) {
                                          _isSelected[buttonIndex] = false;
                                        }
                                      });
                                    },

                                    isSelected: _isSelected,
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        color: _isSelected[index]
                                            ? Colors.yellow[800]
                                            : Colors.grey,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                ),
                                //タイトル
                                SizedBox(height: widget.width / 40),
                                SizedBox(
                                  width: widget.width,
                                  child: const Text("タイトル",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                    width: widget.width,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 203, 202, 202),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          maxLines: null,
                                          maxLength: 50,
                                          style: const TextStyle(fontSize: 13),
                                          decoration: const InputDecoration(
                                            //counterText: '',
                                            border: InputBorder.none,
                                            hintText: 'ここに入力',
                                          ),
                                          onChanged: (text) => titleWrite(text),
                                        ),
                                      ),
                                    )),
                                //詳細
                                //空白
                                SizedBox(height: widget.width / 40),
                                SizedBox(
                                  width: widget.width,
                                  child: const Text("詳細",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                    width: widget.width,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 203, 202, 202),
                                          width: 1.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextField(
                                          maxLines: null,
                                          maxLength: 500,
                                          style: const TextStyle(fontSize: 13),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'ここに入力',
                                          ),
                                          onChanged: (text) =>
                                              detailWrite(text),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('投稿'),
                              onPressed: () {
                                //Navigator.of(context).pop();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('投稿確認'),
                                      content: const Text('この内容で投稿しますか？'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('投稿'),
                                          onPressed: () {
                                            reviewWrite(
                                                widget.jobDetailList["id"],
                                                store);
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('投稿完了'),
                                                  content:
                                                      const Text('投稿が完了しました'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('閉じる'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('キャンセル'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            TextButton(
                              child: const Text('閉じる'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),

            SizedBox(height: widget.width / 20), //空白

            //レビューがない場合
            if (widget.jobDetailList["review"].length == 0)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text("レビューはまだありません"),
                ),
              ),

            //仕切り線
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[400]!, //枠線の色
                      width: 0.7, //枠線の太さ
                    ),
                  ),
                ),
              ),
            ),

            //レビュー本体
            SizedBox(
              //height: (160 * jobDetailList["review"].length).toDouble(),
              child: Column(
                children: [
                  for (int index = 0;
                      index < widget.jobDetailList["review"].length;
                      index++)
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 150, //最小の高さ
                          ),
                          child: Container(
                            //height: 150,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[400]!, //枠線の色
                                  width: 0.7, //枠線の太さ
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //ユーザー情報
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //ユーザー画像
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        SizedBox(width: widget.width / 50), //空白
                                        //ユーザー名
                                        Text(widget.jobDetailList["review"]
                                            [index]["user"]["username"]),
                                      ],
                                    ),

                                    //通報ボタン===================================================================
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            for (int buttonIndex = 0;
                                                buttonIndex <=
                                                    widget.jobDetailList[
                                                                "review"][index]
                                                            ["review_point"] -
                                                        1;
                                                buttonIndex++) {
                                              _isSelected[buttonIndex] = true;
                                            }
                                          });
                                          final TextEditingController
                                              titleController =
                                              TextEditingController(
                                                  text: widget.jobDetailList[
                                                          "review"][index]
                                                      ["title"]);
                                          final TextEditingController
                                              detailController =
                                              TextEditingController(
                                                  text: widget.jobDetailList[
                                                          "review"][index]
                                                      ["review"]);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SimpleDialog(
                                                // title: const Text(
                                                //   "通報",
                                                //   style: TextStyle(
                                                //       fontWeight:
                                                //           FontWeight.bold),
                                                // ),
                                                children: [
                                                  if (widget.jobDetailList[
                                                              "review"][index]
                                                          ["user"]["id"] ==
                                                      store.myID)
                                                    Center(
                                                      child: SizedBox(
                                                        width: widget.width / 2,
                                                        child: const Text(
                                                          "編集・削除",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  if (widget.jobDetailList[
                                                              "review"][index]
                                                          ["user"]["id"] ==
                                                      store.myID)
                                                    SimpleDialogOption(
                                                      onPressed: () => {
                                                        Navigator.pop(context),
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  '評価を選択してください'),
                                                              content: SizedBox(
                                                                width: widget
                                                                        .width *
                                                                    0.7,
                                                                height: 400,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                        "※レビューは一般公開され、あなたのアカウント情報が含まれます",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.grey[600])),
                                                                    //空白
                                                                    SizedBox(
                                                                        height: widget.width /
                                                                            40),
                                                                    //動的に星の色を変える
                                                                    StatefulBuilder(
                                                                      builder: (BuildContext context,
                                                                              StateSetter setState) =>
                                                                          ToggleButtons(
                                                                        fillColor:
                                                                            Colors.white, //選択中の色
                                                                        borderWidth:
                                                                            0, //枠線の太さ
                                                                        borderColor:
                                                                            Colors.white, //枠線の色
                                                                        selectedBorderColor:
                                                                            Colors.white, //選択中の枠線の色,

                                                                        onPressed:
                                                                            (int
                                                                                index) {
                                                                          setState(
                                                                              () {
                                                                            review_point =
                                                                                index + 1;
                                                                            for (int buttonIndex = 0;
                                                                                buttonIndex <= index;
                                                                                buttonIndex++) {
                                                                              _isSelected[buttonIndex] = true;
                                                                            }
                                                                            for (int buttonIndex = index + 1;
                                                                                buttonIndex < 5;
                                                                                buttonIndex++) {
                                                                              _isSelected[buttonIndex] = false;
                                                                            }
                                                                          });
                                                                        },

                                                                        isSelected:
                                                                            _isSelected,
                                                                        children:
                                                                            List.generate(
                                                                          5,
                                                                          (index) =>
                                                                              Icon(
                                                                            Icons.star,
                                                                            color: _isSelected[index]
                                                                                ? Colors.yellow[800]
                                                                                : Colors.grey,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    //タイトル
                                                                    SizedBox(
                                                                        height: widget.width /
                                                                            40),
                                                                    SizedBox(
                                                                      width: widget
                                                                          .width,
                                                                      child: const Text(
                                                                          "タイトル",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold)),
                                                                    ),
                                                                    Container(
                                                                        width: widget
                                                                            .width,
                                                                        height:
                                                                            100,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: const Color.fromARGB(255, 203, 202, 202),
                                                                              width: 1.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                TextField(
                                                                              controller: titleController,
                                                                              maxLines: null,
                                                                              maxLength: 50,
                                                                              style: const TextStyle(fontSize: 13),
                                                                              decoration: const InputDecoration(
                                                                                //counterText: '',
                                                                                border: InputBorder.none,
                                                                                hintText: 'ここに入力',
                                                                              ),
                                                                              onChanged: (text) => titleWrite(text),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                    //詳細
                                                                    //空白
                                                                    SizedBox(
                                                                        height: widget.width /
                                                                            40),
                                                                    SizedBox(
                                                                      width: widget
                                                                          .width,
                                                                      child: const Text(
                                                                          "詳細",
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold)),
                                                                    ),
                                                                    Container(
                                                                        width: widget
                                                                            .width,
                                                                        height:
                                                                            100,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: const Color.fromARGB(255, 203, 202, 202),
                                                                              width: 1.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0),
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                TextField(
                                                                              controller: detailController,
                                                                              maxLines: null,
                                                                              maxLength: 500,
                                                                              style: const TextStyle(fontSize: 13),
                                                                              decoration: const InputDecoration(
                                                                                border: InputBorder.none,
                                                                                hintText: 'ここに入力',
                                                                              ),
                                                                              onChanged: (text) => detailWrite(text),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '編集'),
                                                                  onPressed:
                                                                      () {
                                                                    //Navigator.of(context).pop();

                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text('編集確認'),
                                                                          content:
                                                                              const Text('この内容で編集しますか？'),
                                                                          actions: <Widget>[
                                                                            TextButton(
                                                                              child: const Text('編集'),
                                                                              onPressed: () {
                                                                                reviewEdit(widget.jobDetailList["id"], store);
                                                                                Navigator.of(context).pop();
                                                                                Navigator.of(context).pop();
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: const Text('編集完了'),
                                                                                      content: const Text('編集が完了しました'),
                                                                                      actions: <Widget>[
                                                                                        TextButton(
                                                                                          child: const Text('閉じる'),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              child: const Text('キャンセル'),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '閉じる'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        )
                                                      },
                                                      child:
                                                          const Text("レビューを編集"),
                                                    ),
                                                  if (widget.jobDetailList[
                                                              "review"][index]
                                                          ["user"]["id"] ==
                                                      store.myID)
                                                    SimpleDialogOption(
                                                      onPressed: () => {
                                                        Navigator.pop(context),
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'レビュー削除'),
                                                              content: const Text(
                                                                  'レビューの削除をしました。'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '閉じる'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    reviewDelite(
                                                                        widget.jobDetailList[
                                                                            "id"],
                                                                        store);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        )
                                                      },
                                                      child:
                                                          const Text("レビューを削除"),
                                                    ),
                                                  Center(
                                                    child: SizedBox(
                                                      width: widget.width / 2,
                                                      child: const Text(
                                                        "通報",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed: () => {
                                                      Navigator.pop(context),
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                '通報完了'),
                                                            content: const Text(
                                                                '不適切なレビューとして報告が完了しました'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        '閉じる'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      )
                                                    },
                                                    child: const Text(
                                                        "不適切なレビューとして報告"),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed: () => {
                                                      Navigator.pop(context),
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                '通報完了'),
                                                            content: const Text(
                                                                'スパムとして報告が完了しました'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child:
                                                                    const Text(
                                                                        '閉じる'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      )
                                                    },
                                                    child:
                                                        const Text("スパムとして報告"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey[500],
                                        )),
                                  ],
                                ),
                                SizedBox(height: widget.width / 60), //空白
                                Text(
                                    widget.jobDetailList["review"][index]
                                        ["title"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: widget.width / 60), //空白
                                //評価
                                Row(
                                  children: [
                                    //星(色あり)
                                    for (int i = 0;
                                        i <
                                            widget.jobDetailList["review"]
                                                [index]["review_point"];
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
                                                widget.jobDetailList["review"]
                                                    [index]["review_point"];
                                        i++)
                                      Icon(Icons.star,
                                          color: Colors.grey[400], size: 15),
                                    SizedBox(width: widget.width / 60), //空白
                                    //評価日時放置
                                    Text(
                                        "${widget.jobDetailList["review"][index]["updated_at"].substring(0, 4)}年${widget.jobDetailList["review"][index]["updated_at"].substring(5, 7)}月${widget.jobDetailList["review"][index]["updated_at"].substring(8, 10)}日",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[500])),
                                  ],
                                ),
                                SizedBox(height: widget.width / 60), //空白
                                //レビュー内容
                                Text(widget.jobDetailList["review"][index]
                                    ["review"]),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
          ],
        ));
  }
}
