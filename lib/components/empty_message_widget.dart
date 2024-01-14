import 'package:flutter/material.dart';

class EmptyMessageWidget extends StatelessWidget {
  final String imageName;
  final String message;
  const EmptyMessageWidget(
      {super.key, required this.imageName, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.5),
      ),
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('images/$imageName'),
            fit: BoxFit.contain,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 20),
          Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              )
          )
        ],
      ),
    );
  }
}
