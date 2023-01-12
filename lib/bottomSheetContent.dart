import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class BottomSheetContent extends StatefulWidget {
  BottomSheetContent({
    super.key,
    Function? this.customEditFunction,
    Function? this.customDeleteFunction,
  });

  Function? customEditFunction;
  Function? customDeleteFunction;

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Center(
              child: Icon(Icons.remove_outlined),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          Expanded(
            child: ListView(children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text("수정"),
                onTap: () {
                  widget.customEditFunction!();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outlined,
                  color: Palette.statusRed,
                ),
                title: Text("삭제"),
                onTap: () {
                  widget.customDeleteFunction!();
                },
              )
            ]),
          ),
        ],
      ),
    );
  }
}
