import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:web_project/coachInfo.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/kakaomap_webview.dart';
import 'package:web_project/localavailable_Info.dart';
import 'package:web_project/locationAdd.dart';

import 'auth_service.dart';
import 'color.dart';
import 'kakao_map.dart';
import 'dart:io' show Platform;

import 'kakaomap_web.dart';

bool isPswdSame = false;
bool isEmailValidate = false;
bool isPhoneValidated = false;
bool isLocationValidated = false;

IconData emailUnvalidated = Icons.mail_outline_outlined;
IconData emailValidated = Icons.mark_email_read_outlined;
IconData emailValidateResult = emailUnvalidated;

IconData phoneUnvalidated = Icons.smartphone_sharp;
IconData phoneValidated = Icons.mobile_friendly_outlined;
IconData phoneValidateResult = phoneUnvalidated;

IconData locationUnvalidated = Icons.add_location_alt_outlined;
IconData locationValidated = Icons.place;
IconData locationValidateResult = locationUnvalidated;

enum Gender { MAN, WOMAN, NONE }

enum SubYn { YES, NO }

enum JobYn { YES, NO }

int currentAge = 30;

int displayYear = 0;
int displayMonth = 0;
int currentYear = DateTime.now().year;
int currentMonth = DateTime.now().month;
int careerYears = 3;
int careerMonths = 7;

List<LocalAvailableInfo>? tmpResultList = [];
List<String> tmpResultStringList = [];

class SignUp extends StatefulWidget {
  Map tmpLocationMap = {};
  SignUp({super.key});
  SignUp.getLocationMap(this.tmpLocationMap, {super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // 기본정보
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  // 선택정보
  TextEditingController substituteYnController = TextEditingController();
  TextEditingController jobYnController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController careerController = TextEditingController();
  TextEditingController workingAreaController = TextEditingController();
  TextEditingController classCenterController = TextEditingController();
  TextEditingController pilatesRelatedQualificationsController =
      TextEditingController();
  TextEditingController otherRelatedQualificationsController =
      TextEditingController();
  TextEditingController teacherIntroController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode classCenterFocusNode = FocusNode();
  FocusNode pilatesRelatedQualificationsFocusNode = FocusNode();
  FocusNode otherRelatedQualificationsFocusNode = FocusNode();
  FocusNode teacherIntroFocusNode = FocusNode();

  Gender gender = Gender.WOMAN;
  SubYn subYn = SubYn.YES;
  JobYn jobYn = JobYn.YES;

  final sameColor = Palette.gray95;
  final diffColor = Palette.textRed;

  Color stateColor = Palette.gray95;

  String password = "";
  String psaswordCheck = "";

  void setTextColor() {
    setState(() {
      stateColor = isPswdSame ? sameColor : diffColor;
    });
  }

  void setEmailIcon() {
    setState(() {
      emailValidateResult = isEmailValidate ? emailValidated : emailUnvalidated;
    });
  }

  void setPhoneIcon() {
    setState(() {
      phoneValidateResult =
          isPhoneValidated ? phoneValidated : phoneUnvalidated;
    });
  }

  void setLocationIcon() {
    setState(() {
      locationValidateResult =
          isLocationValidated ? locationValidated : locationUnvalidated;
    });
  }

  @override
  Widget build(BuildContext context) {
    displayYear = getCareer(careerYears, careerMonths)[0];
    displayMonth = getCareer(careerYears, careerMonths)[1];

    // selectedGoals 값 반영하여 FilterChips 동적 생성
    var localInfoChips = [];
    localInfoChips = makeChips(
        localInfoChips, tmpResultStringList, Palette.backgroundOrange);
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "회원가입", () {
            Navigator.pop(context);
          }),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 32),

                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    "가입하실 이메일과 정보를 입력해주세요",
                    style: TextStyle(
                        color: Palette.gray66,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      '기본정보',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Palette.gray00,
                      ),
                    ),
                    Text('*',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Palette.buttonOrange,
                        ))
                  ],
                ),

                SizedBox(height: 10),
                Divider(height: 1),
                // SizedBox(height: 10),
                /// 이름 입력창
                BaseTextField(
                  customController: nameController,
                  customFocusNode: nameFocusNode,
                  hint: "이름",
                  showArrow: false,
                  customFunction: () {},
                ),

                /// 이메일
                /* TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "이메일"),
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "이메일",
                      suffixIcon: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(emailValidateResult),
                        label: Text("인증하기"),
                      ),
                      hintText: "better@coach.com",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                /// 비밀번호
                /* TextField(
                  controller: passwordController,
                  obscureText: true, // 비밀번호 안보이게
                  decoration: InputDecoration(hintText: "비밀번호"),
                ), */
                BaseTextField(
                  customController: passwordController,
                  customFocusNode: passWordFocusNode,
                  hint: "비밀번호",
                  showArrow: false,
                  customFunction: () {},
                ),

                /// 비밀번호 확인
                /* TextField(
                  controller: passwordCheckController,
                  obscureText: true, // 비밀번호 안보이게
                  style: TextStyle(color: stateColor),
                  decoration: isSame
                      ? InputDecoration(hintText: "비밀번호 확인")
                      : InputDecoration(
                          hintText: "비밀번호 확인",
                          hintStyle: TextStyle(color: Colors.red),
                        ),
                  onChanged: (text) {
                    password = passwordController.text;
                    print(text);
                    print(password);
                    if (password == text) {
                      isSame = true;
                    } else {
                      isSame = false;
                    }
                    print(isSame);

                    setTextColor();
                  },
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    obscureText: true, // 비밀번호 안보이게
                    style: TextStyle(fontSize: 14, color: stateColor),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: passwordCheckController,
                    decoration: InputDecoration(
                      labelText: "비밀번호 확인",
                      hintText: "비밀번호 확인",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: stateColor,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                      password = passwordController.text;
                      print(text);
                      print(password);
                      if (password == text) {
                        isPswdSame = true;
                      } else {
                        isPswdSame = false;
                      }
                      print(isPswdSame);

                      setTextColor();
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                // 전화번호
                /* TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  autocorrect: true,
                  // inputFormatters: [ (RegExp('[0-9]')),],
                  decoration: InputDecoration(hintText: "전화번호"),
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "전화번호",
                      suffixIcon: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(phoneValidateResult),
                        label: Text("인증하기"),
                      ),
                      hintText: "01077779999",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                      /* setState(() {
                        phoneNumberController.text = text.replaceAllMapped(
                            RegExp(r'(\d{3})(\d{3,4})(\d{4})'),
                            (m) => '${m[1]}-${m[2]}-${m[3]}');
                      }); */
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Text(
                      '선택정보',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Palette.gray00,
                      ),
                    ),
                    Text('*',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Palette.buttonOrange,
                        ))
                  ],
                ),

                SizedBox(height: 10),
                Divider(height: 1),

                /// 대강 정보 알림 신청 여부 입력창
                /* BaseTextField(
                  customController: substituteYnController,
                  hint: "대강 정보 알림 신청",
                  showArrow: false,
                  customFunction: () {},
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: substituteYnController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      suffixIcon: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                "대강 정보 \r\n알림 신청",
                                style: TextStyle(
                                    fontSize: 14, color: Palette.gray95),
                              ),
                            )),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  '네',
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.gray95),
                                ),
                                value: SubYn.YES,
                                groupValue: subYn,
                                onChanged: (value) {
                                  setState(() {
                                    subYn = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  '아니오',
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.gray95),
                                ),
                                value: SubYn.NO,
                                groupValue: subYn,
                                onChanged: (value) {
                                  setState(() {
                                    subYn = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                /// 구인/구직 정보 알림 신청 여부 입력창
                /* BaseTextField(
                  customController: jobYnController,
                  hint: "구인/구직 정보 알림 신청",
                  showArrow: false,
                  customFunction: () {},
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: jobYnController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      suffixIcon: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                "구인/구직 정보 \r\n알림 신청",
                                style: TextStyle(
                                    fontSize: 14, color: Palette.gray95),
                              ),
                            )),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  '네',
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.gray95),
                                ),
                                value: JobYn.YES,
                                groupValue: jobYn,
                                onChanged: (value) {
                                  setState(() {
                                    jobYn = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  '아니오',
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.gray95),
                                ),
                                value: JobYn.NO,
                                groupValue: jobYn,
                                onChanged: (value) {
                                  setState(() {
                                    jobYn = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                /// 성별 입력창
                /* BaseTextField(
                  customController: genderController,
                  hint: "성별",
                  showArrow: false,
                  customFunction: () {},
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: jobYnController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      suffixIcon: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                "성별",
                                style: TextStyle(
                                    fontSize: 14, color: Palette.gray95),
                              ),
                            )),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  '여성',
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.gray95),
                                ),
                                value: Gender.WOMAN,
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: Text(
                                  '남성',
                                  style: TextStyle(
                                      fontSize: 14, color: Palette.gray95),
                                ),
                                value: Gender.MAN,
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                /// 나이 입력창
                /* BaseTextField(
                  customController: ageController,
                  hint: "나이",
                  showArrow: false,
                  customFunction: () {},
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: ageController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      suffixIcon: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                "나이 \r\n${currentAge} 세",
                                style: TextStyle(
                                    fontSize: 14, color: Palette.gray95),
                              ),
                            )),
                            NumberPicker(
                              minValue: 0,
                              maxValue: 200,
                              value: currentAge,
                              step: 1,
                              axis: Axis.horizontal,
                              onChanged: (age) {
                                setState(() {
                                  currentAge = age;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                /// 경력 입력창
                /* BaseTextField(
                  customController: careerController,
                  hint: "경력",
                  showArrow: false,
                  customFunction: () {},
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.done,
                    controller: careerController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      suffixIcon: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                              child: Text(
                                "경력\r\n${displayYear} 년 ${displayMonth} 월 부터" +
                                    "\r\n${currentYear} 년 ${currentMonth} 월 까지" +
                                    "\r\n총 ${careerYears * 12 + careerMonths} 개월 차",
                                style: TextStyle(
                                    fontSize: 14, color: Palette.gray95),
                              ),
                            )),
                            NumberPicker(
                              minValue: 1,
                              maxValue: 100,
                              value: careerYears,
                              step: 1,
                              axis: Axis.vertical,
                              itemHeight: 40,
                              onChanged: (years) {
                                setState(() {
                                  careerYears = years;
                                  displayYear =
                                      getCareer(careerYears, careerMonths)[0];
                                  displayMonth =
                                      getCareer(careerYears, careerMonths)[1];
                                });
                              },
                            ),
                            Text(
                              "년",
                              style: TextStyle(
                                  fontSize: 14, color: Palette.gray95),
                            ),
                            NumberPicker(
                              minValue: 1,
                              maxValue: 11,
                              value: careerMonths,
                              step: 1,
                              axis: Axis.vertical,
                              itemHeight: 40,
                              onChanged: (months) {
                                setState(() {
                                  careerMonths = months;
                                });
                              },
                            ),
                            Text(
                              "개월",
                              style: TextStyle(
                                  fontSize: 14, color: Palette.gray95),
                            ),
                          ],
                        ),
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),

                /// 근무 가능지역 입력창
                /* BaseTextField(
                  customController: workingAreaController,
                  hint: "근무 가능지역",
                  showArrow: false,
                  customFunction: () {},
                ), */
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                  ),
                  child: TextField(
                    // enabled: false,
                    readOnly: true,
                    style: TextStyle(fontSize: 14),
                    //focusNode: textFocus,
                    textInputAction: TextInputAction.none,
                    controller: workingAreaController,
                    decoration: InputDecoration(
                      // labelText: "근무 가능지역",
                      suffixIcon: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Text(
                              "근무 가능지역",
                              style: TextStyle(
                                  fontSize: 14, color: Palette.gray95),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              print("suffixIcon Taped");
                              if (widget.tmpLocationMap == null) {
                                print("widget.tmpLocationMap is null");
                              }
                              if (tmpResultList == null) {
                                print("tmpResultList is null");
                              }
                              final result = await showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (context, setState) {
                                    return LocationAdd.getLocationMap(
                                        widget.tmpLocationMap, tmpResultList!);
                                  },
                                ),
                              );
                              String localInfoString = "";
                              if (result != null) {
                                tmpResultList = result;
                              }

                              if (tmpResultList != null) {
                                tmpResultStringList = [];
                              }
                              tmpResultList?.sort(
                                (a, b) => a.city.compareTo(b.city),
                              );
                              tmpResultList?.forEach((element) {
                                print(
                                    "signUp result => element.city : ${element.city}, element.district : ${element.district}, element.town : ${element.town}");
                                localInfoString =
                                    "${element.city} ${element.district} ${element.town}";
                                tmpResultStringList.add(localInfoString);
                              });
                              setState(() {});
                            },
                            icon: Icon(locationValidateResult),
                            label: Text("선택하기"),
                          ),
                        ],
                      ),

                      // hintText: "선택하기",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.gray95,
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(4),
                    ),
                    onChanged: (text) {
                      // 현재 텍스트필드의 텍스트를 출력
                      // print("First text field: $text");
                    },
                    onEditingComplete: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    onTap: () {
                      print("textfield Taped");
                    },
                  ),
                ),
                Offstage(
                  offstage: localInfoChips.isEmpty,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final chip in localInfoChips)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4.0, 8, 4, 0),
                              child: chip,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 출강센터 입력창
                BaseTextField(
                  customController: classCenterController,
                  customFocusNode: classCenterFocusNode,
                  hint: "출강센터",
                  showArrow: true,
                  customFunction: () {
                    if (kIsWeb) {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => KakaoMapWebview()));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KakaoMapWeb()));
                    } else {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => KakaoMapWebview()));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => KakaoMap()));
                    }
                  },
                ),

                /// 필라테스 관련 자격증 입력창
                BaseTextField(
                  customController: pilatesRelatedQualificationsController,
                  customFocusNode: pilatesRelatedQualificationsFocusNode,
                  hint: "필라테스 관련 자격증",
                  showArrow: false,
                  customFunction: () {},
                ),

                /// 타 종목 관련 자격증 입력창
                BaseTextField(
                  customController: otherRelatedQualificationsController,
                  customFocusNode: otherRelatedQualificationsFocusNode,
                  hint: "타 종목 관련 자격증",
                  showArrow: false,
                  customFunction: () {},
                ),

                /// 강사님 소개 입력창
                BaseTextField(
                  customController: teacherIntroController,
                  customFocusNode: teacherIntroFocusNode,
                  hint: "강사님 소개",
                  showArrow: false,
                  customFunction: () {},
                ),
                SizedBox(height: 32),

                /// 회원가입 버튼
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("회원가입", style: TextStyle(fontSize: 18)),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Palette.buttonOrange,
                  ),
                  onPressed: () async {
                    CoachInfo coachInfo;

                    String name = nameController.text;
                    String email = emailController.text;
                    String phonenumber = phoneNumberController.text;
                    bool substituteYn = true; //substituteYnController.text;
                    bool jobYn = true; //jobYnController.text;
                    String gender = genderController.text;
                    String age = ageController.text;
                    String career = careerController.text;
                    List workingArea = []; //workingAreaController.text;
                    List classCenter = []; //classCenterController.text;
                    List pilatesRelatedQualifications =
                        []; //pilatesRelatedQualificationsController.text;
                    List otherRelatedQualifications =
                        []; //otherRelatedQualificationsController.text;
                    String teacherIntro = teacherIntroController.text;
                    // 회원가입
                    print("sign up");
                    if (isPswdSame) {
                      var result = await authService
                          .signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () {
                          // 회원가입 성공
                          print("회원가입 성공");
                        },
                        onError: (err) {
                          // 에러 발생
                          print("회원가입 실패 : $err");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      )
                          .then((value) {
                        print("value : ${value}");
                        coachInfo = CoachInfo(
                            value!.user!.uid.toString(),
                            name,
                            email,
                            phonenumber,
                            substituteYn,
                            jobYn,
                            gender,
                            age,
                            career,
                            workingArea,
                            classCenter,
                            pilatesRelatedQualifications,
                            otherRelatedQualifications,
                            teacherIntro);
                      }).onError((error, stackTrace) {
                        print("error : ${error}");
                        print("stackTrace : ${stackTrace}");
                      }).whenComplete(() {
                        print("회원가입 완료");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("회원가입 성공"),
                        ));
                        Navigator.pop(context);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("비밀번호를 확인 해주세요."),
                      ));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List getCareer(int careerYears, int careerMonths) {
    List result = [];
    int tmpYear = 0;
    int tmpMonth = 0;
    if (currentMonth >= careerMonths) {
      tmpYear = currentYear - careerYears;
      tmpMonth = currentMonth - careerMonths;
    } else {
      tmpYear = (currentYear - 1) - careerYears;
      tmpMonth = (12 + currentMonth) - careerMonths;
    }
    result.add(tmpYear);
    result.add(tmpMonth);

    return result;
  }

  List<dynamic> makeChips(List<dynamic> resultChips, List<String> targetList,
      Color chipBackgroundColor) {
    if (targetList.isNotEmpty) {
      resultChips = targetList
          .map((e) => FilterChip(
                label: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(e),
                    SizedBox(width: 1),
                    Icon(
                      Icons.close_outlined,
                      size: 14,
                      color: targetList.contains(e)
                          ? Palette.gray00
                          : Palette.gray99,
                    )
                  ],
                ),
                onSelected: ((value) {
                  setState(() {
                    for (int i = 0; i < targetList.length; i++) {
                      if (e == targetList[i]) {
                        tmpResultList?.removeAt(i);
                      }
                    }
                    targetList.remove(e);
                  });
                  print("value : ${value}");
                }),
                selected: targetList.contains(e),
                labelStyle: TextStyle(
                    fontSize: 14,
                    color: targetList.contains(e)
                        ? Palette.gray00
                        : Palette.gray99),
                selectedColor: chipBackgroundColor,
                backgroundColor: Colors.transparent,
                showCheckmark: false,
                side: targetList.contains(e)
                    ? BorderSide.none
                    : BorderSide(color: Palette.grayB4),
              ))
          .toList();
    }
    print("[MA] makeChips : ${resultChips}");
    return resultChips;
  }
}
