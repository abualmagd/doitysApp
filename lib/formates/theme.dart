

import 'package:flutter/material.dart';

class Themes{
  var ck;
static final light=ThemeData.light().copyWith(
  primaryColor: Color(0xfff4f0db),
  backgroundColor: Colors.white,
  shadowColor: Colors.black,
   focusColor: Color(0xffdec19b),
);




static final dark=ThemeData.dark().copyWith(
  primaryColor: Colors.black,
  backgroundColor: Colors.black12,
  shadowColor: Colors.white,
  focusColor: Colors.white,
 /* inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black),
    hoverColor: Colors.black,

  )*/
);
}