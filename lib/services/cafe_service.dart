import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import '../models/cafe.dart';

class CafeService with ChangeNotifier {
  List<Cafe> _cafes = [];
  List<Cafe> get cafes => _cafes;

  Future<void> loadCafes() async {
    try {
      final jsonString = await rootBundle.loadString('assets/cafe_info.json');
      final jsonResponse = json.decode(jsonString) as List;
      _cafes = jsonResponse.map((jsonCafe) => Cafe.fromJson(jsonCafe)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading cafes: $e');
    }
  }

  List<Cafe> searchCafes(String query) {
    return _cafes
        .where((cafe) => cafe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 여기에 필터링 메서드를 추가할 수 있습니다.
}
