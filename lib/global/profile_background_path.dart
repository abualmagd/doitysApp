


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurvedGround extends StatelessWidget {
  final height;
  final width;
  final color;
  const CurvedGround({required Key key, this.height, this.width,this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: width,
        height: height,
        color: color,
      ),
      clipper: CustomClipPath(),
    );

  }
}
class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 100, size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}