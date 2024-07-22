import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cafe.dart';

class CafeService extends ChangeNotifier {
  List<Cafe> _cafes = [];
  List<Cafe> _filteredCafes = [];

  List<Cafe> get cafes => _filteredCafes.isEmpty ? _cafes : _filteredCafes;

  Future<void> loadCafes() async {
    final String response =
        await rootBundle.loadString('assets/cafe_info.json');
    final data = await json.decode(response);
    _cafes = data.map<Cafe>((json) => Cafe.fromJson(json)).toList();
    _filteredCafes = List.from(_cafes);
    notifyListeners();
  }

  void moveToCafe(Cafe cafe) {
    // 이 메서드는 KakaoMap 위젯에서 구현된 moveToLocation 메서드를 호출해야 합니다.
    // KakaoMap 위젯에 대한 참조가 필요하므로, 이 메서드를 직접 구현하기보다는
    // HomeScreen에서 구현하는 것이 더 적절할 수 있습니다.
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
