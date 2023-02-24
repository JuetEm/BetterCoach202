import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/actionInfo.dart';

class ImportSequenceFromSaved extends StatefulWidget {
  const ImportSequenceFromSaved({super.key});

  @override
  State<ImportSequenceFromSaved> createState() =>
      _ImportSequenceFromSavedState();
}

class _ImportSequenceFromSavedState extends State<ImportSequenceFromSaved> {
  Function customFunctionOnTap = () {};

  List<Map> actionList = [
    {
      'actionName': 'Dancing',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 1,
      'selected': false,
    },
    {
      'actionName': 'Machine',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 2,
      'selected': false,
    },
    {
      'actionName': 'Abs Training',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 3,
      'selected': false,
    },
    {
      'actionName': 'Push Up',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 4,
      'selected': false,
    },
    {
      'actionName': 'Back Spine Blow',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 5,
      'selected': false,
    },
    {
      'actionName': 'Dancing',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 6,
      'selected': false,
    },
    {
      'actionName': 'Machine',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 7,
      'selected': false,
    },
    {
      'actionName': 'Abs Training',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 8,
      'selected': false,
    },
    {
      'actionName': 'Push Up',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 9,
      'selected': false,
    },
    {
      'actionName': 'Back Spine Blow',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 10,
      'selected': false,
    },
    {
      'actionName': 'Dancing',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 11,
      'selected': false,
    },
    {
      'actionName': 'Machine',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 12,
      'selected': false,
    },
    {
      'actionName': 'Abs Training',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 13,
      'selected': false,
    },
    {
      'actionName': 'Push Up',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 14,
      'selected': false,
    },
    {
      'actionName': 'Back Spine Blow',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 15,
      'selected': false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBarMethod(context, "시퀀스 불러오기", null, null, null),
      body: Column(
        children: [
          /// 헤더
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(children: [
              Text(
                '시퀀스 제목',
                style: TextStyle(
                    fontSize: 20,
                    color: Palette.gray00,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text('편집',
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.textBlue,
                  ))
            ]),
          ),

          /// 리스트들이 뿌려지는 영역
          Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final movedActionList = actionList.removeAt(oldIndex);
                actionList.insert(newIndex, movedActionList);

                setState(() {});
              },
              physics: BouncingScrollPhysics(),
              itemCount: actionList.length,
              itemBuilder: (context, index) {
                Key? valueKey;
                valueKey = ValueKey(actionList[index]['index']);

                return ActionListTile(
                  key: valueKey,
                  isSelectable: true,
                  actionList: actionList,
                  customFunctionOnTap: () {
                    setState(() {});
                  },
                  isDraggable: true,
                  index: index,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ActionListTile extends StatefulWidget {
  const ActionListTile({
    super.key,
    required this.isSelectable,
    required this.actionList,
    required this.customFunctionOnTap,
    required this.isDraggable,
    required this.index,
  });

  final bool isSelectable;
  final List<Map> actionList;
  final Function customFunctionOnTap;

  final bool isDraggable;
  final int index;

  @override
  State<ActionListTile> createState() => _ActionListTileState();
}

class _ActionListTileState extends State<ActionListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: widget.isSelectable
          ? widget.actionList[widget.index]['selected']
          : false,
      onTap: () {
        widget.actionList[widget.index]['selected'] =
            !widget.actionList[widget.index]['selected'];
        widget.customFunctionOnTap();
      },
      selectedColor: Palette.gray66,
      selectedTileColor: Palette.titleOrange,
      shape: RoundedRectangleBorder(
          // side: BorderSide(color: Palette.grayEE, width: 1),
          ),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      tileColor: Palette.mainBackground,
      visualDensity: VisualDensity(vertical: -4),
      title: Text(
        '${widget.actionList[widget.index]['actionName']}',
        style: TextStyle(fontSize: 14, color: Palette.gray00),
      ),
      subtitle: Row(
        children: [
          Text(
            '${widget.actionList[widget.index]['apparatus']}',
            style: TextStyle(fontSize: 12, color: Palette.gray99),
          ),
          SizedBox(width: 6),
          Text(
            '${widget.actionList[widget.index]['position']}',
            style: TextStyle(fontSize: 12, color: Palette.gray99),
          )
        ],
      ),
      trailing: widget.isDraggable ? Icon(Icons.drag_handle) : null,
    );
  }
}
