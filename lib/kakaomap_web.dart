/* import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'web_view.dart' as customWebView;
import 'globalFunction.dart';
import 'package:http/http.dart' as http;

GlobalFunction globalFunction = GlobalFunction();

class KakaoMapWeb extends StatefulWidget {
  const KakaoMapWeb({super.key});

  @override
  State<KakaoMapWeb> createState() => _KakaoMapWebState();
}

class _KakaoMapWebState extends State<KakaoMapWeb> {
  // 한 PC에서 API 서버 구동하고 안드로이드 연결 하는 경우 localhost 대신 http://10.0.2.2 로 연결
  String url = "http://10.0.2.2:5000/kakaoMap";  // "https://www.icanidevelop.com/kakaoMap";
  Set<webview.JavascriptChannel>? channel= {webview.JavascriptChannel(name: 'onClickMarker', onMessageReceived: ((message) {
    Fluttertoast.showToast(msg: message.message);
  }))};
  
  final Completer<customWebView.WebViewController> customWebViewController =
      Completer<customWebView.WebViewController>();
  late customWebView.WebViewController subWebviewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter WebView Example"),
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          Expanded(
            child: customWebView.WebView(
              initialUrl: "http://localhost:5000/kakaoMapForFlutter", // 'https://www.icanidevelop.com/kakaoMap',
              onWebViewCreated: ((controller) {
                customWebViewController.complete(controller);
              }),
            ),
          ),
          ElevatedButton(onPressed: (() {
             
             createCurrentMarker();
             setState(() {
               
             },);
            }), child: Text("현재 위치 표시"))
        ],
      ),
    );
  }

  void createCurrentMarker(){
    postQueryData("플러터 API 통신 테스트!");
    globalFunction.getGeoLocationPosition().then((geoValue) => {

      print("geoValue : ${geoValue}")
        // subWebviewController.runJavascript('displayMarker(${value}, "나의 위치")')
        /* customWebViewController.future.then((value) async {
          var canBack = value.canGoBack();
          await canBack? value.goBack():'';
        },) */
    });
  }

  Future<void> postQueryData(String queryString) async {
    String urlString = 'http://localhost:5000/kakaoMapForFlutter';
    var url = Uri.parse(urlString);
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{'queryString': '${queryString}'},
    );
  }
}
 */