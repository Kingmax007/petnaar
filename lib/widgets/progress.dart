import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShimmerList(),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount = 4; // Define the number of shimmer items

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          // Calculate time offset dynamically for each item
          final int time = 800 + (index * 100);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300]!,
              period: Duration(milliseconds: time),
              child: ShimmerLayout(),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double containerHeight = 15;
    const double containerWidth = 280;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 100,
          width: 82,
          color: Colors.grey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: containerHeight, width: containerWidth, color: Colors.grey),
            SizedBox(height: 5),
            Container(height: containerHeight, width: containerWidth * 0.85, color: Colors.grey),
            SizedBox(height: 5),
            Container(height: containerHeight, width: containerWidth * 0.75, color: Colors.grey),
            SizedBox(height: 5),
            Container(height: containerHeight, width: containerWidth * 0.5, color: Colors.grey),
          ],
        )
      ],
    );
  }
}
