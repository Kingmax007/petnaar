import 'package:cloud_firestore/cloud_firestore.dart';

class PostController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new post
  Future<void> createPost({
    required String userId,
    required String mediaUrl,
    String? caption,
    String? location,
    Map<String, dynamic>? additionalData,
  }) async {
    final postId = _firestore.collection('posts').doc().id;
    await _firestore.collection('posts').doc(postId).set({
      'postId': postId,
      'ownerId': userId,
      'mediaUrl': mediaUrl,
      'caption': caption ?? '',
      'location': location ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'likes': {},
      ...?additionalData, // Merge any additional data if provided
    });
  }

  // Fetch posts by a specific user
  Future<List<DocumentSnapshot>> fetchUserPosts(String userId) async {
    final querySnapshot = await _firestore
        .collection('posts')
        .where('ownerId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs;
  }

  // Fetch a single post by postId
  Future<DocumentSnapshot> fetchPostById(String postId) async {
    return await _firestore.collection('posts').doc(postId).get();
  }

  // Update a post
  Future<void> updatePost(String postId, {String? caption, String? location, String? mediaUrl}) async {
    final updateData = <String, dynamic>{};
    if (caption != null) updateData['caption'] = caption;
    if (location != null) updateData['location'] = location;
    if (mediaUrl != null) updateData['mediaUrl'] = mediaUrl;

    await _firestore.collection('posts').doc(postId).update(updateData);
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  // Like or unlike a post
  Future<void> togglePostLike(String postId, String userId, bool like) async {
    final docRef = _firestore.collection('posts').doc(postId);
    if (like) {
      // Add userId to likes map with a value of true
      await docRef.update({
        'likes.$userId': true,
      });
    } else {
      // Remove userId from likes map
      await docRef.update({
        'likes.$userId': FieldValue.delete(),
      });
    }
  }
}
