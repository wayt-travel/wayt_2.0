import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import 'modal.dart';

/// Tile for a [ModalBottomSheet].
class ModalBottomSheetTile extends StatelessWidget {
  final ModalBottomSheetAction action;
  const ModalBottomSheetTile({
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (action == ModalBottomSheetActions.divider) {
      return Divider(color: context.col.onSurface.withValues(alpha: 0.16));
    }
    return ListTile(
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
      titleTextStyle: context.tt.bodyLarge?.copyWith(
        color: action.isDangerous ? context.col.error : null,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: context.tt.bodyMedium?.copyWith(
        color: action.isDangerous ? context.col.error : null,
      ),
    );
  }
}
