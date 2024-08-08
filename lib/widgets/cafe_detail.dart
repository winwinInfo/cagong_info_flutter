import 'package:flutter/material.dart';
import '../models/cafe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CafeDetail extends StatefulWidget {
  final Cafe cafe;

  CafeDetail({Key? key, required this.cafe}) : super(key: key);

  @override
  _CafeDetailState createState() => _CafeDetailState();
}

class _CafeDetailState extends State<CafeDetail> {
  YoutubePlayerController? _controller;
  bool _hasValidVideoUrl = false;

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
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
            mute: false,
            showControls: true,
            loop: false,
          ),
        );
        _hasValidVideoUrl = true;
      }
    }
  }

  @override
  void dispose() {
    // 컨트롤러가 존재하고 초기화되었을 때만 close() 호출
    if (_controller != null && _hasValidVideoUrl) {
      _controller!.close();
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
            // Text(widget.cafe.name,
            //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            _buildTextWithLineBreaks('${widget.cafe.message}'),

            SizedBox(height: 8),
            _buildAddressAndNavigationButton(),
            SizedBox(height: 8),

            _buildTextWithLineBreaks('영업 시간: ${widget.cafe.openingHours}'),
            _buildTextWithLineBreaks('평일 이용 시간: ${widget.cafe.hoursWeekday}시간'),
            _buildTextWithLineBreaks('주말 이용 시간: ${widget.cafe.hoursWeekend}시간'),
            _buildTextWithLineBreaks('가격: ${widget.cafe.price}원'),
            SizedBox(height: 16),
            _buildSeatingInfo(),
            SizedBox(height: 16),
            _buildVideoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextWithLineBreaks(String text) {
    return Text(
      text.replaceAll('\\n', '\n'),
      style: TextStyle(height: 1.5), // 줄 간격을 조절합니다.
    );
  }

  Widget _buildAddressAndNavigationButton() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '주소: ${widget.cafe.address}',
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        SizedBox(width: 16), // 텍스트와 버튼 사이의 간격
        ElevatedButton(
          child: Text('길찾기'),
          onPressed: () => _launchMaps(widget.cafe.id, widget.cafe.name),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('좌석 정보:', style: TextStyle(fontWeight: FontWeight.bold)),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Text('종류', textAlign: TextAlign.center),
              Text('좌석 수', textAlign: TextAlign.center),
              Text('콘센트', textAlign: TextAlign.center),
            ]),
            ...widget.cafe.seatingInfo
                .map((seat) => TableRow(children: [
                      Text(seat.type, textAlign: TextAlign.center),
                      Text(seat.count.toString(), textAlign: TextAlign.center),
                      Text(seat.powerCount.toString(),
                          textAlign: TextAlign.center),
                    ]))
                .toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    if (_hasValidVideoUrl && _controller != null) {
      return AspectRatio(
        aspectRatio: 9 / 16,
        child: YoutubePlayerControllerProvider(
          controller: _controller!,
          child: YoutubePlayer(
            controller: _controller!,
          ),
        ),
      );
    } else {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.video_library, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                '이 카페에 대한 동영상이 아직 없습니다.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
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
