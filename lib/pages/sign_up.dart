
import 'package:doitys/data_api/auth.dart';
import 'package:doitys/pages/complete_profile.dart';
import 'package:flutter/material.dart';



import 'log_in_page.dart';
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  AuthUtil auth = AuthUtil();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                    topRight: Radius.circular(35),),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),),
                      color:Theme.of(context).backgroundColor,
                    ),
                    height:  MediaQuery.of(context).size.height * .75,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                              color: Colors.black,
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
                                padding:
                                    const EdgeInsets.only(top: 10, right: 12, left: 12),
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
                                    hintText: ('Email '),
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
                                    top: 6, right: 12, left: 12, bottom: 8),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "please enter your password";
                                    } else if (val.length < 8) {
                                      return "please enter 8 digits";
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
                        Container(
                          height: 20,
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
                                    if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        showLoaderDialog(context);
                                       await auth
                                            .signUp(
                                                _email!,
                                                _password!).then((response) {
                                       Navigator.pop(context);


                                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>CompleteProfile()));


                                     });

                                      } else {
                                        print('error');
                                      }
                                    },

                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500),
                                  )),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Or You Have Already Account '),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                              child:  TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) => LoginPage()));
                                },
                                child: Text('Sign in instead'),
                              ),
                            ),
                          ),
                        ),
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
