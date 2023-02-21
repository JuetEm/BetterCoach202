import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/binding/ticket_service.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/main.dart';
import 'package:web_project/ticketWidget.dart';
import 'package:web_project/userInfo.dart';

String screenName = "수강권 추가";

bool isOffStaged = true;
String selectedticketName = "";

final List<DropDownValueModel> tickets = [
  DropDownValueModel(name: '직접입력', value: '직접입력', toolTipMsg: '직접입력')
];

late SingleValueDropDownController ticketMakeController;

late FocusNode textFieldFocusNode;

late TextEditingController ticketCountLeftController;
late TextEditingController ticketCountAllController;
late TextEditingController ticketTitleController;
late TextEditingController ticketDescriptionController;
late TextEditingController ticketStartDateController;
late TextEditingController ticketEndDateController;
late TextEditingController ticketDateLeftController;

int ticketCountLeft = 0;
int ticketCountAll = 0;
String ticketTitle = "";
String ticketDescription = "";
String ticketStartDate = "";
String ticketEndDate = "";
int ticketDateLeft = 0;

String getTodayDate() {
  String today = "";

  DateTime dateTime = DateTime.now();
  today = DateFormat('yyyy.MM.dd')
      .format(DateTime.parse(dateTime.toString()))
      .toString();
  print("today : ${today}");
  return today;
}

class TicketMake extends StatefulWidget {
  UserInfo? userInfo;
  TicketMake({super.key});
  TicketMake.getUserInfo(this.userInfo, {super.key});

  @override
  State<TicketMake> createState() => _TicketMakeState();
}

class _TicketMakeState extends State<TicketMake> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    analyticLog.sendAnalyticsEvent(
        screenName, "수강권추가_이벤트_init", "init 테스트 스트링", "init 테스트 파라미터");

    ticketMakeController = SingleValueDropDownController();
    textFieldFocusNode = FocusNode();

    ticketCountLeftController = TextEditingController();
    ticketCountAllController = TextEditingController();
    ticketTitleController = TextEditingController();
    ticketDescriptionController = TextEditingController();
    ticketStartDateController = TextEditingController();
    ticketEndDateController = TextEditingController();
    ticketDateLeftController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    ticketMakeController.dispose();
    textFieldFocusNode.dispose();

    ticketCountLeftController.dispose();
    ticketCountAllController.dispose();
    ticketTitleController.dispose();
    ticketDescriptionController.dispose();
    ticketStartDateController.dispose();
    ticketEndDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketService>(
      builder: (context, ticketService, child) {
        ticketService.read(widget.userInfo!.uid).then((value) {
          for (int i = 0; i < value.length; i++) {
            tickets.add(DropDownValueModel(
                name: value[i]['ticketTitle'],
                value: value[i]['ticketTitle'],
                toolTipMsg: value[i]['ticketDescription']));
          }
        });
        return Scaffold(
          appBar: BaseAppBarMethod(
            context,
            "수강권 추가",
            () {
              Navigator.pop(context, widget.userInfo);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  /// 제목과 완료 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("수강권 추가",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      TextButton(
                        onPressed: () {
                          print("수강권 추가 완료 버튼 클릭!!");
                        },
                        child: Text("완료",style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// 수강권 명 입력
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text("수강권 명",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  DropDownTextField(
                    controller: ticketMakeController,
                    isEnabled: true,
                    clearOption: false,
                    enableSearch: true,
                    textFieldFocusNode: textFieldFocusNode,
                    // searchFocusNode: searchFocusNode,
                    clearIconProperty:
                        IconProperty(color: Palette.buttonOrange),
                    textFieldDecoration: InputDecoration(
                      hintText: "수강권을 선택하세요.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(20),
                      fillColor: Colors.white,
                    ),
                    searchDecoration: InputDecoration(
                      hintText: "검색하고 싶은 수강권을 입력하세요",
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
                    dropDownItemCount: tickets.length,
                    dropDownList: tickets,
                    onChanged: (val) {
                      print("position onChange val : ${val}");
                      print(
                          "ticketMakeController.dropDownValue : ${ticketMakeController.dropDownValue!.value}");
                      selectedticketName =
                          ticketMakeController.dropDownValue!.value;
                      if (selectedticketName == "직접입력") {
                        isOffStaged = false;
                        ticketTitle = ticketTitleController.text;
                      } else {
                        isOffStaged = true;
                        ticketTitle = selectedticketName;
                      }
                      setState(() {});
                    },
                  ),

                  /// 직접 입력 선택 시 
                  Offstage(
                    offstage: isOffStaged,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: TextField(
                        maxLength: 12,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onChanged: (value) {
                          ticketTitle = value;
                          setState(() {});
                        },
                        controller: ticketTitleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Palette.grayFF,
                          // labelText: '수강권 이름',
                          hintText: '수강권 이름을 입력하세요',
                          labelStyle: TextStyle(color: Palette.gray00),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.transparent),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        // keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// 수강 횟수 입력
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text("수강 횟수",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextField(
                      maxLength: 3,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      onChanged: (value) {
                        ticketCountAll = int.parse(value);
                        setState(() {
                          
                        });
                      },
                      controller: ticketCountAllController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Palette.grayFF,
                        // labelText: '수강 횟수',
                        hintText: '수강 횟수를 입력하세요',
                        labelStyle: TextStyle(color: Palette.gray00),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                children: [
                                  Text("수강 시작일",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                              child: TextField(
                                onTap: () {},
                                readOnly: true,
                                enabled: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Palette.grayFF,
                                  // labelText: '수강 시작일',
                                  hintText: '수강권 시작일을 입력하세요',
                                  labelStyle: TextStyle(color: Palette.gray00),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                // keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 수강 종료일 선택
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                children: [
                                  Text("수강 종료일",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
                              child: TextField(
                                readOnly: true,
                                enabled: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Palette.grayFF,
                                  // labelText: '수강 종료일',
                                  hintText: '수강권 종료일을 입력하세요',
                                  labelStyle: TextStyle(color: Palette.gray00),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                // keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  /// 수강권 설명
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Row(
                      children: [
                        Text("수강권 설명",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextField(
                      minLines: 3,
                      maxLines: 20,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        filled: true,
                        fillColor: Palette.grayFF,
                        // labelText: '수강권 설명',
                        hintText: '예) 신규 20회 + 이벤트로 서비스 3회 드림',
                        labelStyle: TextStyle(color: Palette.gray00),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      // keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  TicketWidget(
                      customFunctionOnTap: () {},
                      ticketCountLeft: ticketCountLeft,
                      ticketCountAll: ticketCountAll,
                      ticketTitle: ticketTitle,
                      ticketDescription: ticketDescription,
                      ticketStartDate: ticketStartDate,
                      ticketEndDate: ticketEndDate,
                      ticketDateLeft: ticketDateLeft,)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
