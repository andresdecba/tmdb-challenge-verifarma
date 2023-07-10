import 'package:flutter/material.dart';

class SelectableTile extends StatelessWidget {
  const SelectableTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: textStyles.titleMedium,
            ),
            Visibility(
              visible: isSelected,
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}
