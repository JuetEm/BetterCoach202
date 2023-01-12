import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_project/globalFunction.dart';
import 'package:webview_flutter/webview_flutter.dart';

GlobalFunction globalFunction = GlobalFunction();

class KakaoMapWebview extends StatefulWidget {
  const KakaoMapWebview({super.key});

  @override
  State<KakaoMapWebview> createState() => _KakaoMapWebviewState();
}

class _KakaoMapWebviewState extends State<KakaoMapWebview> {
  // 한 PC에서 API 서버 구동하고 안드로이드 연결 하는 경우 localhost 대신 http://10.0.2.2 로 연결
  String url = "http://10.0.2.2:5000/kakaoMap";  // "https://www.icanidevelop.com/kakaoMap";
  Set<JavascriptChannel>? channel= {JavascriptChannel(name: 'onClickMarker', onMessageReceived: ((message) {
    Fluttertoast.showToast(msg: message.message);
  }))};
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    double ration = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
        appBar: AppBar(
          title: Text("Kakao Map javascript Webview Test"),
        ),
        body: Column(
          children: [
            Expanded(
              child: WebView(
                  initialUrl: url,
                  onWebViewCreated: (controller) {
                    this.controller = controller;
                  },
                  javascriptChannels: channel,
                  javascriptMode: JavascriptMode.unrestricted),
            ),
            ElevatedButton(onPressed: (() {
             
             createCurrentMarker();
            }), child: Text("현재 위치 표시"))
          ],
        ));
  }

  void createCurrentMarker(){
    globalFunction.getGeoLocationPosition().then((value) => {
      
        controller!.runJavascript('createCurrentMarker(${value.latitude},${value.longitude})')
        //print("value : ${value}");
      
    });
  }
}
