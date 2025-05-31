import 'package:flutter/widgets.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';

import '../widgets/widgets.dart';

/// {@template link-utils}
/// Utility class for handling links and files in the app.
/// {@endtemplate}
abstract class LinkUtils {
  /// Tries to open a file from its [absolutePath].
  ///
  /// This method requests the permission to access the user media/files if
  /// they did not grant wayt such permission yet. If the request fails a
  /// dialog is shown to notify the user to grant such permission to continue.
  ///
  /// If the permission if OK but the open file fails a banner is shown is.
  ///
  /// The method returns whether the file could be opened.
  static Future<bool> maybeOpenFile({
    required BuildContext context,
    required String absolutePath,
  }) async {
    final result = await OpenFilex.open(absolutePath);
    if (result.type == ResultType.noAppToOpen && context.mounted) {
      SnackBarHelper.I.showError(
        context: context,
        // FIXME: l10n
        message: 'There are no apps installed to open files with this format.',
      );
    } else if (result.type != ResultType.done && context.mounted) {
      SnackBarHelper.I.showError(
        context: context,
        // FIXME: l10n
        message: 'Cannot open the file ${basename(absolutePath)}.',
      );
    }
    return result.type == ResultType.done;
  }
}
