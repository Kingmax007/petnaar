import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  // Using required to ensure url is passed to the constructor.
  // If url can be null, you should change the type to `String?` and handle null cases.
  FullPhoto({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Full Image",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // Passing url directly to the FullPhotoScreen widget
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  // Using required to ensure url is passed to the constructor.
  // If url can be null, you should change the type to `String?` and handle null cases.
  FullPhotoScreen({required this.url});

  @override
  _FullPhotoScreenState createState() => _FullPhotoScreenState();
}

class _FullPhotoScreenState extends State<FullPhotoScreen> {

  // initState method is not needed if you're not doing any initialization there.

  @override
  Widget build(BuildContext context) {
    // Accessing url using widget.url
    return Container(
      child: PhotoView(imageProvider: NetworkImage(widget.url)),
    );
  }
}
