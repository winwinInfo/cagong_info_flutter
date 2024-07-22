import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cafe.dart';

class CafeDetailScreen extends StatelessWidget {
  final Cafe cafe;

  CafeDetailScreen({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cafe.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cafe.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('주소: ${cafe.address}'),
              SizedBox(height: 8),
              ElevatedButton(
                child: Text('길찾기'),
                onPressed: () => _launchMaps(cafe.id, cafe.name),
              ),
              SizedBox(height: 16),
              Text('메시지: ${cafe.message}'),
              Text('영업 시간: ${cafe.openingHours}'),
              Text('평일 이용 시간: ${_getHoursDisplay(cafe.hoursWeekday)}'),
              Text('주말 이용 시간: ${_getHoursDisplay(cafe.hoursWeekend)}'),
              Text('가격: ${cafe.price}원'),
              SizedBox(height: 16),
              Text('좌석 정보:', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildSeatingInfoTable(),
              SizedBox(height: 16),
              if (cafe.videoUrl != null && cafe.videoUrl!.isNotEmpty)
                _buildVideoPlayer(cafe.videoUrl!),
              SizedBox(height: 16),
              if (cafe.cowork == 1) _buildCouponInfo(cafe.name),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatingInfoTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: [
          Text('종류',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('좌석 수',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('콘센트',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        ...cafe.seatingInfo
            .map((seat) => TableRow(children: [
                  Text(seat.type, textAlign: TextAlign.center),
                  Text(seat.count.toString(), textAlign: TextAlign.center),
                  Text(seat.powerCount.toString(), textAlign: TextAlign.center),
                ]))
            .toList(),
      ],
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        return YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
        );
      }
    }
    // YouTube 동영상이 아닌 경우 일반 비디오 플레이어를 사용할 수 있습니다.
    return Text('동영상을 표시할 수 없습니다.');
  }

  Widget _buildCouponInfo(String cafeName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  String _getHoursDisplay(int hours) {
    if (hours == -1) return '무제한';
    if (hours == 0) return '권장X';
    return '$hours시간';
  }

  void _launchMaps(String cafeId, String cafeName) async {
    final url = 'https://map.kakao.com/link/to/$cafeId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
