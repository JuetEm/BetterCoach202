import 'package:flutter/material.dart';

class ActionAdd extends StatefulWidget {
  const ActionAdd({super.key});

  @override
  State<ActionAdd> createState() => _ActionAddState();
}

class _ActionAddState extends State<ActionAdd> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text("신규 동작 추가"),
    ));
  }
}
