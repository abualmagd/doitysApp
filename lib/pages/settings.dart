import 'package:doitys/animations/routes.dart';
import 'package:doitys/data_api/auth.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/pages/bookmarks_page.dart';
import 'package:doitys/pages/log_in_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthUtil auth = AuthUtil();
    var getCon = Get.put(AuthorController());
    return Scaffold(
      backgroundColor: Color(0xffdec19b),
      appBar: AppBar(
        elevation: 00,
        centerTitle: true,
        title: Text("Settings", style: GoogleFonts.pacifico(),),
        backgroundColor: context.theme.primaryColor,
      ),
      body: Container(
        //height: 320,
          decoration: BoxDecoration(
            color: context.theme.canvasColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.transparent,
              child: ListView(
                children: [
                  InkWell(
                    onTap: () {
                      print('change user name');
                    },
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('UserName',
                              style: TextStyle(fontSize: 16),),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(getCon.currentAuthor.name.toString(), style: TextStyle(
                                  fontSize: 14, color: Colors.grey),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(

                        height: .5,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print('email');
                    },
                    child: Container(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Email',
                              style: TextStyle(fontSize: 16),),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(getCon.currentAuthor.email.toString(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(

                        height: .5,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //change country
                    },
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Country',
                              style: TextStyle(fontSize: 16),),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(getCon.currentAuthor.location.toString(), style: TextStyle(
                                  fontSize: 14, color: Colors.grey),),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(

                        height: .5,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //change password
                    },
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: const Text(
                          'Password', style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(

                        height: .5,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          rightSideSlideTransition(BookMarks()));
                    },
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: const Text(
                          'Bookmarks', style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(

                        height: .5,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("LogOut"),
                              content: Text("are you sure"),
                              actions: [
                                TextButton(onPressed: () {
                                  auth.logout().then((value) async {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginPage(),));
                                    var _prefs =
                                    await SharedPreferences.getInstance();
                                    _prefs.setString(
                                        "session", '');
                                    _prefs.setString('email', '');
                                    _prefs.setString('password', '');
                                  }).catchError(
                                          (r) {
                                        Fluttertoast.showToast(
                                          msg:' sorry '
                                              '\n something error please try again ',
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.red,
                                          gravity: ToastGravity.CENTER,
                                        );
                                      }
                                  );
                                }, child: Text("Yes")),
                                TextButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text("No")),

                              ],
                            );
                          }
                      );
                      //change password
                    },
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: const Text(
                          'Logout', style: TextStyle(fontSize: 18),),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(

                        height: .5,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
