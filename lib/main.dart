import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'windows_webview.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'services/cafe_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '카공여지도',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Noto Sans KR',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('카공여지도')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (kIsWeb) {
      // 웹 버전 구현
      return Text('웹 버전은 아직 구현되지 않았습니다.');
    } else if (Platform.isWindows) {
      // Windows 버전
      return WindowsWebView();
    } else if (Platform.isAndroid || Platform.isIOS) {
      // 모바일 버전 (기존 WebView 사용)
      return Text('모바일 버전은 기존 WebView를 사용합니다.');
    } else {
      // 지원되지 않는 플랫폼
      return Text('지원되지 않는 플랫폼입니다.');
    }
  }
}
