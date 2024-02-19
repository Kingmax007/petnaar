import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:petnaar/pages/profile.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FirebaseMessaging _firebaseMessaging; // Initialize in initState
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _firebaseMessaging = FirebaseMessaging.instance;
    // Firebase Messaging configuration and listeners here
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int pageIndex) {
    _pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          Timeline(currentUser: currentUser), // Make sure currentUser is available
          Search(),
          StoryScreen(stories: stories), // Ensure stories is properly initialized
          Upload(currentUser: currentUser),
          ActivityFeed(),
          Profile(profileId: currentUser.id),
        ],
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed, // Ensures that the items do not move
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(FontAwesome.paw), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(FontAwesome.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(FontAwesome.star_o), label: 'Stories'),
          BottomNavigationBarItem(icon: Icon(FontAwesome.plus_circle), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15, // Adjusted for better alignment
              backgroundImage: CachedNetworkImageProvider(currentUser.photoUrl ?? ''),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
