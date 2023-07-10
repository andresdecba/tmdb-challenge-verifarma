import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    this.iconData,
    required this.text,
    this.onTap,
    this.bgColor,
    this.textColor,
    super.key,
  });

  final String text;
  final Color? textColor;
  final IconData? iconData;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.cyan,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
            const SizedBox(width: 8),
            Icon(
              iconData ?? Icons.close_rounded,
              size: 16,
              color: textColor ?? Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
