import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final Map properties;
  const CategoryTitle({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          properties['iconData'],
          size: 30,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          properties['title'],
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
