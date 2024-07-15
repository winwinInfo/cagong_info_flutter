import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cafe_service.dart';
import 'views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CafeService()),
      ],
      child: MaterialApp(
        title: '카공여지도',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Noto Sans KR',
        ),
        home: HomeView(),
      ),
    );
  }
}
