import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/cafe_service.dart';
import 'views/home_view.dart';
import 'widgets/kakao_map.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

InAppLocalhostServer server = InAppLocalhostServer(port: 8080);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapKey = GlobalKey<KakaoMapState>();

    return ChangeNotifierProvider(
      create: (context) => CafeService(mapKey),
      child: MyApp(mapKey: mapKey),
    );
  }
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