import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:PetNaar/pages/upload.dart';
import 'package:PetNaar/pages/timeline.dart';
import 'package:PetNaar/pages/search.dart';
import 'package:PetNaar/pages/activity_feed.dart';
import 'package:PetNaar/pages/profile.dart';
// Assume currentUser is properly imported or defined

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  late User currentUser; // Ensure currentUser is defined and initialized properly

  final List<Widget> pages = [
    Timeline(currentUser: currentUser),
    Search(),
    ActivityFeed(),
    Profile(profileId: currentUser.id),
  ];

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: pages[currentIndex], // Display the selected page
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.shopping_basket),
        elevation: 0.1,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Upload(currentUser: currentUser),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesome.paw,
                color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
              ),
              onPressed: () => setBottomBarIndex(0),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
              ),
              onPressed: () => setBottomBarIndex(1),
            ),
            // Spacer for the floating action button
            SizedBox(width: size.width * 0.20),
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
              ),
              onPressed: () => setBottomBarIndex(2),
            ),
            IconButton(
              icon: Icon(
                FontAwesome.user_circle_o,
                color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
              ),
              onPressed: () => setBottomBarIndex(3),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter class remains unchanged.
