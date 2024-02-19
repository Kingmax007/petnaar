import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  const Comments({
    Key? key,
    required this.postId,
    required this.postOwnerId,
    required this.postMediaUrl,
  }) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    final String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      FirebaseFirestore.instance.collection('comments').doc(widget.postId).collection('comments').add({
        "username": currentUser.username, // Ensure currentUser is accessible
        "comment": commentText,
        "timestamp": DateTime.now(),
        "avatarUrl": currentUser.photoUrl,
        "userId": currentUser.id,
        "postId": widget.postId,
      });

      if (widget.postOwnerId != currentUser.id) {
        FirebaseFirestore.instance.collection('activityFeed').doc(widget.postOwnerId).collection('feedItems').add({
          "type": "comment",
          "commentData": commentText,
          "timestamp": DateTime.now(),
          "postId": widget.postId,
          "userId": currentUser.id,
          "username": currentUser.username,
          "userProfileImg": currentUser.photoUrl,
          "mediaUrl": widget.postMediaUrl,
        });
      }

      _commentController.clear();
    }
  }

  Widget _buildComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.postId)
          .collection('comments')
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        List<Comment> comments = snapshot.data!.docs.map((doc) => Comment.fromDocument(doc)).toList();
        return ListView(
          children: comments,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Comments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildComments()),
          const Divider(),
          ListTile(
            title: TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: "Write a comment.."),
            ),
            trailing: OutlinedButton(
              onPressed: _addComment,
              child: const Text("Post"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  const Comment({
    Key? key,
    required this.username,
    required this.userId,
    required this.avatarUrl,
    required this.comment,
    required this.timestamp,
  }) : super(key: key);

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Profile(profileId: userId))),
          title: Text(comment),
          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(avatarUrl)),
          subtitle: Text(TimeAgo.getTimeAgo(timestamp.toDate())),
        ),
        const Divider(),
      ],
    );
  }
}
