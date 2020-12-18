import 'package:flutter/material.dart';
import 'package:userinterfaces/joystick/ui/components/color_indicator_painter.dart';

class Joystick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 500,
        child: ColorIndicator(),
      ),
    );
  }
}