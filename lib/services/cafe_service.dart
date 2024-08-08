import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/cafe.dart';
import 'package:flutter/foundation.dart';
import '../widgets/kakao_map.dart';

class CafeService extends ChangeNotifier {
  List<Cafe> _cafes = [];
  List<Cafe> _filteredCafes = [];
  Cafe? _selectedCafe;
  final GlobalKey<KakaoMapState> mapKey; // KakaoMapState에 대한 글로벌 키 추가

  CafeService(this.mapKey); // 생성자 수정

  List<Cafe> get cafes => _filteredCafes.isEmpty ? _cafes : _filteredCafes;
  Cafe? get selectedCafe => _selectedCafe;

  Future<void> loadCafes() async {
    try {
      final String response =
          await rootBundle.loadString('assets/cafe_info.json');
      final List<dynamic> data = json.decode(response);

      _cafes = data.map((json) => Cafe.fromJson(json)).toList();
      _filteredCafes = List.from(_cafes);
      notifyListeners();
    } catch (e) {
      print('Error loading cafes: $e');
      // 여기에 에러 처리 로직을 추가할 수 있습니다.
      // 예: 사용자에게 알림을 표시하거나, 기본 데이터를 로드하는 등
    }
  }

  void moveToCafe(Cafe cafe) {
    _selectedCafe = cafe;
    mapKey.currentState?.moveToLocation(cafe.latitude, cafe.longitude);
    notifyListeners();
  }

  void filterCafes(Map<String, dynamic> filters) {
    _filteredCafes = _cafes.where((cafe) {
      if (filters.containsKey('hours')) {
        int minHours = int.parse(filters['hours']);
        if (cafe.hoursWeekday < minHours && cafe.hoursWeekend < minHours) {
          return false;
        }
      }

      if (filters.containsKey('maxPrice')) {
        int maxPrice = int.parse(filters['maxPrice']);
        if (cafe.price > maxPrice) {
          return false;
        }
      }

      if (filters.containsKey('minPowerSeats')) {
        int minPowerSeats = int.parse(filters['minPowerSeats']);
        if (cafe.totalPowerSeats < minPowerSeats) {
          return false;
        }
      }

      return true;
    }).toList();

    notifyListeners();
  }

  //카페마커 추가하기
  void addCafesToMap(String cafeJson) {
    mapKey.currentState?.addCafes(cafeJson);
  }

  //상호작용
  void setMapInteraction(bool enable) {
    mapKey.currentState?.setMapInteraction(enable);
  }

  void searchCafes(String query) {
    _filteredCafes = cafes
        .where((cafe) => cafe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
