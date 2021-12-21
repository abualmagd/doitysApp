
import 'package:flutter/material.dart';


rightSideSlideTransition(var page){
  return PageRouteBuilder(pageBuilder:(context,animation,secondAnimation)=>page,
    transitionsBuilder: (context,animation,secondAnimation,child){
        var begin=const Offset(1, 00);
        var end=const Offset(00, 00);
        var curve=Curves.easeIn;
        var tween=Tween(begin: begin,end: end).chain(CurveTween(curve:curve));
        return SlideTransition(
            child: child,
            position: animation.drive(tween));
    }
  );
}

rightCornerSideSlideTransition(var page){
  return PageRouteBuilder(pageBuilder:(context,animation,secondAnimation)=>page,
      transitionsBuilder: (context,animation,secondAnimation,child){
        var begin=const Offset(1, 1);
        var end=const Offset(0, 0);
        var curve=Curves.easeIn;
        var tween=Tween(begin: begin,end: end).chain(CurveTween(curve:curve));
        return SlideTransition(
            child: child,
            position: animation.drive(tween));
      }
  );
}



bottomSideSlideTransition(var page){
  return PageRouteBuilder(pageBuilder:(context,animation,secondAnimation)=>page,
      transitionsBuilder: (context,animation,secondAnimation,child){
        var begin=const Offset(00, 1);
        var end=const Offset(00, 00);
        var curve=Curves.easeIn;
        var tween=Tween(begin: begin,end: end).chain(CurveTween(curve:curve));
        return SlideTransition(
            child: child,
            position: animation.drive(tween));
      }
  );
}