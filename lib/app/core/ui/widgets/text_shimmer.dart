import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextShimmer extends StatelessWidget {
  final double width;
  final int lines;
  const TextShimmer({
    super.key,
    required this.width,
    required this.lines,
  });

  Widget _buildLine({required double lineLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 36.0,
        width: lineLength,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<double> lineLengths = List.generate(
      lines,
      (index) {
        if (index == lines - 1) {
          return width * 0.6;
        }
        return width * 0.9;
      },
    );
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lineLengths.map((length) => _buildLine(lineLength: length)).toList(),
      ),
    );
  }
}
