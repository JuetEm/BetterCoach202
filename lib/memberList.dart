import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:web_project/testShowDialog.dart';

import 'auth_service.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';
import 'main.dart';
import 'memberAdd.dart';
import 'memberInfo.dart';
import 'member_service.dart';
import 'userInfo.dart';

// GA 용 화면 이름 정의
String screenName = "회원 목록";

MemberService memberService = MemberService();

List<UserInfo> userInfoList = [];

String conutMemberList = "";

String memberAddMode = "추가";

// late UserInfo userInfo;

List resultMemberList = [];
List resultActionList = [];

List resultList = [];

TextEditingController searchController = TextEditingController();

FocusNode searchFocusNode = FocusNode();

String searchString = "";

List combinedLngs = [];

// 자음 검색 세로 바 작업
ScrollController scrollController = ScrollController();

String currentChar = "";

class MemberList extends StatefulWidget {
  List tmpMemberList = [];
  List tmpActionList = [];
  MemberList({super.key});
  MemberList.getMemberList(this.tmpMemberList, this.tmpActionList, {super.key});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // 알파벳 자모음 생성
  final alphabets =
      List.generate(26, (index) => String.fromCharCode(index + 65));
  final koreans = [
    "ㄱ",
    "ㄴ",
    "ㄷ",
    "ㄹ",
    "ㅁ",
    "ㅂ",
    "ㅅ",
    "ㅇ",
    "ㅈ",
    "ㅊ",
    "ㅋ",
    "ㅌ",
    "ㅍ",
    "ㅎ",
    /* "ㄲ",
    "ㄸ",
    "ㅃ",
    "ㅆ",
    "ㅉ", */
  ];

  int _searchIndex = 0;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // 모음 검색 세로 바 구현 작업
  // https://github.com/thanikad/alphabetical_search
  void setSearchIndex(String searchLetter) {
    List rmNameList = [];
    resultMemberList.forEach(
      (element) {
        rmNameList.add(globalFunction.getChosungFromString(element['name']));
      },
    );
    /* rmNameList.forEach((element) { 
      print("element : ${element}");
    }); */
    // setState(() {
    _searchIndex = rmNameList.indexWhere(
        (element) => element.toString().startsWith(searchLetter.toLowerCase()));
    print("_searchIndex.toDouble() : ${_searchIndex.toDouble()}");
    double contentHeight = MediaQuery.of(context).size.height > 700
        ? MediaQuery.of(context).size.height * 0.89
        : MediaQuery.of(context).size.height * 0.85;
    print("contentHeight : ${contentHeight}");
    if (_searchIndex >= 0 && scrollController.hasClients) {
      /* SchedulerBinding.instance.addPersistentFrameCallback(
        (timeStamp) async {
          await scrollController.animateTo(
              _searchIndex.toDouble(),
              duration: Duration(milliseconds: 1),
              curve: Curves.ease)/* .then((value){
                print("value : ");
              }).whenComplete((){
                print("complete : ");
              }) */;
        },
      ); */
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print(
          "scrollController.position.maxScrollExtent : ${scrollController.position.maxScrollExtent}");
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1),
          curve: Curves
              .ease); /* .then((value){
                print("value : ");
              }).whenComplete((){
                print("complete : ");
              }) */
      // scrollController.jumpTo(contentHeight);
      print("WidgetsBinding : ");
      // },);
      print("after jumpTo!!");
    }
    // });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  void _refreshMemberCount(value) {
    setState(() {
      conutMemberList = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analyticLog.sendAnalyticsEvent(
        screenName, "init", "init 스트링", "init파라미터");

    print("MemberList InitState Called!!");
    resultMemberList = widget.tmpMemberList;
    resultActionList = widget.tmpActionList;
    print("resultMemberList.length : ${resultMemberList.length}");
    print("resultActionList.length : ${resultActionList.length}");
    // 모음 검색 세로 바 구현 작업
    combinedLngs.addAll(koreans);
    combinedLngs.addAll(alphabets);
    scrollController = ScrollController(initialScrollOffset: 0);
    scrollController.addListener(() {
      // print("Listening!");
      // print("scrollController.offset : ${scrollController.offset}");
    });
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    
    analyticLog.sendAnalyticsEvent(
        screenName, "dispose", "dispose 스트링", "dispose 파라미터");
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    print("몇 번 그리나요? - build");
    //user.uid = '11';
    // 로그인 화면에서 보낸 멤러 리트스 변수 받기
    List<dynamic> argsList = [];
    argsList =
        (ModalRoute.of(context)!.settings.arguments ?? []) as List<dynamic>;
    print("argsList.length : ${argsList.length}");
    // resultMemberList 비었을 경우에만 받아온다.
    if (argsList.length > 0) {
      if (resultMemberList.isEmpty) {
        resultMemberList = argsList[0];
        print("resultMemberList.length : ${resultMemberList.length}");
      }

      if (resultActionList.isEmpty) {
        resultActionList = argsList[1];
        print("resultActionList.length : ${resultActionList.length}");
      }
    }
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        print("몇 번 그리나요? - Consumer");
        return SafeArea(
          child: Scaffold(
            backgroundColor: Palette.secondaryBackground,
            // key: _scaffoldKey,
            appBar: MainAppBarMethod(context, "회원목록"),
            /* endDrawer: Container(
              child: Drawer(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('This is the Drawer'),
                      ElevatedButton(
                        onPressed: () {
                          _closeEndDrawer();
                        },
                        child: const Text('Close Drawer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 로그아웃
                          context.read<AuthService>().signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        },
                        child: const Text('Log Out'),
                      )
                    ],
                  ),
                ),
              ),
            ), */
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BaseSearchTextField(
                      customController: searchController,
                      customFocusNode: searchFocusNode,
                      hint: "이름을 검색하세요.",
                      label: "이름을 검색하세요.",
                      showArrow: true,
                      customFunction: () {
                        setState(() {
                          searchString = searchController.text.toLowerCase();
                        });
                      },
                      clearfunction: () {
                        setState(() {
                          searchController.clear();
                          searchString = "";
                        });
                      },
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          '총 ${resultMemberList.length} 명',
                          style: TextStyle(color: Palette.gray7B),
                        ),
                        Spacer(),
                        // Text(
                        //   '최근 수업순',
                        //   style: TextStyle(color: Palette.gray7B),
                        // ),
                        // Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              print("몇 번 그리나요? - ListView.builder");
                              final docs;

                              if (searchString.isNotEmpty) {
                                print(
                                    "searchString.isNotEmpty : ${searchString}");
                                List searchedList = [];
                                String varName = "";

                                resultMemberList.forEach((element) {
                                  varName = element['name'];
                                  // 검색 기능 함수 convert
                                  if (globalFunction.searchString(
                                      varName, searchString, "member")) {
                                    searchedList.add(element);
                                  }
                                });
                                docs = searchedList ?? []; // 문서들 가져오기
                              } else {
                                docs = resultMemberList ?? []; // 문서들 가져오기
                              }
                              /* 멤버 리트스 최초 1번 받아오기 리뉴얼 작업위해 주석 - 정규호 2022/11/23 
                              FutureBuilder<QuerySnapshot>(
                                //future: memberService.read(
                                //    'w5ahp6WhpQdLgqNhA6B8afrWWeA3', 'name'),
                                future: memberService.read(user.uid, 'name'),
                                builder: (context, snapshot) {
                                  final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                                  */

                              //해당 함수는 빌드가 끝난 다음 수행 된다.
                              //https://velog.io/@jun7332568/%ED%94%8C%EB%9F%AC%ED%84%B0flutter-setState-or-markNeedsBuild-called-during-build.-%EC%98%A4%EB%A5%98-%ED%95%B4%EA%B2%B0
                              /* WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                if (conutMemberList != docs.length.toString()) {
                                  _refreshMemberCount(docs.length.toString());
                                }
                              }); */

                              // 위 refreshMemberCount 아래에 있어야 회원 목록 없을 때 총 0 명 리턴
                              if (docs.isEmpty) {
                                return Center(child: Text("회원 목록을 준비 중입니다."));
                              }

                              return NotificationListener(
                                onNotification: (notification) {
                                  if (notification is UserScrollNotification) {
                                    /* if(scrollController.offset != scrollController.position.maxScrollExtent && docs){

                                    } */
                                  }
                                  // print("notification : ${notification}");
                                  return false;
                                },
                                child: ListView.separated(
                                  physics: PageScrollPhysics(),
                                  controller: scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print("몇 번 그리나요? - ListView.separated");
                                    final doc = docs[index];
                                    String docId = doc['id'];
                                    String name = doc['name'] ?? "";
                                    String registerDate =
                                        doc['registerDate'] ?? "";
                                    String phoneNumber =
                                        doc['phoneNumber'] ?? "";
                                    String registerType =
                                        doc['registerType'] ?? "";
                                    String goal = doc['goal'] ?? "";
                                    List<String> selectedGoals =
                                        List<String>.from(
                                            doc['selectedGoals'] ?? []);
                                    /* print(
                                        "[ML] ListView 회원정보 가져오기 selectedGoals : ${selectedGoals}"); */
                                    String bodyAnalyzed =
                                        doc['bodyanalyzed'] ?? "";
                                    /* print(
                                        "[ML] ListView 회원정보 가져오기 bodyAnalyzed : ${bodyAnalyzed}"); */
                                    List<String> selectedBodyAnalyzed =
                                        List<String>.from(
                                            doc['selectedBodyAnalyzed'] ?? []);

                                    String medicalHistories =
                                        doc['medicalHistories'] ?? "";
                                    List<String> selectedMedicalHistories =
                                        List<String>.from(
                                            doc['selectedMedicalHistories'] ??
                                                []);

                                    String info = doc['info'] ?? "";
                                    String note = doc['note'] ?? "";
                                    String comment = doc['comment'] ?? "";
                                    bool isActive = doc['isActive'];

                                    UserInfo userInfo = UserInfo(
                                      doc['id'],
                                      user.uid,
                                      name,
                                      registerDate,
                                      phoneNumber,
                                      registerType,
                                      goal,
                                      selectedGoals,
                                      bodyAnalyzed,
                                      selectedBodyAnalyzed,
                                      medicalHistories,
                                      selectedMedicalHistories,
                                      info,
                                      note,
                                      comment,
                                      isActive,
                                    );

                                    return InkWell(
                                      onTap: () async {
                                        // 회원 카드 선택시 MemberInfo로 이동

                                        // resultList.add(resultActionList);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MemberInfo
                                                .getUserInfoAndActionList(
                                                    userInfo,
                                                    resultMemberList,
                                                    resultActionList),
                                            // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                            /* settings: RouteSettings(
                                              arguments: userInfo
                                            ), */
                                          ),
                                        ).then((result) {
                                          print(
                                              "MemberList : userInfo.bodyAnalyzed : ${userInfo.selectedBodyAnalyzed}");
                                          UserInfo tmpUserInfo = result;
                                          print(
                                              "MemberList : tmpUserInfo.bodyAnalyzed : ${tmpUserInfo.selectedBodyAnalyzed}");
                                        });
                                      },
                                      child: BaseContainer(
                                        docId: docId,
                                        name: name,
                                        registerDate: registerDate,
                                        goal: goal,
                                        info: info,
                                        note: note,
                                        phoneNumber: phoneNumber,
                                        isActive: isActive,
                                        memberService: memberService,
                                      ),
                                    );
                                  },
                                  separatorBuilder: ((context, index) =>
                                      Divider(
                                        height: 0,
                                      )),
                                ),
                              );
                            },
                          ),
                          // 자음 검색 세로 바 구현 작업
                          /* GestureDetector(
                            onVerticalDragUpdate: (details) {
                              print(
                                  "update details.localPosition.dy : ${details.localPosition.dy}");
                              print("update currentChar : ${currentChar}");
                              setSearchIndex(currentChar);
                            },
                            onVerticalDragStart: (details) {
                              print(
                                  "start details.localPosition.dy : ${details.localPosition.dy}");
                              print("start currentChar : ${currentChar}");
                              setSearchIndex(currentChar);
                            },
                            onVerticalDragEnd: (details) {
                              print("End currentChar : ${currentChar}");
                              setState(() {
                                currentChar = "";
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: combinedLngs
                                    .map((character) => InkWell(
                                          onTap: () async {
                                            print("character : ${character}");
                                            setState(() {
                                              currentChar = character;
                                            });

                                            setSearchIndex(currentChar);

                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              setState(() {
                                                currentChar = "";
                                              });
                                            });

                                            /* currentChar = character; */
                                            
                                          },
                                          child: Text(
                                            character,
                                            style: TextStyle(
                                                fontSize: (MediaQuery.of(context).size.height/65).floorToDouble()),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          currentChar.isEmpty
                              ? Container()
                              : Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    color: Colors.black.withAlpha(80),
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      currentChar,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 36.0),
                                    ),
                                  ),
                                ) */
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),

                    // //추가버튼 FloatingActionbutton으로 변경
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     FloatingActionButton(
                    //       onPressed: () {
                    //         print("회원추가");
                    //         // 저장하기 성공시 Home로 이동
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(builder: (_) => MemberAdd()),
                    //         );
                    //       },
                    //       child: Icon(Icons.person_add),
                    //       backgroundColor: Palette.buttonOrange,
                    //     ),
                    //   ],
                    // ),

                    /// 추가 버튼
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     padding: EdgeInsets.all(0),
                    //     elevation: 0,
                    //     backgroundColor: Colors.transparent,
                    //     shadowColor: Colors.transparent,
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(10.0),
                    //       ),
                    //       color: Palette.buttonOrange,
                    //     ),
                    //     height: 60,
                    //     width: double.infinity,
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "회원추가",
                    //           style: TextStyle(fontSize: 18),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     print("회원추가");
                    //     // 저장하기 성공시 Home로 이동
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (_) => MemberAdd()),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            //bottomNavigationBar: BaseBottomAppBar(),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     print('floating button');
            //   },
            //   backgroundColor: Colors.blue,
            //   child: const Icon(Icons.add),
            // ),

            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: FloatingActionButton.extended(
                onPressed: () {
                  print("회원추가");
                  memberAddMode = "추가";

                  List<dynamic> args = [
                    memberAddMode,
                    resultMemberList,
                    resultActionList,
                  ];

                  // 저장하기 성공시 Home로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // 로그아웃 용 야매버튼
                      // builder: (context) =>
                      //     LoginPage(analytics: MyApp.analytics),
                      // 이게 진짜 버튼
                      builder: (context) => MemberAdd(),
                      // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                      settings: RouteSettings(
                        arguments: args,
                      ),
                    ),
                  ).then((value) {
                    List tmpResultList = value as List;
                    // print("어디지?");
                    setState(() {
                      resultMemberList = tmpResultList[0];
                      resultActionList = tmpResultList[1];
                    });
                  });
                },
                label: Text(
                  '회원 추가',
                  style: TextStyle(fontSize: 16, letterSpacing: -0.2),
                ),
                icon: Icon(Icons.person_add),
                backgroundColor: Palette.buttonOrange,
              ),
            ),
          ),
        );
      },
    );
  }
}
