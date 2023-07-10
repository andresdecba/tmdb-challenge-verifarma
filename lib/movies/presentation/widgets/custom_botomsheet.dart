import 'package:flutter/material.dart';

void customBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet<dynamic>(
    constraints: BoxConstraints.loose(
      Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height * 0.75,
      ),
    ),
    isDismissible: true,
    showDragHandle: true,
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    builder: (context) => child,
  );
}
