import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UploadController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  UploadController({required this.userId});

  // Upload Image and return the download URL
  Future<String> uploadImage(File imageFile) async {
    String postId = Uuid().v4();
    UploadTask uploadTask = _storage.ref('post_$userId_$postId.jpg').putFile(imageFile);

    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Upload Video and return the download URL
  Future<String> uploadVideo(File videoFile) async {
    String postId = Uuid().v4();
    UploadTask uploadTask = _storage.ref('post_$userId_$postId.mp4').putFile(videoFile);

    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Create a post in Firestore
  Future<void> createPost({
    required String mediaUrl,
    String caption = "",
    String location = "",
    Map<String, dynamic>? additionalData,
  }) async {
    final postId = Uuid().v4();
    await _firestore.collection('posts').doc(postId).set({
      'postId': postId,
      'ownerId': userId,
      'mediaUrl': mediaUrl,
      'caption': caption,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': {},
      ...?additionalData, // Merge any additional data if provided
    });
  }

  // Example method to handle the entire upload process for an image
  Future<void> uploadPostWithImage({required File image, String caption = "", String location = ""}) async {
    String imageUrl = await uploadImage(image);
    await createPost(mediaUrl: imageUrl, caption: caption, location: location);
  }

  // Example method to handle the entire upload process for a video
  Future<void> uploadPostWithVideo({required File video, String caption = "", String location = ""}) async {
    String videoUrl = await uploadVideo(video);
    await createPost(mediaUrl: videoUrl, caption: caption, location: location);
  }
}
