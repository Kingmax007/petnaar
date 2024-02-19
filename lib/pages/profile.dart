import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petnaar/widgets/post.dart';

class Profile extends StatefulWidget {
  final String profileId;

  const Profile({Key? key, required this.profileId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  Future<void> _getProfileData() async {
    setState(() => isLoading = true);

    await _getProfilePosts();
    await _getFollowers();
    await _getFollowing();
    _checkIfFollowing();

    setState(() => isLoading = false);
  }

  Future<void> _getProfilePosts() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('ownerId', isEqualTo: widget.profileId)
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      postCount = snapshot.docs.length;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  Future<void> _getFollowers() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('followers')
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();

    setState(() => followerCount = snapshot.docs.length);
  }

  Future<void> _getFollowing() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();

    setState(() => followingCount = snapshot.docs.length);
  }

  void _checkIfFollowing() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('followers')
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUser.id) // Assuming currentUser is a global variable holding the current user's data
        .get();

    setState(() => isFollowing = doc.exists);
  }

  Widget _buildProfileButton() {
    final bool isProfileOwner = currentUser.id == widget.profileId;

    return isProfileOwner
        ? OutlinedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfile(currentUserId: currentUser.id),
        ),
      ),
      child: const Text('Edit Profile'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
    )
        : isFollowing
        ? _buildFollowButton('Unfollow', _handleUnfollowUser)
        : _buildFollowButton('Follow', _handleFollowUser);
  }

  Widget _buildFollowButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: isFollowing ? Colors.grey : Colors.blue,
      ),
    );
  }

  void _handleUnfollowUser() async {
    setState(() => isFollowing = false);

    // Unfollow logic
  }

  void _handleFollowUser() async {
    setState(() => isFollowing = true);

    // Follow logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
        children: <Widget>[
          // Profile header here
          _buildProfileButton(),
          Divider(),
          // Profile posts here
        ],
      ),
    );
  }
}
