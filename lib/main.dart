import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cafe_service.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CafeService(),
      child: MyApp(),
    ),
  );
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
      home: HomeView(),
    );
  }
}