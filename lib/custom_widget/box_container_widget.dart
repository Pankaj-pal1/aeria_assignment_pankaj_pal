import 'package:flutter/material.dart';
import '../models/box_model.dart';

class BoxContainer extends StatelessWidget {
  final int n;
  final List<BoxData> boxes;
  final Function(int) onBoxTap;
  final double boxSize;
  final double boxGap;
  final bool isReverting;

  const BoxContainer({
    super.key,
    required this.n,
    required this.boxes,
    required this.onBoxTap,
    required this.boxSize,
    required this.boxGap,
    required this.isReverting,
  });

  @override
  Widget build(BuildContext context) {
    int topCount;
    int bottomCount;
    int middleBarCount;

    if (n <= 0) {
      topCount = 0;
      bottomCount = 0;
      middleBarCount = 0;
    } else if (n == 5) {
      topCount = 2;
      bottomCount = 2;
      middleBarCount = 1;
    } else if (n == 6) {
      topCount = 2;
      bottomCount = 2;
      middleBarCount = 2;
    } else if (n == 7) {
      topCount = 3;
      bottomCount = 3;
      middleBarCount = 1;
    }
    else {
      int horizontalBarLength = (n / 3.5).ceil();
      if (horizontalBarLength < 2 && n >= 5) horizontalBarLength = 2;
      if (n >= 15) horizontalBarLength = (n / 4).ceil();

      topCount = horizontalBarLength;
      bottomCount = horizontalBarLength;
      middleBarCount = n - topCount - bottomCount;

      if (middleBarCount < 1) {
        middleBarCount = 1;
        int remaining = n - middleBarCount;
        topCount = (remaining / 2).ceil();
        bottomCount = (remaining / 2).floor();
        if (topCount == 0 && n >= 1) topCount = 1;
        if (bottomCount == 0 && n >= 2) bottomCount = 1;
        if (topCount + bottomCount + middleBarCount > n && topCount > 0) topCount--;
        if (topCount + bottomCount + middleBarCount < n) topCount++;
      }
      if (topCount + bottomCount + middleBarCount != n) {
        middleBarCount = (n - 4).clamp(1, n - 2);
        int remainingForHorizontal = n - middleBarCount;
        topCount = (remainingForHorizontal / 2).ceil();
        bottomCount = remainingForHorizontal - topCount;

        if (n < 5) {
          topCount = 0;
          bottomCount = 0;
          middleBarCount = n;
        } else if (topCount < 2 || bottomCount < 2 && n > 5) {
          middleBarCount = n - 4;
          if (middleBarCount < 1) middleBarCount = 1;
          int remaining = n - middleBarCount;
          topCount = (remaining / 2).ceil().clamp(1, n - 1);
          bottomCount = (remaining / 2).floor().clamp(1, n - 1);
          bottomCount = n - topCount - middleBarCount;
        }
      }
    }

    List<Widget> topWidgets = [];
    List<Widget> middleWidgets = [];
    List<Widget> bottomWidgets = [];
    int currentIndex = 0;

    for (int i = 0; i < topCount; i++) {
      if (currentIndex < n) {
        topWidgets.add(_buildBox(currentIndex));
        currentIndex++;
      }
    }
    for (int i = 0; i < middleBarCount; i++) {
      if (currentIndex < n) {
        middleWidgets.add(_buildBox(currentIndex));
        currentIndex++;
      }
    }
    for (int i = 0; i < bottomCount; i++) {
      if (currentIndex < n) {
        bottomWidgets.add(_buildBox(currentIndex));
        currentIndex++;
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        int maxItemsPerRowInC = ((availableWidth + boxGap) / (boxSize + boxGap)).floor();
        if (maxItemsPerRowInC == 0) maxItemsPerRowInC = 1;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align 'C' to the left
            children: [
              if (topWidgets.isNotEmpty) Wrap(spacing: boxGap, runSpacing: boxGap, children: topWidgets),
              SizedBox(height: topWidgets.isNotEmpty && middleWidgets.isNotEmpty ? boxGap : 0),
              if (middleWidgets.isNotEmpty) ...middleWidgets,
              SizedBox(height: middleWidgets.isNotEmpty && bottomWidgets.isNotEmpty ? boxGap : 0),
              if (bottomWidgets.isNotEmpty) Wrap(spacing: boxGap, runSpacing: boxGap, children: bottomWidgets),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBox(int index) {
    if (index >= boxes.length) {
      return SizedBox(width: boxSize, height: boxSize);
    }
    return GestureDetector(
      onTap: isReverting ? null : () => onBoxTap(index),
      child: Container(
        width: boxSize,
        height: boxSize,
        margin: EdgeInsets.only(bottom: boxGap),
        decoration: BoxDecoration(
          color: boxes[index].color,
          border: Border.all(color: Colors.black54, width: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text('${boxes[index].id}', style: TextStyle(color: Colors.white)),
        ), // Optional: display ID
      ),
    );
  }
}