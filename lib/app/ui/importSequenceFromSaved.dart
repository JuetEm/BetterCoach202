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
  /// 더미 액션 리스트
  List<Map> actionList = [
    {
      'actionName': 'Dancing',
      'apparatus': 'CA',
      'position': 'prone',
      'index': 0,
      'selected': false,
    },
    {
      'actionName': 'Machine',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Abs Training',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Push Up',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Back Spine Blow',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Dancing',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Machine',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Abs Training',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Push Up',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Back Spine Blow',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Dancing',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Machine',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Abs Training',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Push Up',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    },
    {
      'actionName': 'Back Spine Blow',
      'apparatus': 'CA',
      'position': 'prone',
      'selected': false,
    }
  ];

  /// 이 화면에서는 필요 없는 변수들 -> 추후 actionSelector에 적용 후 삭제 예정
  /**선택된 동작 수 */
  int selectedCnt = 0;
  /**선택된 동작 리스트 -> 추후 돌려줄 것임 */
  List selectedActionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBarMethod(context, "시퀀스 불러오기", null, null, null),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
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
                  padding: EdgeInsets.only(bottom: 100),
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
                    actionList[index]['index'] = index;
                    valueKey = ValueKey(actionList[index]['index']);

                    return ActionListTile(
                      key: valueKey,
                      isSelectable: true,
                      isSelected: actionList[index]['selected'],
                      actionList: actionList,
                      customFunctionOnTap: () {
                        actionList[index]['selected'] =
                            !actionList[index]['selected'];

                        if (actionList[index]['selected']) {
                          selectedCnt++;
                        } else {
                          selectedCnt--;
                        }

                        print('####여기부터 봐라####');
                        print('seletedCnt: $selectedCnt');
                        print('index: $index');
                        print('actionList[index]: ${actionList[index]}');
                        print('actionList: $actionList');
                        print('selectedActionList: $selectedActionList');
                        print('####여기까지 봐라####');

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

          /// 불러오기 버튼을 아래쪽에 Stack
          Offstage(
            // offstage: selectedCnt == 0,
            offstage: false,
            child: Container(
              alignment: Alignment.center,
              height: 100,
              // color: Palette.gray00.withOpacity(0.3), -> ActionSelector에서 쓰려고 만든거임

              /// 불러오기 버튼
              child: ElevatedButton(
                onPressed: () {
                  selectedActionList
                      .addAll(actionList.where((item) => item['selected']));
                  // selectedActionList.add(actionList.where((item) => item['selected']));
                  print(actionList.where((item) => item['selected']));
                  print('selectedActionList: $selectedActionList');
                  print('@@@@@ 전송! @@@@@');

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  backgroundColor: Palette.buttonOrange,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
                  child: Text("불러오기", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActionListTile extends StatefulWidget {
  ActionListTile({
    super.key,
    required this.isSelected,
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
  bool isSelected;

  @override
  State<ActionListTile> createState() => _ActionListTileState();
}

class _ActionListTileState extends State<ActionListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: widget.isSelectable ? widget.isSelected : false,
      onTap: () {
        widget.customFunctionOnTap();
        // print(widget.actionList);
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
