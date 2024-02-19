import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// custom widgets and models


class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final Map<String, bool> likes;

  const Post({
    Key? key,
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.likes,
  }) : super(key: key);

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc.get('postId') ?? '',
      ownerId: doc.get('ownerId') ?? '',
      username: doc.get('username') ?? '',
      location: doc.get('location') ?? '',
      description: doc.get('description') ?? '',
      mediaUrl: doc.get('mediaUrl') ?? '',
      likes: Map<String, bool>.from(doc.get('likes') ?? {}),
    );
  }

  int get likeCount => likes.values.where((val) => val).length;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  bool _isLiked = false;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.likes[currentUserId] ?? false;
  }

  Future<void> _handleLikePost() async {
    if (_isLiked) {
      setState(() {
        widget.likes[currentUserId] = false;
        _isLiked = false;
      });
      // Update likes in Firestore and remove like from activity feed
    } else {
      setState(() {
        widget.likes[currentUserId] = true;
        _isLiked = true;
        _showHeart = true;
      });
      Timer(const Duration(milliseconds: 500), () {
        setState(() => _showHeart = false);
      });
      // Update likes in Firestore and add like to activity feed
    }
  }

  Widget _buildPostHeader() {
    return ListTile(
      leading: GestureDetector(
        onTap: () => showProfile(context, profileId: widget.ownerId),
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(currentUser.photoUrl),
        ),
      ),
      title: GestureDetector(
        onTap: () => showProfile(context, profileId: widget.ownerId),
        child: Text(widget.username, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      subtitle: Text(widget.location),
      trailing: widget.ownerId == currentUserId
          ? IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () => _handleDeletePost(context),
      )
          : null,
    );
  }

  Future<void> _handleDeletePost(BuildContext context) async {
    // Show deletion confirmation dialog and delete post if confirmed
  }

  Widget _buildPostImage() {
    return GestureDetector(
      onDoubleTap: _handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: [
          cachedNetworkImage(widget.mediaUrl),
          if (_showHeart)
            Animator(
              tween: Tween(begin: 0.8, end: 1.4),
              curve: Curves.elasticOut,
              cycles: 0,
              builder: (context, animatorState, child) => Transform.scale(
                scale: animatorState.value,
                child: Icon(Icons.favorite, size: 80, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: _handleLikePost,
              child: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, size: 28.0, color: Colors.pink),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(context, postId: widget.postId, ownerId: widget.ownerId, mediaUrl: widget.mediaUrl),
              child: Icon(FontAwesome.comment_o, size: 30.0, color: Colors.black87),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text("${widget.likeCount} likes", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text("${widget.username}:\t", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Text(widget.description)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPostHeader(),
        _buildPostImage(),
        _buildPostFooter(),
      ],
    );
  }
}

void showComments(BuildContext context, {required String postId, required String ownerId, required String mediaUrl}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Comments(postId: postId, postOwnerId: ownerId, postMediaUrl: mediaUrl),
    ),
  );
}
