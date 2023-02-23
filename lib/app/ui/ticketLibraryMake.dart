import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/binding/member_service.dart';
import 'package:web_project/app/binding/ticketLibrary_service.dart';
import 'package:web_project/app/ui/ticketList.dart';
import 'package:web_project/app/ui/ticketManage.dart';
import 'package:web_project/baseTableCalendar.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/locationAdd.dart';
import 'package:web_project/main.dart';
import 'package:web_project/ticketWidget.dart';
import 'package:web_project/userInfo.dart';

String screenName = "수강권 추가";

String calendarName = "";

bool isTicketTitleOffStaged = true;
bool calendarIsOffStaged = true;
String selectedticketName = "";

List<DropDownValueModel> tickets = [
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

int ticketUsingCount = 0;

int ticketCountLeft = 0;
int ticketCountAll = 0;
String ticketTitle = "";
String ticketDescription = "";
String ticketStartDate = "";
String ticketEndDate = "";
int ticketDateLeft = 0;

String getTodayDate() {
  String today = "";

  today = DateFormat("yyyy-MM-dd").format(DateTime.now());
  print("today : ${today}");
  return today.substring(0, 10);
}

String getMonthLateDate() {
  String today = "";

  DateTime now = DateTime.now();

  today = DateFormat("yyyy-MM-dd")
      .format(DateTime(now.year, now.month + 1, now.day - 1));
  print("month today : ${today}");
  return today.substring(0, 10);
}

String getDateFromTimeStamp(var timestamp) {
  String date = "";

  date = DateFormat("yyyy-MM-dd").format(timestamp.toDate());

  return date;
}

class TicketLibraryMake extends StatefulWidget {
  UserInfo? userInfo;
  TicketLibraryMake({super.key});
  TicketLibraryMake.getUserInfo(this.userInfo, {super.key});

  @override
  State<TicketLibraryMake> createState() => _TicketLibraryMakeState();
}

class _TicketLibraryMakeState extends State<TicketLibraryMake> {
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

    ticketStartDateController.text = getTodayDate();
    ticketStartDate = getTodayDate();
    ticketEndDateController.text = getMonthLateDate();
    ticketEndDate = getMonthLateDate();
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

    ticketCountLeft = 0;
    ticketCountAll = 0;
    ticketTitle = "";
    ticketDescription = "";
    ticketStartDate = "";
    ticketEndDate = "";
    ticketDateLeft = 0;

    isTicketTitleOffStaged = true;
  }

  @override
  Widget build(BuildContext context) {
    tickets = [
      DropDownValueModel(name: '직접입력', value: '직접입력', toolTipMsg: '직접입력'),
    ];
    for (var ticketVal in globalVariables.ticketList) {
      // print("ticketVal : $ticketVal");
      var model = DropDownValueModel(
          name: ticketVal['ticketTitle'],
          value: ticketVal['ticketTitle'],
          toolTipMsg: ticketVal['ticketDescription']);
      tickets.add(model);
    }
    return Consumer<TicketLibraryService>(
      builder: (context, TicketLibraryService, child) {
        return Scaffold(
          appBar: BaseAppBarMethod(context, "수강권 추가", () {
            Navigator.pop(context, widget.userInfo);
          }, [
            TextButton(
              onPressed: () async {
                print(
                    "AppBar TextButton is called! ticketMakeController.dropDownValue?.value.toString().trim() : ${ticketMakeController.dropDownValue?.value.toString().trim()}");
                if (ticketMakeController.dropDownValue?.value
                        .toString()
                        .trim() ==
                    null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("수강권을 선택하세요."),
                  ));
                } else if (isTicketTitleOffStaged == false &&
                    ticketTitleController.text.trim() == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("수강권 명을 입력하세요."),
                  ));
                } else if (ticketCountAllController.text.trim() == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("수강 횟수를 입력하세요."),
                  ));
                } else if (ticketStartDateController.text.trim() == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("수강 시작일을 선택하세요."),
                  ));
                } else if (ticketEndDateController.text.trim() == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("수강 종료일을 선택하세요."),
                  ));
                } else if (ticketDescriptionController.text.trim() == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("수강권 설명을 입력하세요."),
                  ));
                } else {
                  await ticketLibraryService
                      .create(
                    userInfo!.docId,
                    ticketUsingCount,
                    ticketCountLeft,
                    ticketCountAll,
                    ticketTitle,
                    ticketDescription,
                    Timestamp.fromDate(DateTime.parse(ticketStartDate))
                        .toDate(),
                    Timestamp.fromDate(DateTime.parse(ticketEndDate)).toDate(),
                    ticketDateLeft,
                    DateTime.now(),
                  )
                      .then((value) {
                    print("${screenName} - updateMemberTicket is called!");
                    Navigator.pop(context);
                  });
                }
              },
              child: Text(
                "완료",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ], null),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    /// 수강권 명 입력
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("수강권 명",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.all(10),
                                      // titlePadding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      content: TicketList(
                                          globalVariables.ticketList, () {
                                        setState(() {});
                                      }),
                                    );
                                  });
                            },
                            child: Text(
                              "편집",
                              style: TextStyle(
                                  fontSize: 16, color: Palette.statusRed),
                            ),
                          ),
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
                      clearIconProperty: IconProperty(
                          icon: Icons.close, color: Palette.gray66),
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
                          isTicketTitleOffStaged = false;
                          ticketTitle = ticketTitleController.text;

                          ticketCountAll = 0;
                          ticketCountAllController.text = "";

                          ticketStartDate = getTodayDate();
                          ticketStartDateController.text = getTodayDate();

                          ticketEndDate = getMonthLateDate();
                          ticketEndDateController.text = getMonthLateDate();

                          ticketDescription = "";
                          ticketDescriptionController.text = "";
                        } else {
                          isTicketTitleOffStaged = true;
                          ticketTitle = selectedticketName;

                          for (var ticketVal in globalVariables.ticketList) {
                            if (ticketVal['ticketTitle'] == ticketTitle) {
                              ticketCountAll = ticketVal['ticketCountAll'];
                              ticketCountAllController.text =
                                  ticketCountAll.toString();

                              ticketStartDate = getDateFromTimeStamp(
                                  ticketVal['ticketStartDate']);
                              ticketStartDateController.text = ticketStartDate;

                              ticketEndDate = getDateFromTimeStamp(
                                  ticketVal['ticketEndDate']);
                              ticketEndDateController.text = ticketEndDate;

                              ticketDescription =
                                  ticketVal['ticketDescription'];
                              ticketDescriptionController.text =
                                  ticketDescription;

                              break;
                            }
                          }
                        }
                        setState(() {});
                      },
                    ),

                    /// 직접 입력 선택 시
                    Offstage(
                      offstage: isTicketTitleOffStaged,
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
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
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
                    ),
                    SizedBox(height: 10),

                    /// 수강 횟수 입력
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Text("수강 횟수",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: TextField(
                        maxLength: 3,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            ticketCountAll = int.parse(value);
                          }

                          setState(() {});
                        },
                        controller: ticketCountAllController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Palette.grayFF,
                          // labelText: '수강 횟수',
                          hintText: '수강 횟수를 입력하세요',
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
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),

                    /// 수강권 설명
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Text("수강권 설명",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: TextField(
                        maxLength: 30,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        onChanged: (value) {
                          ticketDescription = value;
                          setState(() {});
                        },
                        controller: ticketDescriptionController,
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

                    /// 수강권 미리보기
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Row(
                        children: [
                          Text("미리보기",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    TicketWidget(
                      customFunctionOnTap: () {},
                      // customFunctionOnHover: (){},
                      ticketCountLeft: ticketCountAll,
                      ticketCountAll: ticketCountAll,
                      ticketTitle: ticketTitle,
                      ticketDescription: ticketDescription,
                      ticketStartDate: ticketStartDate,
                      ticketEndDate: ticketEndDate,
                      ticketDateLeft: ticketDateLeft,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
