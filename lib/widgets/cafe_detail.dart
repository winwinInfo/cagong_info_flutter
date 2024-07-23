//cafe_detail.dart
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/cafe.dart';
import 'package:url_launcher/url_launcher.dart';

class CafeDetail extends StatelessWidget {
  final Cafe cafe;

  CafeDetail({required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cafe.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(cafe.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('주소: ${cafe.address}'),
            ElevatedButton(
              child: Text('길찾기'),
              onPressed: () => _launchMaps(cafe.id, cafe.name),
            ),
            Text('메시지: ${cafe.message}'),
            Text('영업 시간: ${cafe.openingHours}'),
            Text('평일 이용 시간: ${cafe.hoursWeekday}시간'),
            Text('주말 이용 시간: ${cafe.hoursWeekend}시간'),
            Text('가격: ${cafe.price}원'),
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
                ...cafe.seatingInfo
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
            if (cafe.videoUrl != null && cafe.videoUrl!.isNotEmpty)
              _buildVideoPlayer(cafe.videoUrl!),
          ],
        ),
      ),
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
