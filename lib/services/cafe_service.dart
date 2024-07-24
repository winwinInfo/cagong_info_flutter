import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cafe.dart';

class CafeService extends ChangeNotifier {
  List<Cafe> _cafes = [];
  List<Cafe> _filteredCafes = [];

  List<Cafe> get cafes => _filteredCafes.isEmpty ? _cafes : _filteredCafes;

  Future<void> loadCafes() async {
    try {
      final String response = await rootBundle.loadString('assets/cafe_info.json');
      //print('JSON response: $response'); // JSON 데이터 로드 확인

      final List<dynamic> data = json.decode(response);
      //print('Decoded JSON: $data'); // JSON 데이터 디코딩 확인

      _cafes = data.map((json) {
        //print('Mapping JSON: $json'); // 각 JSON 객체 매핑 확인
        return Cafe.fromJson(json);
      }).toList();

      //print('Loaded Cafes: $_cafes'); // 파싱된 객체 리스트 확인
      _filteredCafes = List.from(_cafes);
      notifyListeners();
    } catch (e) {
      //print('Error loading cafes: $e'); // 오류 메시지 출력
    }
  }

  void moveToCafe(Cafe cafe) {
    notifyListeners();
  }

  void filterCafes(Map<String, dynamic> filters) {
    _filteredCafes = _cafes.where((cafe) {
      bool passFilter = true;

      if (filters.containsKey('hours')) {
        int minHours = int.parse(filters['hours']);
        passFilter = passFilter &&
            (cafe.hoursWeekday >= minHours || cafe.hoursWeekend >= minHours);
      }

      if (filters.containsKey('maxPrice')) {
        int maxPrice = int.parse(filters['maxPrice']);
        passFilter = passFilter && (cafe.price <= maxPrice);
      }

      if (filters.containsKey('minPowerSeats')) {
        int minPowerSeats = int.parse(filters['minPowerSeats']);
        passFilter = passFilter && (cafe.totalPowerSeats >= minPowerSeats);
      }

      return passFilter;
    }).toList();

    notifyListeners();
  }
}
