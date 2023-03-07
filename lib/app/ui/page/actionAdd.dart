import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/data/model/action.dart';
import 'package:web_project/app/data/provider/action_service.dart';

import '../../data/provider/auth_service.dart';
import '../../data/model/color.dart';
import '../../function/globalFunction.dart';
import '../widget/globalWidget.dart';
import '../../data/model/action.dart' as tmpActionClass;

GlobalFunction globalFunction = GlobalFunction();

List resultActionList = [];

late FocusNode apparatusFocusNode;
late FocusNode positionFocusNode;
late FocusNode actionNameFocusNode;

class ActionAdd extends StatefulWidget {
  List tmpActionList = [];
  ActionAdd({super.key});
  ActionAdd.manageList(this.tmpActionList, {super.key});

  @override
  State<ActionAdd> createState() => _ActionAddState();
}

class _ActionAddState extends State<ActionAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController apparatusController;
  late SingleValueDropDownController positionController;
  late TextEditingController otherApparatusController;
  late TextEditingController otherPositionController;
  late TextEditingController nameController;

  String selectedApparatus = "";
  String otherApparatusName = "";
  String selectecPosition = "";
  String otherPositionName = "";
  String actionName = "";

  @override
  void initState() {
    apparatusController = SingleValueDropDownController();
    positionController = SingleValueDropDownController();
    otherApparatusController = TextEditingController();
    otherPositionController = TextEditingController();
    nameController = TextEditingController();

    resultActionList = widget.tmpActionList;

    apparatusFocusNode = FocusNode();
    positionFocusNode = FocusNode();
    actionNameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    apparatusController.dispose();
    positionController.dispose();
    otherApparatusController.dispose();
    otherPositionController.dispose();
    nameController.dispose();
    selectedApparatus = "";
    selectecPosition = "";
    actionName = "";

    apparatusFocusNode.dispose();
    positionFocusNode.dispose();
    actionNameFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final apparatuses = [
    DropDownValueModel(
        name: 'OTHERS', value: 'OT', toolTipMsg: "등록하려는 도구가 없는 경우 선택해주세요."),
    DropDownValueModel(name: 'CADILLAC', value: 'CA', toolTipMsg: "캐딜락"),
    DropDownValueModel(name: 'REFORMER', value: 'RE', toolTipMsg: "리포머"),
    DropDownValueModel(name: 'CHAIR', value: 'CH', toolTipMsg: "체어"),
    DropDownValueModel(name: 'LADDER BARREL', value: 'LA', toolTipMsg: "래더 바렐"),
    DropDownValueModel(name: 'SPRING BOARD', value: 'SB', toolTipMsg: "스프링 보드"),
    DropDownValueModel(
        name: 'SPINE CORRECTOR', value: 'SC', toolTipMsg: "스파인 코렉터"),
    DropDownValueModel(name: 'MAT', value: 'MAT', toolTipMsg: "매트"),
  ];

  final positions = [
    DropDownValueModel(
        name: "OTHERS", value: 'others', toolTipMsg: "등록하려는 자세가 없는 경우 선택해주세요."),
    DropDownValueModel(name: "SUPINE", value: 'supine', toolTipMsg: "누워서"),
    DropDownValueModel(name: "SITTING", value: 'sitting', toolTipMsg: "앉아서"),
    DropDownValueModel(name: "PRONE", value: 'prone', toolTipMsg: "엎드려서"),
    DropDownValueModel(
        name: "KNEELING", value: 'kneeling', toolTipMsg: "무릎 꿇고 서서"),
    DropDownValueModel(
        name: "SIDE LYING", value: 'side lying', toolTipMsg: "옆으로 누워서"),
    DropDownValueModel(
        name: "STANDING", value: 'standing', toolTipMsg: "양 발로  서서"),
    DropDownValueModel(
        name: "PLANK", value: 'plank', toolTipMsg: "다리 뻗고 엎드려 상하체 지지"),
    DropDownValueModel(
        name: "QUADRUPED", value: 'quadruped', toolTipMsg: "무릎 꿇고 엎드려서"),
  ];

  bool apparatusOffstage = true;
  bool positionOffstage = true;

  String currentSeletecValue = "SUPINE";

  @override
  Widget build(BuildContext context) {
    // final actionService = context.read<ActionService>();
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<ActionService>(builder: (context, actionService, child) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Palette.secondaryBackground,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '새로운 동작 생성',
                    style: TextStyle(
                        color: Palette.gray00,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                /// 기구 선택
                DropDownTextField(
                  listTextStyle: TextStyle(fontSize: 14),
                  controller: apparatusController,
                  isEnabled: true,
                  clearOption: false,
                  enableSearch: true,
                  // textFieldFocusNode: textFieldFocusNode,
                  // searchFocusNode: searchFocusNode,
                  clearIconProperty: IconProperty(color: Palette.buttonOrange),
                  textFieldDecoration: InputDecoration(
                    hintText: "기구를 선택하세요.",
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                  searchDecoration: InputDecoration(
                    hintText: "검색하고 싶은 기구를 입력하세요",
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    print("apparatus validator value : ${value}");
                    if (value == null) {
                      return "required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: apparatuses.length,
                  dropDownList: apparatuses,
                  onChanged: (val) {
                    print("apparatus onChange val : ${val}");
                    print(
                        "apparatusController.dropDownValue : ${apparatusController.dropDownValue!.value}");
                    setState(() {
                      if (apparatusController.dropDownValue!.name == "OTHERS") {
                        apparatusOffstage = false;
                        apparatusFocusNode.requestFocus();
                      } else {
                        apparatusOffstage = true;
                      }
                    });
                  },
                ),
                SizedBox(height: 10),

                /// 기구 OTHERS 입력창
                Offstage(
                  offstage: apparatusOffstage,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Palette.grayFF,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: BaseTextField(
                      customController: otherApparatusController,
                      customFocusNode: apparatusFocusNode,
                      hint: "새로운 기구를 입력해주세요.",
                      showArrow: false,
                      customFunction: () {},
                    ),
                  ),
                ),

                /// 자세 선택
                DropDownTextField(
                  listTextStyle: TextStyle(fontSize: 14),
                  controller: positionController,
                  isEnabled: true,
                  clearOption: false,
                  enableSearch: true,
                  // textFieldFocusNode: textFieldFocusNode,
                  // searchFocusNode: searchFocusNode,
                  clearIconProperty: IconProperty(color: Palette.buttonOrange),
                  textFieldDecoration: InputDecoration(
                    hintText: "자세를 선택하세요.",
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                  searchDecoration: InputDecoration(
                    hintText: "검색하고 싶은 자세를 입력하세요",
                    hintStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.all(16),
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    print("position validator value : ${value}");
                    if (value == null) {
                      return "required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: positions.length,
                  dropDownList: positions,
                  onChanged: (val) {
                    print("position onChange val : ${val}");
                    print(
                        "positionController.dropDownValue : ${positionController.dropDownValue!.value}");
                    setState(() {
                      if (positionController.dropDownValue!.name == "OTHERS") {
                        positionOffstage = false;
                        positionFocusNode.requestFocus();
                      } else {
                        positionOffstage = true;
                      }
                    });
                  },
                ),
                SizedBox(height: 10),

                /// 자세 OTHERS 입력창
                Offstage(
                  offstage: positionOffstage,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Palette.grayFF,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: BaseTextField(
                      customController: otherPositionController,
                      customFocusNode: positionFocusNode,
                      hint: "새로운 자세를 입력해주세요.",
                      showArrow: false,
                      customFunction: () {},
                    ),
                  ),
                ),

                /// 동작 이름 입력창
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.grayFF,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: BaseTextField(
                    customController: nameController,
                    customFocusNode: actionNameFocusNode,
                    hint: "새로운 동작명을 입력해주세요.",
                    showArrow: false,
                    customFunction: () {},
                  ),
                ),

                SizedBox(height: 10),

                //// 새로가져온 버튼
                ElevatedButton(
                  onPressed: () async {
                    print("추가 버튼");
                    // create action
                    if (apparatusOffstage) {
                      if (globalFunction.selectNullCheck(
                          context, apparatusController, "기구 선택")) {
                        selectedApparatus =
                            apparatusController.dropDownValue!.value;
                        otherApparatusName =
                            apparatusController.dropDownValue!.name;
                      }
                    } else {
                      if (globalFunction.textNullCheck(
                          context, otherApparatusController, "새로운 기구 이름")) {
                        selectedApparatus =
                            apparatusController.dropDownValue!.value;
                        otherApparatusName = otherApparatusController.text;
                      }
                    }
                    if (positionOffstage) {
                      if (globalFunction.selectNullCheck(
                          context, positionController, "자세 선택")) {
                        selectecPosition =
                            positionController.dropDownValue!.value;
                        otherPositionName =
                            positionController.dropDownValue!.name;
                      }
                    } else {
                      if (globalFunction.textNullCheck(
                          context, otherPositionController, "새로운 자세 이름")) {
                        selectecPosition =
                            positionController.dropDownValue!.value;
                        otherPositionName = otherPositionController.text;
                      }
                    }
                    if (globalFunction.textNullCheck(
                        context, nameController, "새로운 동작 이름")) {
                      actionName = nameController.text;
                    }
                    if (selectedApparatus.isNotEmpty &&
                        selectecPosition.isNotEmpty &&
                        actionName.isNotEmpty) {
                      String id = await actionService.create(
                        selectedApparatus,
                        otherApparatusName,
                        selectecPosition,
                        otherPositionName,
                        actionName,
                        user.uid,
                        actionName.toUpperCase(),
                        actionName.toLowerCase(),
                      );

                      List tmpResultList = [];
                      //tmpActionClass.Action tmpAction = tmpActionClass.Action(selectedApparatus, otherApparatusName, selectecPosition, otherPositionName, actionName, id, actionName.toUpperCase(), actionName.toLowerCase(), actionName.toLowerCase().split(" "), user.uid);
                      // {name: 핸드 스트랩을 이용하여 Hugging, upperCaseName: 핸드 스트랩을 이용하여 HUGGING, otherApparatusName: SPRING BOARD, nGramizedLowerCaseName: [핸드, 스트랩을, 이용하여, hugging], position: standing, otherPositionName: STANDING, apparatus: SB, author: p0gKIY1vArckS6JTZQdYG4RymEk2, lowerCaseName: 핸드 스트랩을 이용하여 hugging, id: 2RqZOEQK09sRx7bcqQ6n}
                      resultActionList.add({});
                      resultActionList[resultActionList.length - 1]['name'] =
                          actionName;
                      resultActionList[resultActionList.length - 1]
                          ['upperCaseName'] = actionName.toUpperCase();
                      resultActionList[resultActionList.length - 1]
                          ['otherApparatusName'] = otherApparatusName;
                      resultActionList[resultActionList.length - 1]
                              ['nGramizedLowerCaseName'] =
                          actionName.toLowerCase().split(" ");
                      resultActionList[resultActionList.length - 1]
                          ['position'] = selectecPosition;
                      resultActionList[resultActionList.length - 1]
                          ['otherPositionName'] = otherPositionName;
                      resultActionList[resultActionList.length - 1]
                          ['apparatus'] = selectedApparatus;
                      resultActionList[resultActionList.length - 1]['author'] =
                          user.uid;
                      resultActionList[resultActionList.length - 1]
                          ['lowerCaseName'] = actionName.toLowerCase();
                      resultActionList[resultActionList.length - 1]['id'] = id;
                      // resultActionList.add(tmpAction);
                      print(resultActionList);
                      resultActionList
                          .sort(((a, b) => a['name'].compareTo(b['name'])));

                      tmpResultList.add(actionName);
                      tmpResultList.add(resultActionList);
                      // 새로운 동작 추가 성공시 actionSelector로 이동
                      Navigator.pop(context, tmpResultList);
                    } else {
                      // 빈 값 있을 때
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("모든 항목을 입력 해주세요."),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 0,
                    backgroundColor: Palette.buttonOrange,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 90),
                    child: Text("동작추가", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
