import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import the auth_service.dart file

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              signInWithGoogle().then((userCredential) {
                // Handle navigation or user feedback upon Google sign-in success
              }).catchError((e) {
                // Handle errors or user feedback
              });
            },
            child: Text('Sign in with Google'),
          ),
          ElevatedButton(
            onPressed: () {
              signInWithFacebook().then((userCredential) {
                // Handle navigation or user feedback upon Facebook sign-in success
              }).catchError((e) {
                // Handle errors or user feedback
              });
            },
            child: Text('Sign in with Facebook'),
          ),
        ],
      ),
    );
  }
}
