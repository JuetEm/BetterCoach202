import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as GL;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show HttpHeaders, Platform;

class LoginController {
  bool isKakaoInstalled = false;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;
  final GL.GoogleSignIn _googleSignIn = GL.GoogleSignIn();
  late FA.User currentUser;

  String? email = "";
  String? url = "";
  String? name = "";

  Future<FA.User?> googleSignIn() async {
    final GL.GoogleSignInAccount? account;
    if (kIsWeb) {
      account = await GL.GoogleSignIn(
              clientId:
                  '417922293739-s126kapoqnnpsddig5bht1dkmiclne44.apps.googleusercontent.com')
          .signIn();
    } else {
      account = await _googleSignIn.signIn();
    }

    final GL.GoogleSignInAuthentication googleAuth =
        await account!.authentication;

    final FA.AuthCredential authCredential = FA.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FA.UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(authCredential);
    final FA.User? user = userCredential.user;

    currentUser = _firebaseAuth.currentUser!;

    email = user?.email;
    url = user?.photoURL;
    name = user?.displayName;

    print("email : ${email}, url : ${url}, name : ${name}");

    return user;
  }

  kakaoSignIn() async {
    isKakaoInstalled = await isKakaoTalkInstalled();
    print("isKakaoInstalled : ${isKakaoInstalled}");
    OAuthToken token = isKakaoInstalled
        ? await UserApi.instance.loginWithKakaoTalk() 
        : await UserApi.instance.loginWithKakaoAccount();
    print("NATIVE - 카카오톡으로 로그인 성공 - token : ${token}");
    final url = Uri.https('kapi.kakao.com', '/v2/user/me');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'},
    );

    final profileInfo = json.decode(response.body);
    print("profileInfo.toString() : " + profileInfo.toString());

    print("profileInfo['id'] : ${profileInfo['id']}");
    print("profileInfo['connected_at'] : ${profileInfo['connected_at']}");
    print(
        "profileInfo['properties']['nickname'] : ${profileInfo['properties']['nickname']}");
    print(
        "profileInfo['kakao_account']['email'] : ${profileInfo['kakao_account']['email']}");
    print(
        "profileInfo['kakao_account']['age_range'] : ${profileInfo['kakao_account']['age_range']}");
    print(
        "profileInfo['kakao_account']['birthday'] : ${profileInfo['kakao_account']['birthday']}");
    print(
        "profileInfo['kakao_account']['gender'] : ${profileInfo['kakao_account']['gender']}");
  }
}
