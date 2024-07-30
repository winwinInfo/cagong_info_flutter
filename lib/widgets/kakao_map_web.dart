import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'dart:convert';
import 'package:flutter/material.dart';

class MapController {
  String? _mapElementId;
  String? _cafesToAdd;

  void initMap() {
    if (_mapElementId == null) {
      print("Error: mapElementId is null");
      return;
    }
    print("Initializing map with ID: $_mapElementId");
    js.context.callMethod('initializeKakaoMap', [_mapElementId, _cafesToAdd]);
  }

  void moveToLocation(double lat, double lng) {
    js.context.callMethod('moveToLocation', [lat, lng]);
  }

  void addCafes(String cafeJson) {
    _cafesToAdd = cafeJson;
    if (_mapElementId != null) {
      js.context.callMethod('addCafes', [cafeJson]);
    }
  }
}

class KakaoMapView extends StatefulWidget {
  final MapController controller;
  final Function(Map<String, dynamic>) onCafeSelected;
  final double width;
  final double height;

  const KakaoMapView({
    Key? key,
    required this.controller,
    required this.onCafeSelected,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  _KakaoMapViewState createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  late html.DivElement _mapElement;

  @override
  void initState() {
    super.initState();
    final mapElementId = 'map-${DateTime.now().millisecondsSinceEpoch}';
    widget.controller._mapElementId = mapElementId;

    _mapElement = html.DivElement()
      ..id = mapElementId
      ..style.width = '${widget.width}px'
      ..style.height = '${widget.height}px';

    html.document.body!.append(_mapElement);

    ui.platformViewRegistry
        .registerViewFactory(mapElementId, (int viewId) => _mapElement);

    // 지연된 초기화
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        print("Attempting to initialize map");
        widget.controller.initMap();
      });
    });

    js.context['onCafeSelected'] = (String cafeData) {
      Map<String, dynamic> dartMap = jsonDecode(cafeData);
      widget.onCafeSelected(dartMap);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(viewType: _mapElement.id),
    );
  }
}
