import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/globalWidget.dart';

class SequenceLibarary extends StatefulWidget {
  const SequenceLibarary({super.key});

  @override
  State<SequenceLibarary> createState() => _SequenceLibararyState();
}

class _SequenceLibararyState extends State<SequenceLibarary> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: BaseAppBarMethod(context, "시퀀스 관리", () {
          Navigator.pop(context);
        }, null),
        body: TabBarView(children: [Text('data'), Text('data'), Text('data')]),
      ),
    );
  }
}
