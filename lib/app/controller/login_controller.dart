import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as GL;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:web_project/app/ui/page/loginSplash.dart';
import 'dart:io' show HttpHeaders, Platform;

import '../data/provider/firebase_auth_remote_data_resource.dart';

class LoginController {
  bool isKakaoInstalled = false;

  final FA.FirebaseAuth _firebaseAuth = FA.FirebaseAuth.instance;
  final GL.GoogleSignIn _googleSignIn = GL.GoogleSignIn();
  late FA.User currentUser;

  String? email = "";
  String? url = "";
  String? name = "";

  Future<FA.User?> googleSignIn(BuildContext context) async {
    final GL.GoogleSignInAccount? account;
    if (kIsWeb) {
      account = await GL.GoogleSignIn(
              clientId:
                  '417922293739-s126kapoqnnpsddig5bht1dkmiclne44.apps.googleusercontent.com')
          .signIn();
    } else {
      account = await _googleSignIn.signIn();
    }

    // 로그인 정보를 불러오는 동안 스플래시 이미지로 로딩중 정보 전달
    showLoginSplash(context);

    final GL.GoogleSignInAuthentication googleAuth =
        await account!.authentication;

    

    final FA.AuthCredential authCredential = FA.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final FA.UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(authCredential);
    final FA.User? user = userCredential.user;

    currentUser = _firebaseAuth.currentUser!;
    print(
        "google log in : currentUser email : ${currentUser.email}, currentUser photoURL : ${currentUser.photoURL}, currentUser displayName : ${currentUser.displayName}");

    email = user?.email;
    url = user?.photoURL;
    name = user?.displayName;

    print("google log in : email : ${email}, url : ${url}, name : ${name}");

    return user;
  }

  Future<FA.User?> kakaoSignIn(BuildContext context) async {
    final _firebaseauthRemoteDataResource = FirebaseAuthRemoteDataSource();

    User? user;
    isKakaoInstalled = await isKakaoTalkInstalled();
    print("isKakaoInstalled : ${isKakaoInstalled}");
    
    OAuthToken token = isKakaoInstalled
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();
    
    // 로그인 정보를 불러오는 동안 스플래시 이미지로 로딩중 정보 전달
    showLoginSplash(context);

    print("NATIVE - 카카오톡으로 로그인 성공 - token : ${token}");
    user = await UserApi.instance.me();

    /* final url = Uri.https('kapi.kakao.com', '/v2/user/me');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'},
    ); */

    print("user.id : ${user?.id}");
    print("user.kakaoAccount?.email : ${user?.kakaoAccount?.email}");
    print(
        "user.kakaoAccount?.profile?.nickname : ${user?.kakaoAccount?.profile?.nickname}");
    print(
        "user?.kakaoAccount?.profile?.profileImageUrl : ${user?.kakaoAccount?.profile?.profileImageUrl}");

    /* final profileInfo = json.decode(response.body);
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

    String? id = profileInfo['id'].toString();
    String? nickname = profileInfo['properties']['nickname'];
    String? email = profileInfo['kakao_account']['email'];
    String? photoURL = profileInfo['kakao_account']['profileImageUrl']; */

    String? id = user?.id.toString();
    String? email = user?.kakaoAccount?.email.toString();
    String? name = user?.kakaoAccount?.profile?.nickname.toString();
    String? photoURL = user?.kakaoAccount?.profile?.profileImageUrl.toString();

    final customToken =
        await _firebaseauthRemoteDataResource.createCustomToken({
      'uid': id,
      'displayName': name,
      'email': email,
      'photoURL': photoURL ?? '',
    });

    final FA.UserCredential userCredential =
        await FA.FirebaseAuth.instance.signInWithCustomToken(customToken);
        // await FA.FirebaseAuth.instance.signInWithCredential(customToken as FA.AuthCredential);

    final FA.User? fUser = userCredential.user;

    currentUser = _firebaseAuth.currentUser!;
    print(
        "kakao login : currentUser email : ${currentUser.email}, currentUser photoURL : ${currentUser.photoURL}, currentUser displayName : ${currentUser.displayName}");

    String? fEmail = fUser?.email;
    String? fUrl = fUser?.photoURL;
    String? fName = fUser?.displayName;

    print(
        "kakao login : fUser email : ${fEmail}, fUser url : ${fUrl}, fUser name : ${fName}");

    return fUser;
  }
}
