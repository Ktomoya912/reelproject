import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reelproject/app_router/app_router.dart';
import 'package:reelproject/page/login/new_menber_company.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reelproject/page/login/new_menber_general.dart';
import 'package:reelproject/page/login/ask_page.dart';
import 'package:reelproject/provider/change_general_corporation.dart';
import 'package:reelproject/page/login/pass_change.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント
import 'package:http/http.dart';
import 'dart:convert';
import 'package:reelproject/component/loading/show_loading_dialog.dart';
import 'package:reelproject/overlay/rule/screen/return_write.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    this.isObscure = true,
    required this.onVisibilityToggle,
  });
  final bool isObscure;
  final ValueChanged<bool> onVisibilityToggle;
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _autoLogin = false; // チェックボックスの状態を管理する変数
  late bool _isObscure;
  String name = ""; //ユーザー名
  String password = ''; //パスワード
  bool jedgeGC = false; //法人か個人かの判定
  bool isActive = false; //ボタンの活性化

  @override
  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);
    //WidgetsBinding.instance.addPostFrameCallback((_) => store.changeGC(true));

    //トークン取得
    Future getAccessToken(
        String username, String password, String apiUrl) async {
      Uri url = Uri.parse("$apiUrl/auth/token");
      try {
        //throw TimeoutException('タイムアウトしました');
        final response = await post(url,
                headers: {'content-type': 'application/x-www-form-urlencoded'},
                body: {'username': username, 'password': password})
            .timeout(const Duration(seconds: 10));
        final Map<String, dynamic> data = json.decode(response.body);
        if (response.statusCode == 200) {
          store.accessToken = data["access_token"];
          jedgeGC = true;

          isActive = data["user"]["is_active"];
          store.accessToken = data["access_token"]; //トークンをプロバイダに保存
          //トークンを保存
          if (_autoLogin) {
            // final SharedPreferences storage =
            //     await SharedPreferences.getInstance();
            // await storage.setString("ACCESS_TOKEN", data["access_token"]);
            //print("トークンを保存しました");
          }
        } else {
          jedgeGC = false;
          context.popRoute();
          ReturnWrite().show(context: context);
        }
      } on TimeoutException catch (e) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('エラー'),
                content: const Text('通信がタイムアウトしました。'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      } on Error catch (e) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('エラー'),
                content: const Text('通信に失敗しました。'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    }

    //ユーザーidを取得
    // Future<String> getUserId(String apiUrl) async {
    //   Uri url = Uri.parse("$apiUrl/users/me");
    //   final response = await get(url, headers: {'accept': 'application/json'});
    //   final Map<String, dynamic> data = json.decode(response.body);
    //   if (response.statusCode == 200) {
    //     return data["id"];
    //   } else {
    //     return "";
    //   }
    // }

    return Scaffold(
      appBar: LoginAppBar(store: store),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                'ログイン',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () async {
                  if (store.jedgeGC) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewMemberGeneral(
                              onVisibilityToggle: (isVisible) {})),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewMemberCompany(
                            onVisibilityToggle: (isVisible) {}),
                      ),
                    );
                  }
                },
                splashColor: Colors.transparent,
                child: const Text(
                  '新規会員登録はこちら',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'ユーザー名',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      maxLength: 20,
                      textAlign: TextAlign.start,
                      onChanged: (text) {
                        //入力されたテキストを受け取る
                        name = text;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: '英数字と_のみ使用可能',
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'パスワード',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      onChanged: (text) {
                        password = text;
                      },
                      maxLength: 20,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        counterText: '',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                              widget.onVisibilityToggle(_isObscure);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Checkbox(
                  //       value: _autoLogin,
                  //       onChanged: (bool? value) {
                  //         setState(() {
                  //           _autoLogin = value ?? false;
                  //         });
                  //       },
                  //     ),
                  //     const Text(
                  //       '次回から自動でログインする',
                  //       style: TextStyle(fontSize: 15),
                  //     ),
                  //   ],
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      //context.navigateTo(const RootRoute()),
                      showLoadingDialog(context: context); //ここでローディング画面を表示
                      await getAccessToken(name, password,
                          ChangeGeneralCorporation.apiUrl); //ここでログイン処理
                      await Future.delayed(const Duration(seconds: 1)); //1秒待つ

                      if (jedgeGC) {
                        //ログイン成功
                        if (!isActive) {
                          //本登録が完了していない場合
                          Navigator.pop(context); //ローディング画面を閉じる
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('確認'),
                                  content:
                                      const Text('本登録が完了していません。メールをご確認ください。'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          //本登録が完了している場合
                          await store.getMyUserInfo(); //ここで自分のユーザ情報を取得
                          context.popRoute();
                          context.pushRoute(const RootRoute());
                        }
                      } else {
                        //ログイン失敗
                        // context.popRoute();
                        // ReturnWrite().show(context: context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: store.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(300, 50),
                    ),
                    child: const Text('ログイン'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PassChange(
                              loginJedge: true,
                            )),
                  );
                },
                splashColor: Colors.transparent,
                child: const Text(
                  'パスワードを忘れた方はこちら',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // builder: (context) => const ForgotPasswordPage()),
                        builder: (context) => const AskPage(
                              loginJedge: true,
                              buttonTex: 'ログイン画面に戻る',
                              popTimes: 0,
                            )),
                  );
                },
                splashColor: Colors.transparent,
                child: const Text(
                  'お問い合わせはこちら',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: store.mainColor,
        height: 40,
        child: const Text(
          '© 2023 REEL',
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({
    super.key,
    required this.store,
  });

  final ChangeGeneralCorporation store;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //アップバータイトル
      title: Text(
        "REEL", //文字
        style: GoogleFonts.secularOne(
            //fontWeight: FontWeight.bold,
            fontSize: 44,
            color: Colors.white), //書体
      ),
      backgroundColor: store.mainColor, //背景
      iconTheme: const IconThemeData(color: Colors.grey), //戻るボタン
      centerTitle: true, //中央揃え
      toolbarHeight: 80, //アップバーの高さ
      automaticallyImplyLeading: false,
    );
  }
}
