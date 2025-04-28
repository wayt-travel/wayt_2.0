import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/context/context.dart';
import '../../../repositories/repositories.dart';
import '../../../widgets/widgets.dart';
import '../../folder_display/view/folder_page.dart';
import '../../folder_upsert/view/folder_modal.dart';
import '../../item_delete/bloc/delete_item/delete_item_cubit.dart';
import '../../item_move/view/move_travel_item_modal.dart';
import '../../widget_upsert/view/add_widget_mbs.dart';
import 'travel_widget.dart';

/// The steps to determine the position of the context menu on the y-axis
/// based on the tap position.
///
/// Given two values [a,b], the context menu is displayed:
/// - below the tap if the tap is in the above (a*100)% of the screen
/// - above the tap if the tap is in the below (b*100)% of the screen
/// - otherwise the context menu is y-centered on the tap position.
///
/// E.g., if [a,b] = [.4, .6], the context menu is displayed:
/// - below the tap if the tap is in the above 40% of the screen
/// - above the tap if the tap is in the below 60% of the screen
/// - otherwise the context menu is y-centered on the tap position.
const _ySteps = [.4, .6];

/// Same as [_ySteps] but for the x-axis.
const _xSteps = [.25, .75];

/// A context menu for a [TravelWidget].
class TravelItemWidgetContextMenu extends StatelessWidget {
  /// The travel item for which the context menu is displayed.
  final TravelItemEntity travelItem;

  /// The actions to display in the context menu.
  final List<ModalBottomSheetAction> actions;

  /// Creates a travel item widget context menu.
  const TravelItemWidgetContextMenu({
    required this.travelItem,
    required this.actions,
    super.key,
  });

  /// Computes the position of the context menu based on the tap position.
  static ({
    Alignment? animationAlignment,
    double? bottom,
    double? left,
    Offset offset,
    double? right,
    double? top,
  }) _computePosition({
    required BuildContext context,
    required Offset position,
  }) {
    final x = position.dx;
    final y = position.dy;
    final w = context.mq.size.width;
    final h = context.mq.size.height;
    final margin = $.style.insets.xs;

    Alignment? animationAlignment;
    double? top;
    double? bottom;
    late final double yOffset;

    if (y < h * _ySteps[0]) {
      // show below the tap
      top = y + margin;
      yOffset = 0;
      animationAlignment = Alignment.topCenter;
    } else if (y > h * _ySteps[1]) {
      // show above the tap
      bottom = h - y + margin;
      yOffset = 0;
      animationAlignment = Alignment.bottomCenter;
    } else {
      top = y;
      yOffset = -.5;
    }

    double? left;
    double? right;
    late final double xOffset;

    if (x < w * _xSteps[0]) {
      // show to the right of the tap
      left = x + margin;
      xOffset = 0;
      if (animationAlignment == null) {
        animationAlignment = Alignment.centerLeft;
      } else if (animationAlignment == Alignment.topCenter) {
        animationAlignment = Alignment.topLeft;
      } else if (animationAlignment == Alignment.bottomCenter) {
        animationAlignment = Alignment.bottomLeft;
      }
    } else if (x > w * _xSteps[1]) {
      // show to the left of the tap
      right = w - x + margin;
      xOffset = 0;
      if (animationAlignment == null) {
        animationAlignment = Alignment.centerRight;
      } else if (animationAlignment == Alignment.topCenter) {
        animationAlignment = Alignment.topRight;
      } else if (animationAlignment == Alignment.bottomCenter) {
        animationAlignment = Alignment.bottomRight;
      }
    } else {
      left = w / 2;
      xOffset = -.5;
    }
    return (
      animationAlignment: animationAlignment,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      offset: Offset(xOffset, yOffset),
    );
  }

  static void _onEdit(
    BuildContext context, {
    required TravelItemEntity travelItem,
  }) {
    if (travelItem.isFolderWidget) {
      FolderModal.show(
        context: context,
        travelDocumentId: travelItem.travelDocumentId,
        index: null,
        folder: travelItem.asFolderWidget,
      );
    } else {
      SnackBarHelper.I.showNotImplemented(context);
    }
  }

  static void _onDelete({
    required BuildContext context,
    required BuildContext innerContext,
    required TravelItemEntity travelItem,
  }) {
// FIXME: l10n
    var subtitle = 'This action cannot be undone.';

    if (travelItem.isFolderWidget) {
      // FIXME: l10n
      subtitle += ' All widgets inside this folder will be deleted too.';
    }
    WConfirmDialog.show(
      context: innerContext,
      // FIXME: l10n
      title: 'Are you sure?',
      confirmActionColor: context.col.error,
      subtitle: subtitle,
      onConfirm: () async {
        final bloc = DeleteItemCubit(
          item: travelItem,
          repository: $.repo.travelItem(),
          travelDocumentLocalMediaDataSource:
              TravelDocumentLocalMediaDataSource.I,
        );
        await context.navRoot
            .pushBlocListenerBarrier<DeleteItemCubit, DeleteItemState>(
          bloc: bloc,
          trigger: bloc.delete,
          listener: (context, state) {
            if (state.status == StateStatus.success) {
              context.navRoot.pop();
            } else if (state.status == StateStatus.failure) {
              SnackBarHelper.I.showError(
                context: context,
                message: state.error.toString(),
              );
              context.pop();
            }
          },
        );

        bloc.close().ignore();
      },
    );
  }

  /// Shows the context menu for a travel item.
  static Future<void> showForItem({
    required int index,
    required BuildContext context,
    required TravelItemEntity travelItem,
    required Offset position,
  }) {
    final folderId = travelItem.isWidget ? travelItem.asWidget.folderId : null;
    return TravelItemWidgetContextMenu._show(
      context,
      travelItem: travelItem,
      position: position,
      actions: [
        if (travelItem.isFolderWidget)
          ModalBottomSheetAction(
            // FIXME: l10n
            title: 'Open',
            iconData: Icons.launch,
            onTap: (context) => FolderPage.push(
              context,
              travelDocumentId: travelItem.travelDocumentId,
              folderId: travelItem.id,
            ),
          ),
        ModalBottomSheetAction(
          // FIXME: l10n
          title: 'Add widget above',
          iconData: Icons.arrow_upward,
          onTap: (context) => AddWidgetMbs.show(
            context,
            folderId: folderId,
            id: travelItem.travelDocumentId,
            // By passing the same index as the current widget, the new
            // widget will be inserted above the current widget.
            index: index,
          ),
        ),
        ModalBottomSheetAction(
          // FIXME: l10n
          title: 'Add widget below',
          iconData: Icons.arrow_downward,
          onTap: (context) => AddWidgetMbs.show(
            context,
            folderId: folderId,
            id: travelItem.travelDocumentId,
            // By passing the index + 1, the new widget will be inserted
            // below the current widget. It is not a problem if the index is
            // >= the number of widgets in the list, as in such case the new
            // widget will be added at the end of the list.
            index: index + 1,
          ),
        ),
        ModalBottomSheetActions.edit(context).copyWith(
          onTap: (_) => _onEdit(
            context,
            travelItem: travelItem,
          ),
        ),
        if (!travelItem.isFolderWidget)
          ModalBottomSheetAction(
            // FIXME: l10n
            title: folderId != null ? 'Move' : 'Move into folder...',
            iconData: Icons.drive_file_move,
            onTap: (context) {
              MoveTravelItemModal.show(
                context: context,
                travelItemsToMove: [travelItem],
                travelDocumentId: travelItem.travelDocumentId,
                sourceFolderId: folderId,
              );
            },
          ),
        ModalBottomSheetActions.divider,
        ModalBottomSheetActions.delete(context).copyWith(
          onTap: (innerContext) => _onDelete(
            context: context,
            innerContext: innerContext,
            travelItem: travelItem,
          ),
          isDangerous: true,
        ),
      ],
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required Offset position,
    required TravelItemEntity travelItem,
    required List<ModalBottomSheetAction> actions,
  }) =>
      context.navRoot.push(
        PageRouteBuilder<void>(
          reverseTransitionDuration: $.style.times.fastest,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (context, _, __) {
            final (:animationAlignment, :top, :bottom, :left, :right, :offset) =
                _computePosition(
              context: context,
              position: position,
            );
            return GestureDetector(
              onTap: () => context.navRoot.pop(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Positioned(
                      top: top,
                      bottom: bottom,
                      left: left,
                      right: right,
                      child: FractionalTranslation(
                        translation: offset,
                        child: Animate(
                          effects: [
                            ScaleEffect(
                              duration: $.style.times.fastest,
                              alignment: animationAlignment,
                            ),
                          ],
                          child: TravelItemWidgetContextMenu(
                            actions: actions,
                            travelItem: travelItem,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          barrierColor: Colors.black38,
          barrierDismissible: true,
          opaque: false,
          transitionDuration: Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      // Use material so that the list tile shows ripple effect on it.
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: context.col.surfaceContainerHigh,
        borderRadius: $.style.corners.md.asBorderRadius,
        child: Column(
          children: actions
              .map(
                (action) => ModalBottomSheetTile(
                  dense: true,
                  action: action,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
