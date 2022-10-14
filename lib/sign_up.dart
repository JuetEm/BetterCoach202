import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'main.dart';

bool isSame = true;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();

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
          appBar: AppBar(
            title: Text("회원가입"),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                Center(
                  child: Text(
                    "가입하실 이메일과 비밀번호를 입력해주세요 🙂",
                    style: TextStyle(
                      fontSize: 24,
                    ),
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
                SizedBox(height: 32),

                /// 회원가입 버튼
                ElevatedButton(
                  child: Text("회원가입", style: TextStyle(fontSize: 21)),
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
