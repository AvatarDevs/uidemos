import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';

class JoystickViewModel extends BaseViewModel {
  Offset tapStartPosition = Offset.zero;
  Offset currentFingerPosition = Offset.zero;
  double joystickAngle = 0;
  // Offset joystickDelta = Offset.zero;
  bool isActive = false;
  AnimationController controller;

  ui.Image joystickImage;

  JoystickViewModel(this.controller) {
    initImage();
    controller
      ..addListener(() {
        notifyListeners();
      });
  }
  initImage() async {
    joystickImage = await loadJoystickImage();
  }

  void onPanUpdate(DragUpdateDetails details) {
    //  print("\n\n\nPan Update:");
    //  print(details.localPosition);
    currentFingerPosition = details.localPosition;

    isActive = true;
    calculateAngle();
    notifyListeners();
  }

  Offset get joystickDelta => (currentFingerPosition - tapStartPosition);

  void onPanStart(DragStartDetails details) {
    tapStartPosition = details.localPosition;
    // print(details.localPosition);
    controller.forward();
    notifyListeners();
  }

  calculateAngle() {
    var tan = ui.Tangent(
        Offset(75, 75),
        Offset(
          currentFingerPosition.dx - 75,
          currentFingerPosition.dy - 75,
        ));
    joystickAngle = -tan.angle;
    print(joystickAngle);
    //print(joystickAngle * (180 / pi));
  }

  void onPanEnd(DragEndDetails details) {
    // isActive = false;
    controller.reverse();

    notifyListeners();
  }

  double get widthTranslate =>
      joystickDelta.dx.abs().clamp(-70, 70) * cos(joystickAngle)*controller.value;
  double get heightTranslate =>
      joystickDelta.dy.abs().clamp(-70, 70) * sin(joystickAngle)*controller.value;

  Color calculateCircleColor(double currentCircleAngleInRadians) {
    double j = joystickAngle;
    double c = currentCircleAngleInRadians;
    if (isActive) {
      if (joystickAngle.isNegative) {
        j += 2 * pi;
      }
      // print(j * (180 / pi));

      double sumAngle = j + pi / 3;
      double subAngle = j - pi / 3;

//theres probably a more elegant way of doing this but this is the best i could hack together
      if (currentCircleAngleInRadians + 2 * pi < sumAngle) {
        return Colors.green.withOpacity(
            opacityForAngleDifference(currentCircleAngleInRadians + 2 * pi, j));
      } else if (currentCircleAngleInRadians - 2 * pi > subAngle) {
        return Colors.green.withOpacity(
            opacityForAngleDifference(currentCircleAngleInRadians - 2 * pi, j));
      }

      if (currentCircleAngleInRadians < sumAngle &&
          currentCircleAngleInRadians > subAngle) {
        return Colors.green.withOpacity(
            opacityForAngleDifference(currentCircleAngleInRadians, j));
      }
    }

    return Colors.black.withOpacity(0);
  }

  opacityForAngleDifference(double circleAngle, double joystickAngle) {
    double diff = ((circleAngle - joystickAngle) * 180 / pi).abs();
    // print(diff);

    if (diff < 10) {
      return 1.0 * controller.value;
    } else if (diff < 20) {
      return .7 * controller.value;
    } else if (diff < 30) {
      return .5 * controller.value;
    } else if (diff < 40) {
      return .3 * controller.value;
    } else {
      return .1 * controller.value;
    }
  }

  loadJoystickImage() async {
    ByteData bd = await rootBundle.load("assets/thumbstick.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}
