import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../models/cafe.dart'; // Cafe 모델 import 추가
import 'cafe_detail.dart';

class KakaoMap extends StatefulWidget {
  const KakaoMap({Key? key}) : super(key: key); // 생성자 수정

  @override
  KakaoMapState createState() => KakaoMapState();
}

class KakaoMapState extends State<KakaoMap> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'assets/kakao_map.html',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
        _loadCafes();
      },
      javascriptChannels: Set.from([
        JavascriptChannel(
          name: 'CafeChannel',
          onMessageReceived: (JavascriptMessage message) {
            final cafeData = jsonDecode(message.message);
            _showCafeDetail(cafeData);
          },
        ),
      ]),
    );
  }

  void moveToLocation(double lat, double lng) {
    _controller.evaluateJavascript('moveToLocation($lat, $lng)');
  }

  void _loadCafes() async {
    final cafeService = Provider.of<CafeService>(context, listen: false);
    await cafeService.loadCafes();
    final cafeJson = jsonEncode(cafeService.cafes);
    _controller.evaluateJavascript('addCafes($cafeJson)');
  }

  void _showCafeDetail(Map<String, dynamic> cafeData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CafeDetail(cafe: Cafe.fromJson(cafeData));
      },
    );
  }
}
