import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'kakao_map_web.dart' if (dart.library.io) 'kakao_map_mobile.dart'
    as platform;

class KakaoMap extends StatefulWidget {
  final double width;
  final double height;
  final bool isInteractionDisabled; // 새로 추가
  final Function(Map<String, dynamic>) onCafeSelected;

  const KakaoMap({
    Key? key,
    required this.onCafeSelected,
    required this.width,
    required this.height,
    this.isInteractionDisabled = false, // 새로 추가
  }) : super(key: key);

  @override
  KakaoMapState createState() => KakaoMapState();
}

class KakaoMapState extends State<KakaoMap> {
  late final platform.MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = platform.MapController();
  }

  void moveToLocation(double lat, double lng) {
    _controller.moveToLocation(lat, lng);
  }

  void addCafes(String cafeJson) {
    _controller.addCafes(cafeJson);
  }

  // 새로운 메소드 추가
  void setMapInteraction(bool enable) {
    _controller.setMapInteraction(enable);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: platform.KakaoMapView(
        controller: _controller,
        onCafeSelected: widget.onCafeSelected,
        width: widget.width,
        height: widget.height,
        isInteractionDisabled: widget.isInteractionDisabled, //상호작용가능여부
      ),
    );
  }
}
