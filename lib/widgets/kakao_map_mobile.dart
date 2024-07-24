import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class MapController {
  late WebViewController _webViewController;

  void initMap() {
    // WebView에서 자동으로 호출됩니다.
  }

  void moveToLocation(double lat, double lng) {
    _webViewController.runJavascript('moveToLocation($lat, $lng)');
  }

  void addCafes(String cafeJson) {
    _webViewController.runJavascript('addCafes($cafeJson)');
  }
}

class KakaoMapView extends StatelessWidget {
  final MapController controller;
  final Function(Map<String, dynamic>) onCafeSelected;
  final double width;
  final double height;

  const KakaoMapView({
    Key? key, 
    required this.controller, 
    required this.onCafeSelected,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: WebView(
        initialUrl: 'assets/kakao_map.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          controller._webViewController = webViewController;
        },
        onPageFinished: (_) {
          controller.initMap();
        },
        javascriptChannels: {
          JavascriptChannel(
            name: 'CafeChannel',
            onMessageReceived: (JavascriptMessage message) {
              final cafeData = jsonDecode(message.message);
              onCafeSelected(cafeData);
            },
          ),
        },
      ),
    );
  }
}