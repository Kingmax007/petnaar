import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data by user ID
  Future<DocumentSnapshot> getUserData(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, String displayName, String bio, String photoUrl) async {
    return await _firestore.collection('users').doc(userId).update({
      'displayName': displayName,
      'bio': bio,
      'photoUrl': photoUrl,
    });
  }

  // Follow another user
  Future<void> followUser(String currentUserId, String userIdToFollow) async {
    // Add userIdToFollow to current user's following list
    await _firestore.collection('users').doc(currentUserId).collection('following').doc(userIdToFollow).set({});

    // Add currentUserId to userIdToFollow's followers list
    await _firestore.collection('users').doc(userIdToFollow).collection('followers').doc(currentUserId).set({});
  }

  // Unfollow another user
  Future<void> unfollowUser(String currentUserId, String userIdToUnfollow) async {
    // Remove userIdToUnfollow from current user's following list
    await _firestore.collection('users').doc(currentUserId).collection('following').doc(userIdToUnfollow).delete();

    // Remove currentUserId from userIdToUnfollow's followers list
    await _firestore.collection('users').doc(userIdToUnfollow).collection('followers').doc(currentUserId).delete();
  }

  // Check if current user is following another user
  Future<bool> isFollowingUser(String currentUserId, String otherUserId) async {
    final doc = await _firestore.collection('users').doc(currentUserId).collection('following').doc(otherUserId).get();
    return doc.exists;
  }
}
