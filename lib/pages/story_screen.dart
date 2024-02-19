import 'package:flutter/material.dart';
import 'package:petnaar/model/story_model.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryScreen({Key? key, required this.stories}) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late PageController _pageController;
  late AnimationController _animationController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    _loadStory(story: widget.stories[_currentIndex], animateToPage: false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      _goToPreviousStory();
    } else if (dx > 2 * screenWidth / 3) {
      _goToNextStory();
    } else {
      _togglePlayPause();
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex - 1 >= 0) {
      setState(() {
        _currentIndex -= 1;
      });
      _loadStory(story: widget.stories[_currentIndex]);
    }
  }

  void _goToNextStory() {
    if (_currentIndex + 1 < widget.stories.length) {
      setState(() {
        _currentIndex += 1;
      });
      _loadStory(story: widget.stories[_currentIndex]);
    }
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      final isPlaying = _videoController!.value.isPlaying;
      setState(() {
        if (isPlaying) {
          _videoController!.pause();
          _animationController.stop();
        } else {
          _videoController!.play();
          _animationController.forward();
        }
      });
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animationController.stop();
    _animationController.reset();

    if (story.media == MediaType.video) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(story.url)
        ..initialize().then((_) {
          setState(() {});
          _animationController.duration = _videoController!.value.duration;
          _videoController!.play();
          _animationController.forward();
        });
    } else {
      _animationController.duration = story.duration;
      _animationController.forward();
    }

    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _storyView(Story story) {
    switch (story.media) {
      case MediaType.image:
        return CachedNetworkImage(imageUrl: story.url, fit: BoxFit.cover);
      case MediaType.video:
        return _videoController != null && _videoController!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        )
            : const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          children: [
            PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: widget.stories.length,
              itemBuilder: (context, i) => _storyView(widget.stories[i]),
            ),
            // Animated bars and user info widgets can be added here
          ],
        ),
      ),
    );
  }
}

// Additional widgets like AnimatedBar and UserInfo should be refactored similarly for clarity and efficiency.
