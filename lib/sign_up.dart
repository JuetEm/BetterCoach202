import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';

import 'auth_service.dart';
import 'color.dart';
import 'main.dart';

bool isPswdSame = false;
bool isEmailValidate = false;
bool isPhoneValidated = false;

IconData emailUnvalidated = Icons.mail_outline_outlined;
IconData emailValidated = Icons.mark_email_read_outlined;
IconData emailValidateResult = emailUnvalidated;

IconData phoneUnvalidated = Icons.smartphone_sharp;
IconData phoneValidated = Icons.mobile_friendly_outlined;
IconData phoneValidateResult = phoneUnvalidated;

String gender = "";

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "회원가입", null),
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
                      hintText: "이메일",
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
                    obscureText: true, // 비밀번호 안보이게
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
                      hintText: "전화번호",
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

                /// 성별 입력창
                BaseTextField(
                  customController: nameController,
                  hint: "성별",
                  showArrow: false,
                  customFunction: () {},
                ),
                /// 나이 입력창
                BaseTextField(
                  customController: nameController,
                  hint: "나이",
                  showArrow: false,
                  customFunction: () {},
                ),
                /// 경력 입력창
                BaseTextField(
                  customController: nameController,
                  hint: "경력",
                  showArrow: false,
                  customFunction: () {},
                ),
                /// 근무지역 입력창
                BaseTextField(
                  customController: nameController,
                  hint: "근무지역",
                  showArrow: false,
                  customFunction: () {},
                ),
                /// 출강센터 입력창
                BaseTextField(
                  customController: nameController,
                  hint: "출강센터",
                  showArrow: false,
                  customFunction: () {},
                ),
                /// 출신협회 입력창
                BaseTextField(
                  customController: nameController,
                  hint: "출신협회",
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
                  onPressed: () {
                    // 회원가입
                    print("sign up");
                    if (isPswdSame) {
                      authService.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () {
                          // 회원가입 성공
                          print("회원가입 성공");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("회원가입 성공"),
                          ));
                          Navigator.pop(context);
                        },
                        onError: (err) {
                          // 에러 발생
                          print("회원가입 실패 : $err");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
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
}
