import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/cafe_service.dart';
import '../models/cafe.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cafeService = Provider.of<CafeService>(context, listen: false);
      cafeService.loadCafes();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _markers.addAll(_createMarkers());
    });
  }

  Set<Marker> _createMarkers() {
    final cafeService = Provider.of<CafeService>(context, listen: false);
    return cafeService.cafes.map((cafe) {
      return Marker(
        markerId: MarkerId(cafe.name),
        position: LatLng(cafe.latitude, cafe.longitude),
        infoWindow: InfoWindow(title: cafe.name, snippet: cafe.address),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카공여지도'),
      ),
      body: Consumer<CafeService>(
        builder: (context, cafeService, child) {
          if (cafeService.cafes.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.5665, 126.9780), // 서울 중심 좌표
                    zoom: 12,
                  ),
                  markers: _markers,
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: cafeService.cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = cafeService.cafes[index];
                    return ListTile(
                      title: Text(cafe.name),
                      subtitle: Text(cafe.address),
                      onTap: () {
                        _mapController?.animateCamera(CameraUpdate.newLatLng(
                            LatLng(cafe.latitude, cafe.longitude)));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
