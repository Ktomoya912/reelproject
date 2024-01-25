import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/app_router/app_router.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//ルートディレクトリ(reelproject/.env)に
//以下のような.envファイルを作成してください
//--------------------------
//ACCESS_TOKEN=token
//SKIP_LOGIN=true
//--------------------------
//作成していない場合は、以下のようなエラーが出ます
//Unhandled Exception: dotenv_missing
//dotenv_missing: .envファイルが見つかりませんでした。
//自動ログインをなくしたい場合は、41行目のコメントアウトを外してホットリロード*2してください

//change_root_page.dartを変更することで、遷移先を変更できる
//ユーザ情報を取得することを忘れずに
void main() async {
  await dotenv.load(fileName: ".env");
  print('test');
  // await getToken();
  setUrlStrategy(PathUrlStrategy());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChangeGeneralCorporation(),
      child: MyApp(),
    ),
  );
}

Future getToken() async {
  //プロバイダーの外にあるため、プロバイダーを使用することはできない
  final prefs = await SharedPreferences.getInstance();
  //シュミレーター等で実行している場合は、アプリを再起動するとtokenが消える
  //しかし、実機で実行している場合は、アプリを再起動してもtokenは消えない
  final String token = prefs.getString('ACCESS_TOKEN') ?? 'null';
  //prefs.remove('ACCESS_TOKEN'); //tokenを削除する場合はコメントアウトを外す
  if (token.contains('.')) {
    if (await isTokenExpired(token)) {
      prefs.remove('ACCESS_TOKEN');
    }
  }

  if (token != 'null') {
    dotenv.env['SKIP_LOGIN'] = "true"; //Stringしか入らない
    dotenv.env['ACCESS_TOKEN'] = token; //環境変数にtokenを保存し、プロバイダーに渡す
    print(dotenv.env['SKIP_LOGIN']);
    print("ローカルに保存しているtoken");
  } else {
    dotenv.env['SKIP_LOGIN'] = "false"; //Stringしか入らない
    print("未ログイン");
  }
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ChangeGeneralCorporation>(context);

    //_init();

    return ChangeNotifierProvider(
        create: (context) => ChangeGeneralCorporation(),
        child: Builder(builder: (BuildContext context) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false, // ここでDebugバナーを非表示にします
            title: 'REEL',
            theme: ThemeData(
              canvasColor: Colors.white, // ここでcanvasColorを設定します
              useMaterial3: false,
              //フォント
              textTheme: GoogleFonts.mPlus1pTextTheme(
                Theme.of(context).textTheme,
              ),

              primarySwatch: Colors.blue,
            ),
            routerConfig: _appRouter.config(), //auto_route
          );
        }));
  }
}

//tokenをデコードする関数
Map<String, dynamic> decodeToken(String token) {
  final parts = token.split('.');

  if (parts.length > 1) {
    final payload = parts[1];
    String normalizedPayload = payload;
    while (normalizedPayload.length % 4 != 0) {
      normalizedPayload += '=';
    }
    return json.decode(utf8.decode(base64Url.decode(normalizedPayload)));
  } else {
    throw const FormatException('Invalid token');
  }
}

//tokenの有効期限を取得する関数
DateTime? getTokenExpiration(String token) {
  final decodedToken = decodeToken(token);
  if (decodedToken.containsKey('exp')) {
    return DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
  } else {
    // 有効期限が含まれていない場合、nullなどを返す
    return null;
  }
}

//tokenの有効期限が切れているかどうかを判定する関数
Future<bool> isTokenExpired(String token) async {
  final expiration = getTokenExpiration(token);
  if (expiration != null) {
    print(expiration);
    return DateTime.now().isAfter(expiration);
  } else {
    // 有効期限が含まれていない場合は期限切れとみなさない
    return false;
  }
}
