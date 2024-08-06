import 'package:flutter/material.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/cafe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart'; // 수정됨

class CafeDetail extends StatefulWidget {
  final Cafe cafe;

  CafeDetail({Key? key, required this.cafe}) : super(key: key);

  @override
  _CafeDetailState createState() => _CafeDetailState();
}

class _CafeDetailState extends State<CafeDetail> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (widget.cafe.videoUrl != null && widget.cafe.videoUrl!.isNotEmpty) {
      final videoId =
          YoutubePlayerController.convertUrlToId(widget.cafe.videoUrl!);
      if (videoId != null) {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(showFullscreenButton: true),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.cafe.name, // widget. 추가
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.cafe.name, // widget. 추가
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('주소: ${widget.cafe.address}'), // widget. 추가
            ElevatedButton(
              child: Text('길찾기'),
              onPressed: () =>
                  _launchMaps(widget.cafe.id, widget.cafe.name), // widget. 추가
            ),
            Text('메시지: ${widget.cafe.message}'), // widget. 추가
            Text('영업 시간: ${widget.cafe.openingHours}'), // widget. 추가
            Text('평일 이용 시간: ${widget.cafe.hoursWeekday}시간'), // widget. 추가
            Text('주말 이용 시간: ${widget.cafe.hoursWeekend}시간'), // widget. 추가
            Text('가격: ${widget.cafe.price}원'), // widget. 추가
            SizedBox(height: 16),
            Text('좌석 정보:', style: TextStyle(fontWeight: FontWeight.bold)),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Text('종류', textAlign: TextAlign.center),
                  Text('좌석 수', textAlign: TextAlign.center),
                  Text('콘센트', textAlign: TextAlign.center),
                ]),
                ...widget.cafe.seatingInfo // widget. 추가
                    .map((seat) => TableRow(children: [
                          Text(seat.type, textAlign: TextAlign.center),
                          Text(seat.count.toString(),
                              textAlign: TextAlign.center),
                          Text(seat.powerCount.toString(),
                              textAlign: TextAlign.center),
                        ]))
                    .toList(),
              ],
            ),
            SizedBox(height: 16),
            if (_controller != null) // widget. 추가
              YoutubePlayerControllerProvider(
                controller: _controller!,
                child: YoutubePlayer(
                  controller: _controller!,
                  aspectRatio: 16 / 9,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponInfo(String cafeName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text('쿠폰 정보',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Image.network(
          '${cafeName}쿠폰.png', // 쿠폰 이미지 URL을 적절히 수정해야 합니다.
          errorBuilder: (context, error, stackTrace) {
            return Text('쿠폰 이미지를 불러올 수 없습니다.');
          },
        ),
      ],
    );
  }

  void _launchMaps(String cafeId, String cafeName) async {
    final url = 'https://map.kakao.com/link/to/$cafeId';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }
}
