import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../models/cafe.dart';

class Sidebar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onSchoolSelect;

  const Sidebar({
    Key? key,
    required this.onSearch,
    required this.onSchoolSelect,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '카페 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                widget.onSearch(value);
              },
            ),
          ),
          ElevatedButton(
            onPressed: widget.onSchoolSelect,
            child: Text('학교 선택'),
          ),
          Expanded(
            child: Consumer<CafeService>(
              builder: (context, cafeService, child) {
                List<Cafe> filteredCafes = cafeService.cafes
                    .where((cafe) => cafe.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();
                return ListView.builder(
                  itemCount: filteredCafes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredCafes[index].name),
                      subtitle: Text(filteredCafes[index].address),
                      onTap: () {
                        // 카페 선택 시 동작
                        cafeService.moveToCafe(filteredCafes[index]);
                        Navigator.pop(context); // 사이드바 닫기
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}