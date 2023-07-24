import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.txtController,
    this.onChange,
    this.hintText,
    this.keyboardType,
    this.leading,
    this.labelText,
    this.onTap,
  });

  final TextEditingController txtController;
  final OnChangeFnct? onChange;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? leading;
  final String? labelText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Center(
        child: Container(
          //margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Row(
            children: [
              leading ??
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
              const SizedBox(width: 10),
              Expanded(
                child: Center(
                  child: TextField(
                    controller: txtController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: keyboardType ?? TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: hintText,
                      labelText: labelText,
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: onChange != null ? (text) => onChange!(text) : null,
                    onTap: onTap != null ? () => onTap!() : null,
                  ),
                ),
              ),
              if (txtController.text.isNotEmpty)
                IconButton(
                  onPressed: () => txtController.clear(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef OnChangeFnct = void Function(String text);
