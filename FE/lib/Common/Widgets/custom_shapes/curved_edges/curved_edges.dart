

import 'package:flutter/cupertino.dart';

class CustomCurvedEdges extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCure = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCure.dx, lastCure.dy);

    final secondfirstCurve = Offset(0, size.height - 20);
    final secondlastCure = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(secondfirstCurve.dx, secondfirstCurve.dy,
        secondlastCure.dx, secondlastCure.dy);

    final thirdfirstCurve = Offset(size.width, size.height - 20);
    final thirdlastCure = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdfirstCurve.dx, thirdfirstCurve.dy,
        thirdlastCure.dx, thirdlastCure.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return true;
  }
}