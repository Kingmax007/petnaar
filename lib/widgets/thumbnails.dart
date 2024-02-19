import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';


class ThumbnailTest extends StatefulWidget {
  @override
  _ThumbnailTestState createState() => _ThumbnailTestState();
}

class _ThumbnailTestState extends State<ThumbnailTest> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _requestPermissions();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/pettogram2003.appspot.com/o/Videos%2FSLN_d26d7239-6954-44e3-8bff-368bc6cc8d3f.mp4?alt=media&token=b2058bb1-0ce6-4589-a452-456627332b04',
    );
    await _controller.initialize();
    setState(() {}); // Refresh UI after video initialization
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
