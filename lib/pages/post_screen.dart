import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petnaar/widgets/post.dart';
import 'package:video_player/video_player.dart';

class PostScreen extends StatefulWidget {
  final String userId;
  final String postId;

  const PostScreen({
    Key? key,
    required this.userId,
    required this.postId,
  }) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  VideoPlayerController? _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController?.dispose(); // Ensure video player is disposed to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('userPosts')
          .doc(widget.postId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(child: Text('Post not found'));
        }

        final Post post = Post.fromDocument(snapshot.data!); // Assuming Post has a fromDocument constructor

        if (post.mediaUrl.endsWith(".mp4")) {
          _videoPlayerController = VideoPlayerController.network(post.mediaUrl)
            ..initialize().then((_) {
              setState(() {}); // for video controller initialization
            });
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrangeAccent,
            centerTitle: true,
            title: const Text(
              "Pettogram",
              style: TextStyle(
                fontFamily: "Kalam",
                fontSize: 35.0,
              ),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              if (_videoPlayerController != null)
                CustomVideoPlayer(
                  videoPlayerController: _videoPlayerController!,
                  looping: true,
                  autoPlay: true,
                  showControlsOnInitialize: true,
                )
              else
              // Assuming Post widget can be directly used here. You might need to adjust based on your actual Post widget implementation.
                Container(
                  child: post,
                ),
            ],
          ),
        );
      },
    );
  }
}
