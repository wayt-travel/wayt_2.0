import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../util/sdk_candidate.dart';
import 'modal_bottom_sheet_actions.dart';

@SdkCandidate(
  requiresL10n: false,
  isM3Friendly: false,
)
class ModalBottomSheet {
  ModalBottomSheet.of(this.context);
  final BuildContext context;

  Future<T?> showExpanded<T>({
    required ScrollableWidgetBuilder builder,
  }) {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      clipBehavior: Clip.antiAlias,
      builder: (ctx) {
        return DraggableScrollableSheet(
          snap: true,
          snapSizes: const [],
          maxChildSize: .9,
          expand: false,
          builder: builder,
        );
      },
    );
  }

  Future<T?> showShrunk<T>({
    required List<Widget> Function(BuildContext context) childrenBuilder,
    EdgeInsets? padding,
  }) {
    FocusScope.of(context).unfocus();
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      clipBehavior: Clip.antiAlias,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: padding ?? const AppStyle().insets.screenH.asPaddingH,
                child: Column(
                  children: childrenBuilder(ctx),
                ),
              ),
              const AppStyle().insets.md.asVSpan,
            ],
          ),
        );
      },
    );
  }

  /// Shows the modal with a list of [ModalBottomSheetAction] actions.
  ///
  /// If the [onDismiss] Function is not null, it will be called when the modal
  /// is dismissed: since the modal returns a [Future], the callback is executed
  /// in the [Future.then].
  ///
  /// The [isDismissible] flag specifies whether the modal can be dismissed by
  /// tapping outside of it or if an action must be picked in order to dismiss
  /// it. By default it is true.
  ///
  /// If [title] is not null, it will be placed at the top of the modal bottom
  /// sheet.
  Future<void> showActions({
    required List<ModalBottomSheetAction> actions,
    Widget? title,
    void Function(BuildContext context)? onDismiss,
    bool isDismissible = true,
  }) {
    final actionWidgets = actions.map((action) {
      if (action == ModalBottomSheetActions.divider) {
        return Divider(color: context.col.onSurface.withValues(alpha: 0.16));
      }
      final listTile = ListTile(
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

      return listTile;
    }).toList();
    return showShrunk<void>(
      padding: EdgeInsets.zero,
      childrenBuilder: (context) => [
        if (title != null) ...[
          title,
          const AppStyle().insets.md.asVSpan,
        ],
        ...actionWidgets,
      ],
      // ignore: use_build_context_synchronously
    ).then((_) => onDismiss != null ? onDismiss(context) : null);
  }
}