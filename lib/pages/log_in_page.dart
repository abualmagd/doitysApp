import 'package:doitys/data_api/auth.dart';
import 'package:doitys/data_api/user_controller.dart';
import 'package:doitys/pages/sign_up.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:get/get.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();
  String? _password;
  String? _email;
  var getController=Get.put(AuthorController());
  AuthUtil auth = AuthUtil();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, //make it false
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
            ),
            SingleChildScrollView(
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * .75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, right: 12, left: 12),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (value.isNotEmpty) {
                                    Pattern pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regex = new RegExp(pattern.toString());
                                    if (!regex.hasMatch(value))
                                      return 'Enter Valid Email';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _email = val;
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                minLines: 1,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: ('  email'),
                                  hintStyle: TextStyle(color: Colors.black),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, top: 10, right: 12, left: 12),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter the password';
                                  } else if (value.length < 8) {
                                    return 'password must not less than 8 number';
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  _password = val;
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                maxLines: 1,
                                minLines: 1,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    hintText: ('Password'),
                                    hintStyle: TextStyle(color: Colors.black),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () async {
                                  _formKey.currentState!.save();

                                  //rest password
                                },
                                child: Text('forget password?'))),
                      ),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Container(
                            width: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Colors.purple,
                            ),
                            child: TextButton(
                                onPressed: () async {
                                  // login in with fie base
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    showLoaderDialog(context);
                                    await auth
                                        .login(_email!, _password!)
                                        .then((value) async {
                                          if(value.user!=null){
                                        print(value.data!.persistSessionString);
                                        var _prefs =
                                            await SharedPreferences.getInstance();
                                        _prefs.setString(
                                            "session", value.data!.persistSessionString
                                        );
                                            _prefs.setString('email',_email!);
                                            _prefs.setString('password',_password!);
                                           Navigator.of(context).popUntil((route) => route.isFirst);

                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext _) {
                                                      return MyHomePage();
                                                    }));}
                                            else if(value.error!=null){

                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                            msg: value.error!.message.toString(),
                                            backgroundColor: Colors.red,
                                            timeInSecForIosWeb:
                                            1 * value.error!.message.toString().length,
                                            gravity: ToastGravity.CENTER,
                                          );}
                                    });
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            height: 45,
                            width: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SignUpPage()));
                              },
                              child: Text('Or Create New Account'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 85,
        width: 35,
        color: Colors.transparent,
        child: new Column(
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading..."),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
