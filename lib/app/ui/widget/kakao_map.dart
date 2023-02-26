import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

import 'app/ui/widget/centerConstraintBody.dart';
import 'globalFunction.dart';

GlobalFunction globalFunction = GlobalFunction();

const String kakaoMapKey =
    'fec10c47ab2237004c266efcb7e31726'; // kakao app javascript key 작성

class KakaoMap extends StatefulWidget {
  const KakaoMap({super.key});

  @override
  State<KakaoMap> createState() => _KakaoMapState();
}

class _KakaoMapState extends State<KakaoMap> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Map Webview Test"),
      ),
      body: CenterConstrainedBody(
        child: Column(
          children: [
            KakaoMapView(
              width: size.width,
              height: size.height * 0.6,
              kakaoMapKey: kakaoMapKey,
              lat: 33.450701,
              lng: 126.570667,
              showMapTypeControl: true,
              showZoomControl: true,
              markerImageURL:
                  'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png',
              onTapMarker: (p0) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Marker is clicked")));
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  // await openKakaoMapScreen(context);
                },
                child: Text('현재 위치 찾기'))
          ],
        ),
      ),
    );
  }
}
