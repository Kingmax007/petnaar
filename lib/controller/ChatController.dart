import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController {
  final FirebaseFirestore _firestore;

  ChatController({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Function to send a message
  Future<void> sendMessage({
    required String chatId,
    required Map<String, dynamic> messageData,
  }) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      ...messageData,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Function to fetch messages for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Function to create or check existing chat
  Future<String> getOrCreateChat(String userId, String peerId) async {
    String chatId;
    final chatQuery = await _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .where('participants', arrayContains: peerId)
        .limit(1)
        .get();

    if (chatQuery.docs.isEmpty) {
      // Create a new chat if it doesn't exist
      final docRef = await _firestore.collection('chats').add({
        'participants': [userId, peerId],
        'timestamp': FieldValue.serverTimestamp(),
      });
      chatId = docRef.id;
    } else {
      // Use the existing chat
      chatId = chatQuery.docs.first.id;
    }
    return chatId;
  }
}
