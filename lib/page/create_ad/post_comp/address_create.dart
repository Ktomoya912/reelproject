// import 'package:flutter/material.dart';

// //使い方
// //ファイルの上部でimport 'comentBox.dart';と置く
// //その後、body内で"const ComentBox();"のように宣言

// class AddressCreate extends StatefulWidget {
//   const AddressCreate({
//     super.key,
//   });

//   @override
//   AddressCreateState createState() => AddressCreateState();
// }

// class AddressCreateState extends StatelessWidget {
//   final double boxWidth;
//   final double boxHeight;
//   // final int lenMax;//保留
//   // static int leax = 30;

//   const AddressCreate({
//     super.key,
//     required this.boxWidth,
//     required this.boxHeight,
//     // required this.lenMax,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         SizedBox(
//                 width: 350,
//                 child: Text(
//                   '開催場所設定',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               // 郵便番号
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Text(
//                   '郵便番号',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 60,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 3,
//                         onChanged: (value) {
//                           setState(() {
//                             firstNumber = value;
//                           });
//                         },
//                         style: TextStyle(fontSize: 13),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     Text(
//                       " - ",
//                       style: TextStyle(fontSize: 30),
//                     ),
//                     Container(
//                       width: 80,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         textAlign: TextAlign.center,
//                         maxLines: null,
//                         maxLength: 4,
//                         onChanged: (value) {
//                           setState(() {
//                             backNumber = value;
//                           });
//                         },
//                         style: TextStyle(fontSize: 13),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),

//                     // 住所検索ボタン
//                     ElevatedButton(
//                       child: Text(
//                         '住所を検索',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () async {
//                         setState(() {
//                           addressNum =
//                               "$firstNumber$backNumber"; // APIに送る用のアドレス
//                           posAddressNum =
//                               "$firstNumber-$backNumber"; // 確認画面へと送る(mapに入る)用のアドレス
//                         });

//                         if (addressNum.length != 7) {
//                           // アドレスが７文字であるかの判定
//                           return;
//                         }
//                         final address = await zipCodeToAddress(addressNum);
//                         // 返ってきた値がnullなら終了
//                         if (address == null) {
//                           return;
//                         }
//                         // 住所が帰ってきたら、addressListの中身を上書きする。
//                         setState(() {
//                           prefecture.text = address[0];
//                           city.text = address[1];
//                           houseNumber.text = address[2];
//                           posPrefecture = prefecture.text;
//                           posCity = city.text;
//                           posHouseNumber = houseNumber.text;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               // 都道府県
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: 350,
//                 child: Text(
//                   '都道府県',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 200,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         maxLines: null,
//                         maxLength: 10,
//                         onChanged: (value) {
//                           setState(() {
//                             posPrefecture = value;
//                           });
//                         },
//                         style: TextStyle(fontSize: 13),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                         controller: prefecture,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // 市町村
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: 350,
//                 child: Text(
//                   '市町村',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 300,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: const Color.fromARGB(255, 203, 202, 202),
//                             width: 2),
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: TextField(
//                         maxLines: null,
//                         maxLength: 100,
//                         onChanged: (value) {
//                           setState(() {
//                             posCity = value;
//                           });
//                         },
//                         style: TextStyle(fontSize: 13),
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                         ),
//                         controller: city,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // 番地・建物名
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: 350,
//                 child: Text(
//                   '番地・建物名',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: 350,
//                 child: Container(
//                   width: 300,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         color: const Color.fromARGB(255, 203, 202, 202),
//                         width: 2),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: TextField(
//                     maxLines: null,
//                     maxLength: 200,
//                     onChanged: (value) {
//                       setState(() {
//                         posHouseNumber = value;
//                       });
//                     },
//                     style: TextStyle(fontSize: 13),
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       counterText: '', //maxLengthによる"0/100"の表示を消すための処理
//                     ),
//                     controller: houseNumber,
//                   ),
//                 ),
//               ),
//       ],
//     );
//   }
// }
