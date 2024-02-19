import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BuildVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoPlay;
  final bool showControlsOnInitialize;

  // Use required for non-nullable parameters and provide default values for optional boolean parameters
  BuildVideo({
    required this.videoPlayerController,
    this.looping = false,
    this.autoPlay = false,
    this.showControlsOnInitialize = true,
  });

  @override
  _BuildVideoState createState() => _BuildVideoState();
}

class _BuildVideoState extends State<BuildVideo> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9, // Updated aspect ratio to a more common value
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      showControls: true,
      showControlsOnInitialize: widget.showControlsOnInitialize,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
        backgroundColor: Colors.transparent,
        bufferedColor: Colors.grey.shade500,
      ),
      autoInitialize: true,
      allowFullScreen: true,
      allowMuting: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white, backgroundColor: Colors.black),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    // Do not dispose the videoPlayerController here if it's being managed outside of this widget
    super.dispose();
  }
}
