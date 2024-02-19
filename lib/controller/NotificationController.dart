import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationController {
  final FirebaseFirestore _firestore;

  NotificationController({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Function to send a new notification
  Future<void> sendNotification({
    required String receiverId,
    required Map<String, dynamic> notificationData,
  }) async {
    await _firestore.collection('notifications').doc(receiverId).collection('userNotifications').add({
      ...notificationData,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Function to fetch notifications for a specific user
  Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .doc(userId)
        .collection('userNotifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Optional: Function to mark a notification as read
  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('userNotifications')
        .doc(notificationId)
        .update({'read': true});
  }
}
