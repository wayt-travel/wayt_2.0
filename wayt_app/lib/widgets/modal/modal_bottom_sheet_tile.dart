import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import 'modal.dart';

/// Tile for a [ModalBottomSheet].
class ModalBottomSheetTile extends StatelessWidget {
  /// The action of the tile.
  final ModalBottomSheetAction action;

  /// Whether the tile is dense.
  final bool dense;

  /// Creates a modal bottom sheet tile.
  const ModalBottomSheetTile({
    required this.action,
    this.dense = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (action == ModalBottomSheetActions.divider) {
      return Divider(color: context.col.onSurface.withValues(alpha: 0.16));
    }
    return ListTile(
      minTileHeight: dense ? 42 : null,
      dense: true,
      onTap: () {
        if (action.popOnTap) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        if (action.onTap != null) {
          action.onTap?.call(context);
        }
      },
      leading: action.iconData != null
          ? Icon(
              action.iconData,
              color: action.isDangerous ? context.col.error : null,
            )
          : action.leading,
      subtitle: action.subtitle != null ? Text(action.subtitle!) : null,
      title: Text(action.title),
      tileColor: Colors.transparent,
      titleTextStyle: action.titleStyle ??
          context.tt.bodyLarge?.copyWith(
            color: action.isDangerous ? context.col.error : null,
            fontWeight: FontWeight.w500,
          ),
      subtitleTextStyle: action.subtitleStyle ??
          context.tt.bodyMedium?.copyWith(
            color: action.isDangerous ? context.col.error : null,
          ),
    );
  }
}
