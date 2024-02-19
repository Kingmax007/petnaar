import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String receiverToken;
  final String chattingWith;
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final String username;
  final String bio;
  final String searchKey;
  String androidNotificationToken;

  User({
    required this.id,
    required this.searchKey,
    required this.receiverToken,
    required this.username,
    required this.photoUrl,
    required this.email,
    required this.displayName,
    required this.bio,
    required this.androidNotificationToken,
    required this.chattingWith,

  });

  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>; // Safe cast, assuming doc.data() is never null for a User document
    return User(
      receiverToken: data['receiverToken'] ?? '', // Providing default value if key doesn't exist
      chattingWith: data['chattingWith'] ?? '',
      id: data['id'] ?? '',
      searchKey: data['searchKey'] ?? '',
      username: data['username'] ?? '',
      photoUrl: data['photoURL'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      bio: data['bio'] ?? '',
      androidNotificationToken: data['androidNotificationToken'] ?? '',
    );
  }
}
