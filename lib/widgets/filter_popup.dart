import 'package:flutter/material.dart';

class FilterPopup extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilter;

  FilterPopup({required this.onApplyFilter});

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  String _selectedHours = 'all';
  double _maxPrice = 10000;
  int _minPowerSeats = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('필터 설정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _selectedHours,
            items: ['all', '1', '2', '3', '4', '5', '6', 'unlimited']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value == 'all'
                    ? '모두 보기'
                    : value == 'unlimited'
                        ? '무제한'
                        : '$value시간 이상'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedHours = newValue;
                });
              }
            },
          ),
          Slider(
            value: _maxPrice,
            min: 0,
            max: 10000,
            divisions: 20,
            label: '${_maxPrice.round()}원',
            onChanged: (double value) {
              setState(() {
                _maxPrice = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: '최소 콘센트 좌석 수'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _minPowerSeats = int.tryParse(value) ?? 0;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('적용'),
          onPressed: () {
            widget.onApplyFilter({
              'hours': _selectedHours,
              'maxPrice': _maxPrice,
              'minPowerSeats': _minPowerSeats,
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
