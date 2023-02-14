import 'package:http/http.dart' as http;

class FirebaseAuthRemoteDataSource{
  // final String url = "http://127.0.0.1:5000/auth/kakaoLogin";
  final String url = "https://icanidevelop.com/auth/kakaoLogin";

  Future<String> createCustomToken(Map<String,dynamic> user) async {
    
    final customTokenResponse = await http.post(Uri.parse(url),body: user);
    print("customTokenResponse.body : ${customTokenResponse.body}");

    return customTokenResponse.body;
    
  }
}