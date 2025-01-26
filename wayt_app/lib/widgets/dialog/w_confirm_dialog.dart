import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

/// A dialog that prompt the user a choice between two options (left/right).
abstract class WConfirmDialog {
  /// Shows a confirm dialog.
  ///
  /// Returns whether the user confirmed or not the dialog.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    Color? confirmActionColor,
    String? confirmActionText,
    String? subtitle,
    VoidCallback? onConfirm,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: subtitle != null ? Text(subtitle) : null,
            actions: [
              TextButton(
                onPressed: () => ctx.nav.pop(false),
                // FIXME: l10n
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ctx.nav.pop(true);
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: confirmActionColor,
                ),
                // FIXME: l10n
                child: Text(
                  confirmActionText ?? 'Confirm',
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
