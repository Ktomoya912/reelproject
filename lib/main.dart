import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '/provider/change_general_corporation.dart';
import 'package:reelproject/app_router/app_router.dart';
import 'package:google_fonts/google_fonts.dart'; //googleフォント
import 'package:shared_preferences/shared_preferences.dart';

//change_root_page.dartを変更することで、遷移先を変更できる
//ユーザ情報を取得することを忘れずに
void main() async {
  // print("ローカルに保存しているtoken");
  // print(token);
  //getEnvToken();
  await dotenv.load(fileName: ".env");
  print('test');
  await getToken(); //ここで宣言しなければchange_root_page.dartが先に実行される
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getToken();

    return ChangeNotifierProvider(
        create: (context) => ChangeGeneralCorporation(),
        child: Builder(builder: (BuildContext context) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
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
  //       });
  // }
}

Future getToken() async {
  //プロバイダーの外にあるため、プロバイダーを使用することはできない
  final prefs = await SharedPreferences.getInstance();
  //シュミレーター等で実行している場合は、アプリを再起動するとtokenが消える
  //しかし、実機で実行している場合は、アプリを再起動してもtokenは消えない
  final String token = prefs.getString('ACCESS_TOKEN') ?? 'null';
  // prefs.remove('ACCESS_TOKEN');//tokenを削除する場合はコメントアウトを外す

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
