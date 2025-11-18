import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final int number;
  final IconData icon;
  final Color? color;

  const IconBadge({
    super.key,
    required this.number,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
          color: color,
        ),
        Visibility(
          visible: number > 0,
          child: Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              maxRadius: 6,
              backgroundColor: const Color.fromRGBO(177, 0, 0, 1),
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
