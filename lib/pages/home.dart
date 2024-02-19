import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petnaar/pages/timeline.dart';



final GoogleSignIn googleSignIn = GoogleSignIn();
final firebase_storage.FirebaseStorage storageRef = firebase_storage.FirebaseStorage.instance;
final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
final usersRef = firestoreInstance.collection('users');
final postsRef = firestoreInstance.collection('posts');
final commentsRef = firestoreInstance.collection('comments');
final activityRef = firestoreInstance.collection('feed');
final followersRef = firestoreInstance.collection('followers');
final followingRef = firestoreInstance.collection('following');
final timelineRef = firestoreInstance.collection('timeline');
final messagesRef = firestoreInstance.collection('messages');
UserModel? currentUserModel;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  int _pageIndex = 0;
  bool _isAuth = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initSignInListener();
    _configurePushNotifications();
  }

  _initSignInListener() {
    googleSignIn.onCurrentUserChanged.listen((account) {
      _handleSignIn(account);
    }, onError: (err) {
      Fluttertoast.showToast(msg: "Error signing in: $err");
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      _handleSignIn(account);
    }).catchError((err) {
      Fluttertoast.showToast(msg: "Error signing in: $err");
    });
  }

  Future<void> _handleSignIn(GoogleSignInAccount? account) async {
    if (account != null) {
      await _createUserInFirestore();
      setState(() => _isAuth = true);
    } else {
      setState(() => _isAuth = false);
    }
  }

  Future<void> _createUserInFirestore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser!;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));

      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": DateTime.now(),
      });

      doc = await usersRef.doc(user.id).get();
    }

    currentUserModel = UserModel.fromDocument(doc);
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  void _onItemTapped(int pageIndex) {
    _pageController.jumpToPage(pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Scaffold _buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          Search(),
          Upload(),
          ActivityFeed(),
          Profile(profileId: currentUserModel!.id),
        ],
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _pageIndex,
        onTap: _onItemTapped,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(FontAwesome.paw)),
          BottomNavigationBarItem(icon: Icon(FontAwesome.search)),
          BottomNavigationBarItem(icon: Icon(FontAwesome.plus_square_o)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(FontAwesome.user_circle_o)),
        ],
      ),
    );
  }

  Scaffold _buildUnAuthScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Pettogram', style: TextStyle(fontSize: 60.0, fontFamily: "Kalam")),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => googleSignIn.signIn(),
              child: Text('Login with Google', style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? _buildAuthScreen() : _buildUnAuthScreen();
  }

  void _configurePushNotifications() {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      usersRef.doc(googleSignIn.currentUser!.id).update({"androidNotificationToken": token});
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final String recipientId = message.data['recipient'];
      final String body = message.notification!.body!;
      if (recipientId == googleSignIn.currentUser!.id) {
        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body)));
      }
    });
  }
}
