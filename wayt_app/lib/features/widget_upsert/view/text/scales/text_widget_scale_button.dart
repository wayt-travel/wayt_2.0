import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flutter/material.dart';

import '../../../../../core/context/context.dart';
import '../../../../../repositories/repositories.dart';
import 'text_widget_scale_icon.dart';

class TextWidgetScaleButton extends StatelessWidget {
  final FeatureTextStyleScale scale;
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
    return InkWell(
      onTap: () => onTap?.call(context),
      child: Column(
        children: [
          TextWidgetScaleIcon(
            scale: scale,
            size: size,
            borderRadius: borderRadius,
          ),
          $.style.insets.xs.asVSpan,
          Text(scale.getLocalizedName(context)),
        ],
      ),
    );
  }
}
