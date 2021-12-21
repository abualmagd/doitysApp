

import 'package:doitys/pages/splash.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'formates/theme.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var prefs=await SharedPreferences.getInstance();
  bool  isDark =prefs.getBool('isDark')??false;
  await dotenv.load(fileName: "api.env");
final  String url=dotenv.get('url');
 final String ap=dotenv.get('ap');
  Get.put<SupabaseClient>(SupabaseClient(url, ap,autoRefreshToken:true));
  runApp(
      MyApp(isDark:isDark,),
     );
}

class MyApp extends StatelessWidget{

  final bool isDark;
  const MyApp({Key? key, required this.isDark}) : super(key: key);
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    /*SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      //  systemNavigationBarColor:Theme.of(context).primaryColor,
      ),
    );*/
    return GetMaterialApp(
      title: 'Doitys',
      debugShowCheckedModeBanner: false,
      theme:isDark?Themes.dark :Themes.light,
      darkTheme:Themes.dark,
      home:Builder(
        builder: (context){
          return AnnotatedRegion<SystemUiOverlayStyle>(
              value:      SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor:Theme.of(context).primaryColor,
              ),
              child: const SplashPage());
        },
      ),
    );

  }
}

