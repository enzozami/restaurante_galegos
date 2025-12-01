import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmer extends StatelessWidget {
  final double height;
  final double width;

  const CardShimmer({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
