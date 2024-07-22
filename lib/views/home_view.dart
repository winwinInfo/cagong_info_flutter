import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../models/cafe.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cafeService = Provider.of<CafeService>(context, listen: false);
      cafeService.loadCafes();
    });
  }

  void _onWebViewCreated(WebViewController webViewController) {
    _webViewController = webViewController;
    _loadCafes();
  }

  void _loadCafes() async {
    final cafeService = Provider.of<CafeService>(context, listen: false);
    final cafesJson =
        jsonEncode(cafeService.cafes.map((cafe) => cafe.toJson()).toList());
    await _webViewController.runJavascript('loadCafes($cafesJson)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카공여지도'),
      ),
      body: Consumer<CafeService>(
        builder: (context, cafeService, child) {
          if (cafeService.cafes.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: WebView(
                  initialUrl: 'assets/kakao_map.html',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: _onWebViewCreated,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                      name: 'CafeChannel',
                      onMessageReceived: (JavascriptMessage message) {
                        final cafeData = jsonDecode(message.message);
                        _showCafeDetail(Cafe.fromJson(cafeData));
                      },
                    ),
                  ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: cafeService.cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = cafeService.cafes[index];
                    return ListTile(
                      title: Text(cafe.name),
                      subtitle: Text(cafe.address),
                      onTap: () {
                        _webViewController.runJavascript(
                            'moveToLocation(${cafe.latitude}, ${cafe.longitude})');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCafeDetail(Cafe cafe) {
    // 카페 상세 정보를 보여주는 로직 구현
  }
}
