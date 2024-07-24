import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/kakao_map.dart';
import '../widgets/school_selector.dart';
import '../widgets/filter_popup.dart';
import '../models/cafe.dart';
import 'cafe_detail_view.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<KakaoMapState> _mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final cafeService = Provider.of<CafeService>(context, listen: false);
      cafeService.loadCafes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CafeService>(
        builder: (context, cafeService, child) {
          if (cafeService.cafes.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // 지도 레이어 (가장 아래에 위치)
                  Positioned.fill(
                    child: KakaoMap(
                      key: _mapKey,
                      onCafeSelected: _showCafeDetail,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                  ),
                  // UI 레이어 (지도 위에 위치)
                  if (constraints.maxWidth > 600)
                    _buildDesktopUI(constraints)
                  else
                    _buildMobileUI(constraints),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDesktopUI(BoxConstraints constraints) {
    return Row(
      children: [
        Container(
          width: 300,
          color: Colors.white,
          child: Sidebar(),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  color: Colors.white.withOpacity(0.8),
                  child: SchoolSelector(
                    onSchoolSelected: (lat, lng) {
                      _mapKey.currentState?.moveToLocation(lat, lng);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 10,
                child: FloatingActionButton(
                  child: Icon(Icons.filter_list),
                  onPressed: _showFilterPopup,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileUI(BoxConstraints constraints) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            color: Colors.white.withOpacity(0.8),
            child: SchoolSelector(
              onSchoolSelected: (lat, lng) {
                _mapKey.currentState?.moveToLocation(lat, lng);
              },
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 10,
          child: FloatingActionButton(
            child: Icon(Icons.filter_list),
            onPressed: _showFilterPopup,
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.1,
          minChildSize: 0.1,
          maxChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Container(
                    height: 40,
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Sidebar(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showFilterPopup() {
    showDialog(
      context: context,
      builder: (context) => FilterPopup(
        onApplyFilter: (filters) {
          final cafeService = Provider.of<CafeService>(context, listen: false);
          cafeService.filterCafes(filters);
        },
      ),
    );
  }

  void _showCafeDetail(Map<String, dynamic> cafeData) {
    Cafe cafe = Cafe.fromJson(cafeData);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CafeDetailView(cafe: cafe),
      ),
    );
  }
}
