import 'package:http/http.dart' as http;

class FirebaseAuthRemoteDataSource{
  // final String url = "http://172.30.1.9:5000/auth/kakaoLogin";
  final String url = "https://icanidevelop.com/auth/kakaoLogin";
  /// 테스트를 위해서 peace_and_love@kakao.com 으로 이메일로 가입해서 같은 이메일인데 uid가 달랐던 경우였음,
  /// 카카오 로그인 자동 가입시 생성하는 uid 형식 kakao:~~~~
  /// 이메일 가입 시 생성하는 uid 형식은 firebase가 생성하는 난수 값
  /// 두 uid 가 일치 하지 않아서 문제 발생 했었음

  Future<String> createCustomToken(Map<String,dynamic> user) async {
    
    final customTokenResponse = await http.post(Uri.parse(url),body: user);
    print("customTokenResponse.body : ${customTokenResponse.body}");
    print("customTokenResponse.toString() : ${customTokenResponse.toString()}");

    return customTokenResponse.body;
    
  }
}