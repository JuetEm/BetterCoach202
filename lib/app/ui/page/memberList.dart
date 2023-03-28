import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_project/app/data/model/globalVariables.dart';
import 'package:web_project/app/ui/lang/uiTextKor.dart';
import 'package:web_project/app/ui/page/actionSelector.dart';
import 'package:web_project/app/data/provider/daylesson_service.dart';
import 'package:web_project/app/data/provider/member_service.dart';
import 'package:web_project/app/ui/page/faq.dart';
import 'package:web_project/app/ui/page/lessonAdd.dart';
import 'package:web_project/app/ui/page/report.dart';
import 'package:web_project/app/ui/page/sequenceLibrary.dart';
import 'package:web_project/app/ui/page/ticketLibraryManage.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/app/ui/widget/notReadyAlertWidget.dart';

import '../../data/provider/auth_service.dart';
import '../../data/model/color.dart';
import '../../function/globalFunction.dart';
import '../widget/globalWidget.dart';
import '../../../main.dart';
import 'memberAdd.dart';
import 'memberInfo.dart';
import '../../data/model/userInfo.dart';

int searchResultCnt = 0;

List mainSearchedList = [];

GlobalFunction globalFunction = GlobalFunction();

// GA 용 화면 이름 정의
String screenName = "회원목록";

MemberService memberService = MemberService();

List<UserInfo> userInfoList = [];

String conutMemberList = "";

String memberAddMode = "추가";

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
  IconData reportIcon = Icons.report_outlined;
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
    globalVariables.resultList.forEach(
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
    analyticLog.sendAnalyticsEvent(screenName, "PAGE : ${screenName}",
        "memberList 스트링", "memberList 파라미터");

    globalVariables.sortList();

    reportIcon = Icons.report_outlined;

    print("MemberList InitState Called!!");
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

    widget.tmpActionList = [];
    widget.tmpMemberList = [];
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
      if (globalVariables.resultList.isEmpty) {
        globalVariables.resultList = argsList[0];
        print(
            "2. resultMemberList.length : ${globalVariables.resultList.length}");
      }

      if (globalVariables.actionList.isEmpty) {
        globalVariables.actionList = argsList[1];
        print(
            "2. resultActionList.length : ${globalVariables.actionList.length}");
      }
    }

    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        print("몇 번 그리나요? - Consumer");

        return Scaffold(
          drawerScrimColor: Palette.gray66,
          drawer: SafeArea(
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              width: 190,
                              child: Image.asset("assets/images/logo.png")),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(
                              child: Text(
                            AuthService().currentUser()!.email.toString(),
                            style: TextStyle(color: Palette.gray66),
                          )),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.confirmation_number_outlined,
                      color: Palette.gray66,
                    ),
                    // '수강권 보관함'
                    title: Text(UiTextKor.memberList_ticketLibrary),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return NotReadyAlertWidget(
                            // '수강권'
                            featureName: UiTextKor.memberList_ticketMessage,
                          );
                        },
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Palette.gray66,
                    ),
                    // '개인정보처리방침'
                    title: Text(UiTextKor.memberList_privacyPolicy),
                    onTap: () {
                      String event = "onTap";
                      String value = "개인정보처리방침";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");

                      print('개인정보처리방침 is clicked');
                      launchUrl(Uri.parse(
                          /* 'https://huslxl.notion.site/9eec26cf46b941c4960209b419d41fbc' */
                          'https://flame-production-5c2.notion.site/667e8ae7638d4a89b13a8ffd3072e7e3'));
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Palette.gray66,
                    ),
                    // '서비스 이용약관'
                    title: Text(UiTextKor.memberList_termsOfService),
                    onTap: () {
                      String event = "onTap";
                      String value = "서비스 이용약관";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");
                      print('서비스 이용약관 is clicked');
                      launchUrl(Uri.parse(
                          /* 'https://huslxl.notion.site/51d75d9fb0af4c64be5ec95f16fe6289' */
                          'https://flame-production-5c2.notion.site/5233101eb50c4c048220b25dfd2f205f'));
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Palette.gray66,
                    ),
                    // '자주 묻는 질문'
                    title: Text(UiTextKor.memberList_frequentlyAskedQuestions),
                    onTap: () {
                      print('자주 묻는 질문 is clicked');
                      Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Faq()))
                          .then((value) {
                        print("수강권 추가 result");
                      });
                      ;
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.wallet_giftcard_outlined,
                      color: Palette.gray66,
                    ),
                    // '스타벅스 기프티콘 받기!'
                    title: Text(UiTextKor.memberList_getAStarbucksGiftcard),
                    onTap: () {
                      String event = "onTap";
                      String value = "스타벅스 기프티콘";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");
                      print('스타벅스 기프티콘 is clicked');

                      /// URL 추후에 구글설문으로 바꿔야함
                      launchUrl(Uri.parse(
                          // 'https://huslxl.notion.site/cd976583216f4046ab695312ef471a4c'
                          'https://bit.ly/bettercoachbeta2'));
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.videocam_outlined,
                      color: Palette.gray66,
                    ),
                    // '베러코치 유튜브 채널'
                    title: Text(UiTextKor.memberList_betterCoachYouTubeChannel),
                    onTap: () {
                      String event = "onTap";
                      String value = "베러코치 유튜브 채널";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");
                      print('베러코치 유튜브 채널 is clicked');

                      /// Youtube Channel URL
                      launchUrl(
                          Uri.parse('https://www.youtube.com/@bettercoach'));
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.people_outline,
                      color: Palette.gray66,
                    ),
                    // '사용자모임 오픈채팅방'
                    title: Text(UiTextKor.memberList_userGroupOpenChatRooms),
                    onTap: () {
                      String event = "onTap";
                      String value = "사용자모임 오픈채팅방";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");
                      print('사용자모임 오픈채팅방 is clicked');

                      /// URL 추후에 구글설문으로 바꿔야함
                      launchUrl(Uri.parse('https://open.kakao.com/o/gmnc5j6e'));
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer_outlined,
                      color: Palette.gray66,
                    ),
                    // '1:1 문의'
                    title: Text(UiTextKor.memberList_contactUsOneOnOne),
                    onTap: () {
                      String event = "onTap";
                      String value = "1:1 오픈챗 문의";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");
                      print('1:1 문의 is clicked');

                      /// URL 추후에 구글설문으로 바꿔야함
                      launchUrl(Uri.parse('https://open.kakao.com/o/s8bbKj6e'));
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Palette.gray66,
                    ),
                    // '로그아웃'
                    title: Text(UiTextKor.memberList_logOut),
                    onTap: () {
                      String event = "onTap";
                      String value = "로그아웃";
                      analyticLog.sendAnalyticsEvent(
                          screenName,
                          "${event} : ${value}",
                          "${value} 프로퍼티 인자1",
                          "${value} 프로퍼티 인자2");
                      print('signOut');
                      /// 로그 아웃 시 전부 전역 변수 전부 초기화
                      /// 로그인 하는 만큼 회원 수가 중복 증가하는 현상 발견
                      /* widget.tmpActionList = [];
                      widget.tmpMemberList = []; */
                      globalVariables.actionList = [];
                      globalVariables.lessonNoteGlobalList = [];
                      globalVariables.memberTicketList = [];
                      globalVariables.resultList = [];
                      globalVariables.ticketLibraryList = [];
                      authService.signOut();

                      // 로그인 페이지로 이동
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Palette.secondaryBackground,
          // key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Palette.gray66),
            elevation: 0,
            backgroundColor: Palette.mainBackground,
            // "회원목록"
            title: Text(
              UiTextKor.memberList_memberListLabel,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Palette.gray00,
                  ),
            ),
            centerTitle: true,
            actions: [
              /// 회원추가
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                onTap: () {
                  String event = "onTap";
                  String value = "회원추가";
                  analyticLog.sendAnalyticsEvent(
                      screenName,
                      "${event} : ${value}",
                      "${value} 프로퍼티 인자1",
                      "${value} 프로퍼티 인자2");
                  print("회원추가");
                  memberAddMode = "추가";

                  List<dynamic> args = [
                    memberAddMode,
                    globalVariables.resultList,
                    globalVariables.actionList,
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
                    globalVariables.sortList();
                    List tmpResultList = value as List;
                    // print("어디지?");
                    setState(() {
                      globalVariables.resultList = tmpResultList[0];
                      globalVariables.actionList = tmpResultList[1];
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.person_add),
                ),
              ),
              InkWell(
                onTapDown: (details) async {
                  String event = "onTapDown";
                  String value = "Report";
                  analyticLog.sendAnalyticsEvent(
                      screenName,
                      "${event} : ${value}",
                      "${value} 프로퍼티 인자1",
                      "${value} 프로퍼티 인자2");
                  print("IconButton onTapDown!! details : ${details}");

                  setState(() {
                    reportIcon = Icons.report;
                  });

                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Report()),
                  ).then((value) {
                    print("Navigator.push value : ${value}");

                    setState(() {
                      reportIcon = Icons.report_outlined;
                    });
                  });
                },
                onTapUp: (details) {
                  print("IconButton onTapUp!! details : ${details}");
                  setState(() {
                    reportIcon = Icons.report_outlined;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(reportIcon),
                ),
              ),
              SizedBox(width: 10)
            ],
          ),

          body: CenterConstrainedBody(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BaseSearchTextField(
                      customController: searchController,
                      customFocusNode: searchFocusNode,
                      // "이름을 검색하세요."
                      hint: UiTextKor.memberList_SearchForAName,
                      showArrow: true,
                      customFunction: () {
                        searchString = searchController.text.toLowerCase();
                        setState(() {
                          print("search custom function setState called!");
                        });
                      },
                      clearfunction: () {
                        String event = "onTap";
                        String value = "회원 목록 검색 초기화";
                        analyticLog.sendAnalyticsEvent(
                            screenName,
                            "${event} : ${value}",
                            "${value} 프로퍼티 인자1",
                            "${value} 프로퍼티 인자2");
                        setState(() {
                          searchController.clear();
                          searchString = "";
                        });
                      },
                      logFunction: () {
                        String event = "onTap";
                        String value = "회원 목록 검색";
                        analyticLog.sendAnalyticsEvent(
                            screenName,
                            "${event} : ${value}",
                            "${value} 프로퍼티 인자1",
                            "${value} 프로퍼티 인자2");
                      },
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          /* searchString == "" ?  */ mainSearchedList.isEmpty ? '${UiTextKor.memberList_SearchResultTotal} ${globalVariables.resultList.length} ${UiTextKor.memberList_SearchResultTotalCnt}' :  '${UiTextKor.memberList_SearchResultTotal} ${mainSearchedList.length} ${UiTextKor.memberList_SearchResultTotalCnt}'/*  : '검색 결과 ${searchResultCnt} 명' */,
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
                    SizedBox(height: 10),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.only(bottom: 20),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              print("몇 번 그리나요? - ListView.builder");
                              final docs;

                              if (searchString.isNotEmpty) {
                                print(
                                    "searchString.isNotEmpty : ${searchString}");
                                mainSearchedList = [];
                                String varName = "";

                                globalVariables.resultList.forEach((element) {
                                  varName = element['name'];
                                  // 검색 기능 함수 convert
                                  if (globalFunction.searchString(
                                      varName, searchString, "member")) {
                                    mainSearchedList.add(element);
                                  }
                                });
                                print(
                                    "mainSearchedList.length : ${mainSearchedList.length}");
                                docs = mainSearchedList; // 문서들 가져오기
                                
                              } else {
                                // 2023-03-28 회원 검색 리스트 초기화
                                mainSearchedList = [];
                                globalVariables.sortList();
                                docs = globalVariables.resultList; // 문서들 가져오기
                                // print('docs = ${docs[0]}');
                              }

                              // 위 refreshMemberCount 아래에 있어야 회원 목록 없을 때 총 0 명 리턴
                              if (docs.isEmpty) {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    child:
                                        Center(child: Text("새로운 회원을 추가해보세요.")));
                              }

                              return NotificationListener(
                                onNotification: (notification) {
                                  if (notification is UserScrollNotification) {}
                                  return false;
                                },
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  controller: scrollController,
                                  // scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //  print("몇 번 그리나요? - ListView.separated");
                                    final doc = docs[index];
                                    // print("doc : ${doc}");
                                    String docId = doc['id'];
                                    String name = doc['name'] ?? "";
                                    String registerDate =
                                        doc['registerDate'] ?? "";
                                    String phoneNumber =
                                        doc['phoneNumber'] ?? "";
                                    String registerType =
                                        doc['registerType'] ?? "";
                                    String goal = doc['goal'] ?? "";
                                    int memberDayLessonCount =
                                        doc['memberDaylessonCount'] ?? 0;
                                    List<String> selectedGoals =
                                        List<String>.from(
                                            doc['selectedGoals'] ?? []);
                                    String bodyAnalyzed =
                                        doc['bodyanalyzed'] ?? "";
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
                                    bool isFavorite =
                                        doc['isFavorite'] ?? false;

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
                                      isFavorite,
                                    );

                                    return BaseContainer(
                                      docId: docId,
                                      name: name,
                                      registerDate: registerDate,
                                      goal: goal,
                                      info: info,
                                      note: note,
                                      phoneNumber: phoneNumber,
                                      isActive: isActive,
                                      isFavorite: isFavorite,
                                      memberService: memberService,
                                      resultMemberList:
                                          globalVariables.resultList,
                                      memberDayLessonCount:
                                          memberDayLessonCount,

                                      /// 회원카드 선택 시 함수
                                      customFunctionOnTap: () async {
                                        String event = "onTap";
                                        String value = "회원 카드 선택";
                                        analyticLog.sendAnalyticsEvent(
                                            screenName,
                                            "${event} : ${value}",
                                            "${value} : ${userInfo.name}",
                                            "${value} 프로퍼티 인자2");
                                        // 회원 카드 선택시 MemberInfo로 이동
                                        /* await memberInfoController.getLessonDayAndActionNoteData(userInfo.uid, userInfo.docId).then((value) {
                                          globalVariables.lessonNoteGlobalList.addAll(value);
                                        }); */
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MemberInfo
                                                .getUserInfoAndActionList(
                                                    userInfo,
                                                    globalVariables.resultList,
                                                    globalVariables.actionList,
                                                    false),
                                            // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                            /* settings: RouteSettings(
                                            arguments: userInfo
                                          ), */
                                          ),
                                        ).then((result) {
                                          globalVariables.sortList();
                                          // print("MemberList : userInfo.bodyAnalyzed : ${userInfo.selectedBodyAnalyzed}");
                                          // UserInfo tmpUserInfo = result;
                                          // print("MemberList : tmpUserInfo.bodyAnalyzed : ${tmpUserInfo.selectedBodyAnalyzed}");
                                          setState(() {
                                            print(
                                                "memberList - memberinfo pop setState!!");
                                          });
                                        });
                                      },

                                      /// 노트 추가 버튼
                                      noteAddFunctionOnTap: () async {
                                        String event = "onTap";
                                        String value = "노트 추가 버튼";
                                        analyticLog.sendAnalyticsEvent(
                                            screenName,
                                            "${event} : ${value}",
                                            "${value} : ${userInfo.name}",
                                            "${value} 프로퍼티 인자2");
                                        print('노트 추가 버튼 클릭!');

                                        bool isQuickAdd = true;

                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MemberInfo
                                                .getUserInfoAndActionList(
                                                    userInfo,
                                                    globalVariables.resultList,
                                                    globalVariables.actionList,
                                                    true),
                                          ),
                                        ).then((result) {
                                          globalVariables.sortList();
                                          setState(() {
                                            print(
                                                "memberList - memberinfo pop setState!!");
                                          });
                                        });

                                        setState(() {});
                                      },
                                    ).animate().slide(
                                        begin: Offset(0, 0.5),
                                        curve: Curves.easeOut,
                                        duration: 500.ms);
                                  },
                                  separatorBuilder: ((context, index) =>
                                      SizedBox(height: 8)),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
