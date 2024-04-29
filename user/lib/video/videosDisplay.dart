import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  final String videoUrl;

  const VideoPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Center(
        child: VideoPlayerWidget(videoUrl: videoUrl),
      ),
    );
  }

  VideoPlayerWidget({required String videoUrl}) {}
}
