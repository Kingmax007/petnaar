import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petnaar/pages/home.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(Duration(seconds: 2), _navigateToHome);
  }

  void _navigateToHome() {
    // Ensure context is still valid when timer fires
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pettogram',
              style: TextStyle(
                fontFamily: "Kalam",
                fontSize: 64.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20), // Provides spacing between the text and the image
            Container(
              width: 260.0,
              height: 60.0,
              child: Image.asset(
                'assets/images/Good doggy-bro.svg',
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
