import 'package:doitys/data_api/auth.dart';
import 'package:doitys/pages/complete_profile.dart';
import 'package:doitys/pages/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'home.dart';


class SplashPage extends StatefulWidget {

  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  var auth=AuthUtil();
  var _client;
 void initState() {


    _client=Get.find<SupabaseClient>();
    _redirect();
    super.initState();
  }

  Future<void>_redirect()async{
   Future.delayed(Duration(microseconds: 20));

    var _recoverd= await auth.recoverSession();

     if(_recoverd==false){

       print(' ////// 1  ////////');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext _){
          return LoginPage();
        }));
     } else if (_recoverd==true) {
       String? userId = _client.auth.currentUser!.id;
       final completeProfile = await auth.isProfileComplete(userId: userId);
       if (completeProfile == null) {
         print("2");
         Navigator.pushReplacement(
             context, MaterialPageRoute(builder: (BuildContext _) {
           return CompleteProfile();
         }));
       }

       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (BuildContext _) {
         return MyHomePage();
       }));
     }else{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext _){
         return LoginPage();
     }));
     }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
     color: Theme.of(context).primaryColor,
     /* decoration: BoxDecoration(
        image:DecorationImage(
          image: AssetImage('assets/images/sky.jpeg'),
          fit: BoxFit.fill
        )
      ),*/
      child: Center(child: CircularProgressIndicator(color: Colors.white,),),
    );
  }

}
