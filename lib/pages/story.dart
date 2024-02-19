import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class StoryScreen extends StatefulWidget {
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  void _showToast() {
    Fluttertoast.showToast(
      msg: "Pressed",
      toastLength: Fluttertoast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM, // Optional: to specify the position
      timeInSecForIosWeb: 1, // Optional: duration for iOS
      backgroundColor: Colors.grey[850], // Optional: background color
      textColor: Colors.white, // Optional: text color
      fontSize: 16.0, // Optional: font size
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Stories"),
        centerTitle: true,
      ),
      body: Center(
        child: IconButton(
          icon: Icon(Icons.add, size: 48),
          onPressed: _showToast,
        ),
      ),
    );
  }
}
