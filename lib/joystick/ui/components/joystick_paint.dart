import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:userinterfaces/joystick/ui/views/joystick_view_model.dart';

class JoystickPaint extends ViewModelWidget<JoystickViewModel> {
  @override
  Widget build(BuildContext context, model) {
    return Center(
      child: Container(
        //color: Colors.white10,
        child: GestureDetector(
          onPanStart: model.onPanStart,
          onPanUpdate: model.onPanUpdate,
          onPanEnd: model.onPanEnd,
          child: CustomPaint(
            size: Size(150, 150),
            painter: JoystickPainter(
                model.joystickImage, model.joystickDelta, model.joystickAngle,model.isActive,model.widthTranslate,model.heightTranslate),
          ),
        ),
      ),
    );
  }
}

class JoystickPainter extends CustomPainter {
  final ui.Image image;
  Offset joystickDelta;
  double joystickAngle;
  List<Color> gradientColors = [
    Color(0xff525C71),
    Color(0xff31394D),
    Color(0xff0F131D),
  ];

  List<double> stops = [0, 0.3, 1];

  bool isActive;

  var heightTranslate;

  var widthTranslate;

  JoystickPainter(this.image, this.joystickDelta, this.joystickAngle,this.isActive,this.widthTranslate,this.heightTranslate);
  @override
  void paint(Canvas canvas, Size size) {
    drawOuterRing(canvas, size);
    drawInnerRing(canvas, size);
    drawShadowRing(canvas, size);
    drawThumbStick(canvas, size);
  }

  drawOuterRing(Canvas canvas, Size size) {
    double circleRadius = 125;
    Paint paint = Paint()..color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    paint.shader = ui.Gradient.linear(
      Offset(-circleRadius, -circleRadius),
      Offset(circleRadius, circleRadius),
      gradientColors,
      stops,
    );
    // TODO: implement paint
    print(size);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawCircle(Offset.zero, circleRadius, paint);
    canvas.restore();
  }

  drawInnerRing(Canvas canvas, Size size) {
    double circleRadius = 100;
    Paint paint = Paint()..color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 40;
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 1);
    paint.shader = ui.Gradient.linear(
      Offset(-circleRadius, -circleRadius),
      Offset(circleRadius, circleRadius),
      [
        Color(0xff0F131D),
        Color(0xff31394D),
        Color(0xff525C71),
      ],
      [0, .99, 1],
    );
    // TODO: implement paint
    print(size);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawCircle(Offset.zero, circleRadius, paint);
    canvas.restore();
  }

  drawShadowRing(Canvas canvas, Size size) {
    double circleRadius = 80;
    Paint paint = Paint()..color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    // TODO: implement paint

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset.zero, circleRadius, paint);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset.zero, circleRadius, paint);
    canvas.drawCircle(Offset.zero, circleRadius, paint);
    canvas.restore();
  }

  drawThumbStick(Canvas canvas, Size size) {
    double x = 15 * pi / 180;
    double y = 15 * pi / 180;
    double z = 30;

    double circleRadius = 60;
    Paint paint = Paint()..color = Colors.black;
    canvas.save();

    //print(widthTranslate);
    canvas.translate(
        size.width / 2 + (isActive ? widthTranslate:-widthTranslate), size.height / 2 + (isActive ? heightTranslate:-heightTranslate));
    Matrix4 matrix4 = Matrix4.identity()
      ..setEntry(3, 2, .001)
      ..rotateX(x)
      ..rotateY(y)
      ..rotateZ(z);
    //canvas.transform(matrix4.storage);

    canvas.drawImage(
        image,
        Offset(-image.width / 2.toDouble(), -image.height / 2.toDouble()),
        paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
