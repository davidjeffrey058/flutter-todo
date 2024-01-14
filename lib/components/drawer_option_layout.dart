import 'package:flutter/material.dart';

class DrawerOptionLayout extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final void Function()? optionOnPressed;
  final int? listLength;

  const DrawerOptionLayout(
      {super.key,
      required this.name,
      this.optionOnPressed,
      required this.icon,
      required this.color,
      required this.isSelected,
      this.listLength});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
      child: InkWell(
        onTap: optionOnPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(name),
              const Expanded(
                child: SizedBox(),
              ),
              if(listLength != null)Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                child: Text(
                  '$listLength',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
