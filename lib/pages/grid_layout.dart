import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petnaar/widgets/post.dart';

class GridScreen extends StatelessWidget {
  final String userId;
  final String postId;

  const GridScreen({
    Key? key,
    required this.userId,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: const Text(
          "PetNaar",
          style: TextStyle(
            fontFamily: "Kalam",
            fontSize: 35.0,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('userPosts')
            .doc(postId)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgress();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Post not found'));
          }

          Post post = Post.fromDocument(snapshot.data!);
          return ListView(
            children: <Widget>[
              Container(
                child: post,
              ),
            ],
          );
        },
      ),
    );
  }
}
