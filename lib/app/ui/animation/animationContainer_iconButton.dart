import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/app/data/model/color.dart';

class AnimationContainerIconButton extends StatelessWidget {
  final onPressed;
  final bool isButtonPressed;
  const AnimationContainerIconButton(
      {required this.onPressed, required this.isButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: IconButton(
        onPressed: onPressed,
        icon: !isButtonPressed
            ? Icon(Icons.open_in_full)
            : Icon(Icons.close_fullscreen, color: Color.fromARGB(96, 19, 18, 18),),
      ),
      decoration: BoxDecoration(
        color: Palette.mainBackground,
        border: Border.all(
          color: !isButtonPressed ? Palette.mainBackground : Palette.secondaryBackground,
        ), 
        boxShadow: !isButtonPressed ? [

        ]:[

          /// darker shadow on bottom right
          BoxShadow(
            color: Colors.grey.shade500,
            offset: Offset(6, 6),
            blurRadius: 15,
            spreadRadius: 1
          ),
          /// lighter shdow on top left
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 15,
            spreadRadius: 1
          ),
        ]
      ),
    );
  }
}
