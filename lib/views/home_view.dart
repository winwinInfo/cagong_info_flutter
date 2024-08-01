import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/kakao_map.dart';
import '../widgets/school_selector.dart';
import '../widgets/filter_popup.dart';
import '../widgets/cafe_detail.dart';
import '../models/cafe.dart';
import 'cafe_detail_view.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import 'dart:convert';

class HomeView extends StatefulWidget {
  final GlobalKey<KakaoMapState> mapKey;

  const HomeView({Key? key, required this.mapKey}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<KakaoMapState> _mapKey = GlobalKey();
  Cafe? _selectedCafe;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final cafeService = Provider.of<CafeService>(context, listen: false);
      cafeService.loadCafes().then((_) {
        final cafeJson = jsonEncode(cafeService.cafes);
        _mapKey.currentState?.addCafes(cafeJson);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('카공여지도'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: _showFilterPopup,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Consumer<CafeService>(
                  builder: (context, cafeService, child) {
                    if (cafeService.cafes.isEmpty) {
                      return CircularProgressIndicator();
                    }
                    return KakaoMap(
                      key: widget.mapKey,
                      onCafeSelected: _showCafeDetail,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      isInteractionDisabled: _isDrawerOpen,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: _selectedCafe != null
              ? Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: Text(_selectedCafe!.name),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedCafe = null;
                            });
                            _scaffoldKey.currentState!.closeDrawer();
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: CafeDetail(cafe: _selectedCafe!),
                    ),
                  ],
                )
              : Sidebar(
                  onSearch: _performSearch,
                  onSchoolSelect: _showSchoolSelector,
                ),
        ),
        onDrawerChanged: (isOpened) {
          setState(() {
            _isDrawerOpen = isOpened;
          });
          // 지도 상호작용 상태 갱신
          _mapKey.currentState?.setState(() {});
        },
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: '지도',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '카페 목록',
            ),
          ],
          onTap: _onBottomNavTap,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.my_location),
          onPressed: _getCurrentLocation,
        ),
      ),
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
    setState(() {
      _selectedCafe = cafe;
    });
    _scaffoldKey.currentState!.openDrawer();
  }

  void _performSearch(String query) {
    // TODO: 검색 로직 구현
  }

  void _showSchoolSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SchoolSelector(
        onSchoolSelected: (lat, lng) {
          _mapKey.currentState?.moveToLocation(lat, lng);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onBottomNavTap(int index) {
    // TODO: 바텀 네비게이션 탭 처리 로직 구현
  }

  void _getCurrentLocation() {
    // TODO: 현재 위치 가져오기 로직 구현
  }
}
