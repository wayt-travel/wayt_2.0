import 'package:flutter/material.dart';

import '../../../../../repositories/repositories.dart';
import '../../new_item_button.dart';
import 'text_widget_scale_icon.dart';

/// {@template text_widget_scale_button}
/// A button that displays a [TypographyFeatureScale] icon and label.
/// {@endtemplate}
class TextWidgetScaleButton extends StatelessWidget {
  /// The [TypographyFeatureScale] to display.
  final TypographyFeatureScale scale;

  /// The size of the icon.
  final double? size;

  /// The border radius of the icon.
  final BorderRadius? borderRadius;

  /// The callback to be called when the button is tapped.
  final void Function(BuildContext context)? onTap;

  /// {@macro text_widget_scale_button}
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
