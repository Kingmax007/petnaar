import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:petnaar/chat/pages/home_page.dart';
import 'package:petnaar/widgets/post.dart';
import 'package:petnaar/widgets/progress.dart';

class Timeline extends StatefulWidget {
  final User currentUser;

  const Timeline({Key? key, required this.currentUser}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Post> _posts = [];
  List<String> _followingList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getTimeline();
    _getFollowing();
  }

  Future<void> _getTimeline() async {
    QuerySnapshot snapshot = await _firestore
        .collection('timeline')
        .doc(widget.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();

    List<Post> posts = snapshot.docs
        .map((doc) => Post.fromDocument(doc))
        .toList();

    if (mounted) {
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    }
  }

  Future<void> _getFollowing() async {
    QuerySnapshot snapshot = await _firestore
        .collection('followers')
        .doc(widget.currentUser.id)
        .collection('userFollowing')
        .get();

    List<String> followingList = snapshot.docs.map((doc) => doc.id).toList();

    if (mounted) {
      setState(() {
        _followingList = followingList;
      });
    }
  }

  Widget _buildUsersToFollow() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        List<UserResult> userResults = [];
        snapshot.data!.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          if (widget.currentUser.id == user.id || _followingList.contains(user.id)) {
            return;
          }
          userResults.add(UserResult(user: user));
        });

        return userResults.isNotEmpty
            ? Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person_add, color: Colors.black87, size: 30.0),
                  SizedBox(width: 8.0),
                  Text(
                    "Users to Follow",
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(children: userResults),
          ],
        )
            : SizedBox.shrink();
      },
    );
  }

  Widget _buildTimeline() {
    if (_isLoading) {
      return ShimmerProgress();
    } else if (_posts.isEmpty) {
      return _buildUsersToFollow();
    } else {
      return ListView(children: _posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        title: Text("Pettogram", style: TextStyle(fontSize: 35.0)),
        actions: [
          IconButton(
            icon: Icon(FontAwesome.comments, size: 25),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen(currentUserId: widget.currentUser.id))),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _getTimeline,
        child: _buildTimeline(),
      ),
    );
  }
}
