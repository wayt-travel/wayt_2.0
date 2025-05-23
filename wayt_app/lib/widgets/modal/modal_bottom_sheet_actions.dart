import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../util/sdk/sdk_candidate.dart';
import '../snack_bar/snack_bar.dart';
import 'modal.dart';
import 'modal_bottom_sheet.dart';

/// Action to be placed into a [ModalBottomSheet].
@SdkCandidate(requiresL10n: true)
class ModalBottomSheetAction {
  /// Creates a modal bottom sheet action.
  ModalBottomSheetAction({
    required this.title,
    this.subtitle,
    this.iconData,
    this.leading,
    this.onTap,
    this.popOnTap = true,
    this.titleStyle,
    this.subtitleStyle,
    this.isDangerous = false,
  }) : assert(leading == null || iconData == null, '');

  /// The title of the action.
  final String title;

  /// The optional subtitle for the action.
  final String? subtitle;

  /// The leading widget for the action.
  ///
  /// If [leading] is used, then [iconData] must be null.
  final Widget? leading;

  /// The leading icon for the action.
  ///
  /// If [iconData] is used, then [leading] must be null.
  final IconData? iconData;

  /// The callback to be called when the user taps on the action text.
  final void Function(BuildContext context)? onTap;

  /// Whether to pop the modal from the root navigator during the
  /// [onTap] callback. If false the responsibility to pop the modal from
  /// the root navigator is delegated to the caller.
  final bool popOnTap;

  /// The style of the text.
  final TextStyle? titleStyle;

  /// The style of the subtitle text.
  final TextStyle? subtitleStyle;

  /// Indicates if the actions is dangerous (e.g. delete item).
  ///
  /// Dangerous action have red text color.
  final bool isDangerous;

  /// Creates a copy of this action with the given fields replaced with the
  /// new values.
  ModalBottomSheetAction copyWith({
    String? title,
    String? subtitle,
    IconData? iconData,
    Widget? leading,
    void Function(BuildContext context)? onTap,
    bool? popOnTap,
    bool? isDangerous,
  }) {
    return ModalBottomSheetAction(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconData: iconData ?? this.iconData,
      leading: leading ?? this.leading,
      onTap: onTap ?? this.onTap,
      popOnTap: popOnTap ?? this.popOnTap,
      isDangerous: isDangerous ?? this.isDangerous,
    );
  }
}

/// Class containing common actions for a [ModalBottomSheet].
///
/// Usually you want to copy the chosen action using the
/// [ModalBottomSheetAction.copyWith] method to define a new `onTap` callback.
abstract class ModalBottomSheetActions {
  /// Action used to specify to insert a divider between actions.
  static final divider = ModalBottomSheetAction(title: '');

  /// Action to delete an item.
  static ModalBottomSheetAction delete(BuildContext context) {
    return ModalBottomSheetAction(
      // FIXME: l10n
      title: 'Delete',
      iconData: Icons.delete_forever_rounded,
      isDangerous: true,
      onTap: (context) => SnackBarHelper.I.showError(
        context: context,
        // FIXME: l10n
        message: 'context.l10n.snackBarNotImplemented',
      ),
    );
  }

  /// Action to edit an item.
  static ModalBottomSheetAction edit(BuildContext context) {
    return ModalBottomSheetAction(
      // FIXME: l10n
      title: 'Edit',
      subtitle: null,
      iconData: Icons.edit_rounded,
      titleStyle: context.tt.bodyMedium,
      onTap: (context) => SnackBarHelper.I.showWarning(
        context: context,
        // FIXME: l10n
        message: 'context.l10n.snackBarNotImplemented',
      ),
    );
  }
}
