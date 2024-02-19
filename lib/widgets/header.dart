import 'package:flutter/material.dart';

AppBar header({String title = 'PetNaar', bool centerTitle = true}) {
  return AppBar(
    backgroundColor: Colors.deepOrangeAccent,
    centerTitle: centerTitle,
    title: Text(
      title,
      style: TextStyle(
        // Consider defining your fonts and styles in the theme of your MaterialApp.
        fontFamily: "Kalam",
        fontSize: 35.0,
        fontStyle: FontStyle.normal,
        // Optionally, pull colors from the theme as well for consistency.
        color: Colors.white, // Assuming white color for the text
      ),
    ),
  );
}
