import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/kakao_map.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<KakaoMapState> _mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // 태블릿이나 데스크톱 레이아웃
            return Row(
              children: [
                Container(
                  width: 300,
                  child: Sidebar(),
                ),
                Expanded(
                  child: KakaoMap(key: _mapKey),
                ),
              ],
            );
          } else {
            // 모바일 레이아웃
            return Stack(
              children: [
                KakaoMap(key: _mapKey),
                DraggableScrollableSheet(
                  initialChildSize: 0.1,
                  minChildSize: 0.1,
                  maxChildSize: 0.7,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      color: Colors.white,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Container(
                            height: 40,
                            child: Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Sidebar(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
