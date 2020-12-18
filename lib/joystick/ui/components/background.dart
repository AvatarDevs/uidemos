import 'package:flutter/material.dart';

class JoystickBackground extends StatelessWidget {
  final Color backgroundColor = Color(0xff202635);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Container(
          color: backgroundColor,
        ),
      ),
      Positioned(
        top: -500,
        left: 100,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
           shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Color(0xff69738A).withAlpha(40),blurRadius: 500,spreadRadius: 400),
            ],
          ),
        ),
      )
    ]);
  }
}
