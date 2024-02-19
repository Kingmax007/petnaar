import 'package:PetNaar/pages/post_screen.dart';
import 'package:PetNaar/widgets/custom_image.dart'; // Ensure this is correctly implemented
import 'package:PetNaar/widgets/post.dart'; // Ensure the Post model is correctly defined
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class PostTile extends StatefulWidget {
  final Post post;

  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.mediaUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
  }

  void _showPost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          userId: widget.post.ownerId,
          postId: widget.post.postId,
        ),
      ),
    );
  }

  Widget _profileContent(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPost(context),
      child: widget.post.mediaUrl.contains(".mp4")
          ? FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
          : cachedNetworkImage(widget.post.mediaUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 200), // Example constraint, adjust as needed
      child: _profileContent(context),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
