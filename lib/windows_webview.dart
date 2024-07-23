// lib/windows_webview.dart

import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class WindowsWebView extends StatefulWidget {
  @override
  _WindowsWebViewState createState() => _WindowsWebViewState();
}

class _WindowsWebViewState extends State<WindowsWebView> {
  final WebviewController _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    await _controller.initialize();
    await _controller.loadUrl('assets/kakao_map.html');
  }

  @override
  Widget build(BuildContext context) {
    return Webview(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
