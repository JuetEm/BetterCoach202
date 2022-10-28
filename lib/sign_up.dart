import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/globalWidget.dart';

import 'auth_service.dart';
import 'color.dart';
import 'main.dart';

bool isSame = true;

String gender = "";

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final sameColor = Colors.black;
  final diffColor = Colors.red;

  Color stateColor = Colors.black;

  String password = "";
  String psaswordCheck = "";

  void setTextColor() {
    setState(() {
      stateColor = isSame ? sameColor : diffColor;
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
                    "가입하실 이메일과 비밀번호를 입력해주세요",
                    style: TextStyle(
                        color: Palette.gray66,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "이메일"),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  obscureText: true, // 비밀번호 안보이게
                  decoration: InputDecoration(hintText: "비밀번호"),
                ),

                /// 비밀번호 확인
                TextField(
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
                ),

                /// 전화번호
                // TextField(
                //   controller: phoneNumberController,
                //   keyboardType: TextInputType.phone,
                //   autocorrect: true,
                //   // inputFormatters: [ (RegExp('[0-9]')),],
                //   decoration: InputDecoration(hintText: "전화번호"),
                // ),

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     RadioListTile(
                //       title: Text("여자"),
                //       value: "WOMAN",
                //       groupValue: gender,
                //       onChanged: (value) {
                //         setState(() {
                //           gender = value!;
                //         });
                //       },
                //     ),
                //     RadioListTile(
                //       title: Text("여자"),
                //       value: "MAN",
                //       groupValue: gender,
                //       onChanged: (value) {
                //         setState(() {
                //           gender = value!;
                //         });
                //       },
                //     ),
                //   ],
                // ),
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
                    if (isSame) {
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
