import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  const BouncingButton({super.key});

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late double scale;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState

    animationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 100,
        ),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    scale = 1 - animationController.value;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              // onTap: _onTap,
              child: Transform.scale(
                scale: scale,
                child: animationButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget animationButton() {
    return Container(
      height: 70,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              blurRadius: 12,
              offset: Offset(0.0, 5.0),
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff33ccff),
                Color(0xffff99cc),
              ])),
      child: Center(
        child: Text(
          'Press',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    print("_onTapDown");
    animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    print("_onTapUp");
    animationController.reverse();
  }

  void _onTap() {
    print("_onTap");
    animationController.fling();
    print("_onTap before fling"); 
    // sleep(Duration(milliseconds: 1000));
    print("_onTap after fling");
    // animationController.reverse();
  }
}
