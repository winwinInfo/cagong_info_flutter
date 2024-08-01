import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/cafe.dart';
import 'package:url_launcher/url_launcher.dart';

// StatelessWidget에서 StatefulWidget으로 변경
class CafeDetail extends StatefulWidget {
  // 변경된 줄
  final Cafe cafe;

  CafeDetail({required this.cafe});

  @override
  _CafeDetailState createState() => _CafeDetailState(); // 추가된 줄
}

// 새로 추가된 State 클래스
class _CafeDetailState extends State<CafeDetail> {
  // 추가된 줄
  late YoutubePlayerController _controller; // 추가된 줄
  bool _isPlayerReady = false; // 추가된 줄
  String _errorMessage = ''; // 추가된 줄

  @override
  void initState() {
    super.initState();
    if (widget.cafe.videoUrl != null && widget.cafe.videoUrl!.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.cafe.videoUrl!);
      if (videoId == null) {
        setState(() {
          _errorMessage = '유효하지 않은 YouTube URL입니다.';
        });
        return;
      }

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(_listener);

      // 컨트롤러 초기화 후 약간의 지연을 두고 상태 로깅
      Future.delayed(Duration(seconds: 2), () {
        _logPlayerStatus();
      });
    }
  }

  void _listener() {
    // 추가된 메서드
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // 추가된 메서드
    if (widget.cafe.videoUrl != null && widget.cafe.videoUrl!.isNotEmpty) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // 추가된 메서드
    if (widget.cafe.videoUrl != null && widget.cafe.videoUrl!.isNotEmpty) {
      _controller.dispose();
    }
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
            if (widget.cafe.videoUrl != null &&
                widget.cafe.videoUrl!.isNotEmpty) // widget. 추가
              _buildVideoPlayerDebug(), // 변경된 줄
          ],
        ),
      ),
    );
  }

  // 새로운 디버그 기능이 포함된 메서드
  Widget _buildVideoPlayerDebug() {
    if (_errorMessage.isNotEmpty) {
      print('YouTube 플레이어 에러: $_errorMessage');
      return Center(child: Text('동영상을 로드할 수 없습니다.'));
    }

    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      progressColors: ProgressBarColors(
        playedColor: Colors.blue,
        handleColor: Colors.blueAccent,
      ),
      thumbnail: Container(
        color: Colors.grey[300],
        child: Center(child: Icon(Icons.play_arrow, size: 64)),
      ),
      onReady: () {
        setState(() {
          _isPlayerReady = true;
        });
        print('YouTube 플레이어 준비 완료');
        _logPlayerStatus();
      },
      onEnded: (data) {
        print('동영상 재생 종료');
      },
    );
  }

  void _logPlayerStatus() {
    if (!_isPlayerReady) return;

    print('플레이어 상태: ${_controller.value.playerState}');
    print('에러 발생: ${_controller.value.hasError ? "예" : "아니오"}');
    if (_controller.value.hasError) {
      print('에러 메시지: ${_controller.value.errorCode}');
    }
    print(
        '동영상 메타데이터 로드: ${_controller.metadata.title.isNotEmpty ? "성공" : "실패"}');
    if (_controller.metadata.title.isNotEmpty) {
      print('동영상 제목: ${_controller.metadata.title}');
    }
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
