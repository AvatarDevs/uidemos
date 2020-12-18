import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:userinterfaces/joystick/ui/components/joystick_housing.dart';
import 'dart:math';

import 'package:userinterfaces/joystick/ui/components/joystick_paint.dart';
import 'package:userinterfaces/joystick/ui/views/joystick_view_model.dart';

class ColorIndicator extends ViewModelWidget<JoystickViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return CustomPaint(
      painter: ColorIndicatorPainter(
          model.joystickAngle, model.isActive, model.calculateCircleColor),
      child: Padding(
        padding: EdgeInsets.all(100),
        child: JoystickPaint(),
      ),
    );
  }
}

class ColorIndicatorPainter extends CustomPainter {
  int indicatorLightCount = 30;
  int coloredLightCount = 12;
  double radians;
  final bool paintGlow;
  Function callback;

  ColorIndicatorPainter(this.radians, this.paintGlow, this.callback);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;
    // TODO: implement paint
    for (int i = 0; i < indicatorLightCount; i++) {
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);

      double rotationForNumOfLights =
          mapRotationToCount(i, 0, indicatorLightCount, 0, 360) * (pi / 180);
      canvas.rotate(rotationForNumOfLights);
      //print("LIGHTS:"+(rotationForNumOfLights* (180 / pi)).toString());
      canvas.rotate(pi / 2);

      Offset offset = Offset(0, -180);

      canvas.drawCircle(offset, 4, paint..color = Colors.black);
      paint.color = callback(rotationForNumOfLights);
      paint
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, 5 * paint.color.opacity);
      canvas.drawCircle(offset, 4, paint);

      paint..maskFilter = null;
      canvas.drawCircle(offset, 4, paint);

      // if (paintGlow) {
      //   if (i < 6) {
      //     paint.color = Colors.green;

      //     canvas.drawCircle(
      //         offset,
      //         4,
      //         paint
      //           ..color = Colors.green.withOpacity(
      //             mapRotationToCount(i, 0, 6, 1, 0),
      //           ));

      //     paint
      //       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5 - i.toDouble());
      //     canvas.drawCircle(offset, 4, paint);
      //     paint..maskFilter = null;
      //   } else if (i > indicatorLightCount - 6) {
      //     paint.color = Colors.green;

      //     canvas.drawCircle(
      //         offset,
      //         4,
      //         paint
      //           ..color = Colors.green.withOpacity(
      //               mapRotationToCount(indicatorLightCount - i, 0, 6, 1, 0)));

      //     paint
      //       ..maskFilter = MaskFilter.blur(
      //           BlurStyle.normal, 5 - (indicatorLightCount - i).toDouble());
      //     canvas.drawCircle(offset, 4, paint);
      //     paint..maskFilter = null;
      //   }
      // }

      canvas.restore();
    }
  }

  double mapRotationToCount(
      int value, int low, int high, int angLow, int angHigh) {
    return (value - low) * (angHigh - angLow) / (high - low) + angLow;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
