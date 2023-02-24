import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'color.dart';

class GrayInkwellButton extends StatefulWidget {
  const GrayInkwellButton({
    Key? key,
    required this.label,
    required this.customFunctionOnTap,
  }) : super(key: key);

  final String label;
  final Function customFunctionOnTap;

  @override
  State<GrayInkwellButton> createState() => _GrayInkwellButtonState();
}

class _GrayInkwellButtonState extends State<GrayInkwellButton> {
  bool _toggle = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Palette.grayEE,
        child: InkWell(
          onTapDown: (details) {
            setState(() {
              _toggle = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _toggle = false;
            });
          },
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            widget.customFunctionOnTap();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${widget.label}',
                style: TextStyle(fontSize: 14, color: Palette.gray66),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.add_circle_outline,
                color: Palette.gray66,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ).animate(target: _toggle ? 0.5 : 0).scaleXY(end: 0.9);
  }
}
