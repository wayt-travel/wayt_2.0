import 'package:flutter/material.dart';

import '../../../../../repositories/repositories.dart';
import '../../new_item_button.dart';
import 'text_widget_scale_icon.dart';

class TextWidgetScaleButton extends StatelessWidget {
  final TypographyFeatureScale scale;
  final double? size;
  final BorderRadius? borderRadius;
  final void Function(BuildContext context)? onTap;

  const TextWidgetScaleButton({
    required this.scale,
    super.key,
    this.size,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NewItemButton(
      label: scale.getLocalizedName(context),
      onTap: onTap,
      child: TextWidgetScaleIcon(
        scale: scale,
        size: size,
        borderRadius: borderRadius,
      ),
    );
  }
}
