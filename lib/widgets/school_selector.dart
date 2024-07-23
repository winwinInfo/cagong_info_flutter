//school_selector.dart

import 'package:flutter/material.dart';

class SchoolSelector extends StatelessWidget {
  final Function(double, double) onSchoolSelected;

  SchoolSelector({required this.onSchoolSelected});

  final Map<String, List<double>> schoolCoordinates = {
    "성균관대": [37.5872, 126.9919],
    "경희대": [37.5955, 127.0526],
    "한국외대": [37.5972, 127.0590],
    "연세대": [37.56641, 126.9387],
    "이화여대": [37.561758, 126.946708],
    "서강대": [37.550917, 126.941011],
    "홍대": [37.55074, 126.9255],
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text('학교를 선택하세요'),
      items: schoolCoordinates.keys.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null && schoolCoordinates.containsKey(newValue)) {
          List<double> coordinates = schoolCoordinates[newValue]!;
          onSchoolSelected(coordinates[0], coordinates[1]);
        }
      },
    );
  }
}
