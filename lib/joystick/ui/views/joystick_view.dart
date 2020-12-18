import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:userinterfaces/joystick/ui/components/background.dart';
import 'package:userinterfaces/joystick/ui/components/joystick.dart';
import 'package:userinterfaces/joystick/ui/views/joystick_view_model.dart';

class JoystickView extends HookWidget  {
  @override
  Widget build(BuildContext context) {
    var controller = useAnimationController(duration: Duration(milliseconds: 500));
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => JoystickViewModel(controller,),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            JoystickBackground(),
            Joystick(),
          ],
        ),
      ),
    );
  }
}
