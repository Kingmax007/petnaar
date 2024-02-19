import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  const ActivityFeedItem({
    required this.username,
    required this.userId,
    required this.type,
    required this.mediaUrl,
    required this.postId,
    required this.userProfileImg,
    required this.commentData,
    required this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'] ?? '',
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mediaPreview = _configureMediaPreview(context);
    String activityItemText = _configureActivityItemText();

    return ListTile(
      leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(userProfileImg)),
      title: Text('$username $activityItemText', overflow: TextOverflow.ellipsis),

      subtitle: Text(timeago.TimeAgo.getTimeAgo(timestamp.toDate())),
      trailing: mediaPreview,
      onTap: () => showPost(context, userId: userId, postId: postId),
    );
  }

  Widget _configureMediaPreview(BuildContext context) {
    // Configure media preview based on type
    // Implementation depends on the specific media type handling
    return Container(); // Placeholder
  }

  String _configureActivityItemText() {
    // Configure activity item text based on type
    // Implementation depends on the specific type handling
    return ''; // Placeholder
  }
}
