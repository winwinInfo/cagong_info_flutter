import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../models/cafe.dart';
import '../widgets/kakao_map.dart';
import '../widgets/cafe_detail.dart';
import '../widgets/filter_popup.dart';
import '../widgets/search_appbar.dart';

class HomeView extends StatefulWidget {
  final GlobalKey<KakaoMapState> mapKey;

  const HomeView({Key? key, required this.mapKey}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Cafe? _selectedCafe;

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
    return Consumer<CafeService>(
      builder: (context, cafeService, _) {
        return Scaffold(
          key: _scaffoldKey,
          //extendBodyBehindAppBar: true, // body를 AppBar 뒤로 확장
          backgroundColor: Colors.transparent,
          appBar: SearchAppBar(
            cafes: cafeService.cafes,
            onCafeSelected: (cafe) {
              cafeService.moveToCafe(cafe);
              _showCafeDetail(cafe);
            },
            onFilterPressed: _showFilterPopup,
            onSearch: (query) {
              cafeService.searchCafes(query);
              if (cafeService.cafes.isNotEmpty) {
                cafeService.moveToCafe(cafeService.cafes.first);
              }
            },
          ),
          //extendBodyBehindAppBar: true, // body를 AppBar 뒤로 확장
          body: Column(
            children: [
              Expanded(
                child: KakaoMap(
                  key: widget.mapKey,
                  onCafeSelected: (cafeData) {
                    final cafe = Cafe.fromJson(cafeData);
                    _showCafeDetail(cafe);
                  },
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  isInteractionDisabled: _isDrawerOpen,
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
                : Center(
                    child: Text(
                      '카페를 선택해 주세요',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
          onDrawerChanged: (isOpened) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
            cafeService.setMapInteraction(!isOpened);
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
        );
      },
    );
  }

  void _showCafeDetail(Cafe cafe) {
    setState(() {
      _selectedCafe = cafe;
    });
    _scaffoldKey.currentState!.openDrawer();
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

