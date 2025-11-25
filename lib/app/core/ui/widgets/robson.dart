import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Robson extends StatelessWidget {
  const Robson({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade300, border: Border.all()),
      ),
    );
  }
}
