import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapController {
  String? _mapElementId;
  String? _cafesToAdd;

  void initMap() {
    if (_mapElementId == null) {
      print("Error: mapElementId is null");
      return;
    }
    print("Initializing map with ID: $_mapElementId");
    print("Cafe data to add: $_cafesToAdd");
    js.context.callMethod('initMap', [_mapElementId, _cafesToAdd]);
  }

  void moveToLocation(double lat, double lng) {
    js.context.callMethod('moveToLocation', [lat, lng]);
  }

  void addCafes(String cafeJson) {
    _cafesToAdd = cafeJson;
    print("Updating cafe data: $_cafesToAdd");
    if (_mapElementId != null) {
      js.context.callMethod('addCafes', [cafeJson]);
    }
  }

  void setMarkerClickListener() {
    js.context.callMethod('setMarkerClickListener');
  }

  void setMapInteraction(bool enable) {
    js.context.callMethod('setMapInteraction', [enable]);
  }
}

class KakaoMapView extends StatefulWidget {
  final MapController controller;
  final Function(Map<String, dynamic>) onCafeSelected;
  final double width;
  final double height;
  final bool isInteractionDisabled;

  const KakaoMapView({
    Key? key,
    required this.controller,
    required this.onCafeSelected,
    required this.width,
    required this.height,
    this.isInteractionDisabled = false,
  }) : super(key: key);

  @override
  _KakaoMapViewState createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  late html.DivElement _mapElement;

  Future<void> _loadCafeData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/cafe_info.json');
      widget.controller.addCafes(jsonString);
    } catch (e) {
      print("Error loading cafe data: $e");
    }
  }

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

    // 카페 데이터 로드 및 지도 초기화
    _loadCafeData().then((_) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500), () {
          print("Attempting to initialize map");
          widget.controller.initMap();
        });
      });
    });

    // JavaScript에서 호출될 함수 정의
    js.context['onCafeSelected'] = (String cafeData) {
      Map<String, dynamic> dartMap = jsonDecode(cafeData);
      widget.onCafeSelected(dartMap);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          child: HtmlElementView(viewType: _mapElement.id),
        ),
        if (widget.isInteractionDisabled)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              onPanUpdate: (_) {},
              child: Container(color: Colors.transparent),
            ),
          ),
      ],
    );
  }

  @override
  void didUpdateWidget(KakaoMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInteractionDisabled != widget.isInteractionDisabled) {
      widget.controller.setMapInteraction(!widget.isInteractionDisabled);
    }
  }

  @override
  void dispose() {
    _mapElement.remove();
    super.dispose();
  }
}
