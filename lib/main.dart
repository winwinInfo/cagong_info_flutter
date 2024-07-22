import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:js/js.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            HtmlElementView(viewType: 'map'),
            // Flutter 위젯들 추가
          ],
        ),
      ),
    );
  }
}

@JS()
external void addCafes(String cafes);

@override
void registerWebView() {
  final mapDiv = html.DivElement()
    ..id = 'map'
    ..style.width = '100%'
    ..style.height = '100%';
  html.document.body!.append(mapDiv);
}

// 예시 데이터
void addSampleCafes() {
  final sampleData = jsonEncode([
    {"Name": "Cafe A", "Hours_weekday": 2, "Position (Latitude)": 37.5665, "Position (Longitude)": 126.9780, "Co-work": 1},
    // 다른 카페 데이터들
  ]);
  addCafes(sampleData);
}
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:js/js.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            HtmlElementView(viewType: 'map'),
            // Flutter 위젯들 추가
          ],
        ),
      ),
    );
  }
}

@JS()
external void addCafes(String cafes);

@override
void registerWebView() {
  final mapDiv = html.DivElement()
    ..id = 'map'
    ..style.width = '100%'
    ..style.height = '100%';
  html.document.body!.append(mapDiv);
}

// 예시 데이터
void addSampleCafes() {
  final sampleData = jsonEncode([
    {"Name": "Cafe A", "Hours_weekday": 2, "Position (Latitude)": 37.5665, "Position (Longitude)": 126.9780, "Co-work": 1},
    // 다른 카페 데이터들
  ]);
  addCafes(sampleData);
}
