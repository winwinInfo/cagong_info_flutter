import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cafe_service.dart';
import 'views/home_view.dart';
import 'widgets/kakao_map.dart';

void main() {
  final mapKey = GlobalKey<KakaoMapState>();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CafeService(mapKey),
      child: MyApp(mapKey: mapKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<KakaoMapState> mapKey;

  const MyApp({Key? key, required this.mapKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '카공여지도',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Noto Sans KR',
      ),
      home: HomeView(mapKey: mapKey),
    );
  }
}
