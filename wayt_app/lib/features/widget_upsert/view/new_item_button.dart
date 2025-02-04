import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';

import '../../../core/context/context.dart';

/// A button for adding a new item in a travel document.
///
/// The button displays the [child] widget and a [label] below it.
class NewItemButton extends StatelessWidget {
  final Widget child;
  final String label;
  final double? size;
  final void Function(BuildContext context)? onTap;

  const NewItemButton({
    required this.child,
    required this.label,
    super.key,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: InkWell(
        onTap: () => onTap?.call(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            child,
            $.style.insets.xs.asVSpan,
            Text(label),
          ],
        ),
      ),
    );
  }
}
