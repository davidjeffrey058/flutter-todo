import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 5,),
          Text(text)
        ],
      ),
    );
  }
}
