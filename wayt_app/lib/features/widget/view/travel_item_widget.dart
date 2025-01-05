import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../../widgets/modal/modal.dart';
import '../../add_edit_widget/view/add_widget_mbs.dart';
import 'travel_item_widget_context_menu.dart';

/// A widget that wraps a travel item and provides context menu on tap.
///
/// When the widget is tapped, a context menu is shown at the tap position and
/// the widget is highlighted with a semi-transparent color.
///
/// This widget is common to all [TravelItemEntity]s.
class TravelItemWidget extends StatefulWidget {
  final int index;
  final TravelItemEntity travelItem;
  final Widget child;

  const TravelItemWidget({
    required this.index,
    required this.travelItem,
    required this.child,
    super.key,
  });

  @override
  State<TravelItemWidget> createState() => _TravelItemWidgetState();
}

class _TravelItemWidgetState extends State<TravelItemWidget> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        setState(() => _isHovering = true);
        TravelItemWidgetContextMenu.show(
          context,
          position: details.globalPosition,
          actions: [
            ModalBottomSheetAction(
              // FIXME: l10n
              title: 'Add widget above',
              iconData: Icons.arrow_upward,
              onTap: (context) => AddWidgetMbs.show(
                context,
                id: widget.travelItem.planOrJournalId,
                // By passing the same index as the current widget, the new
                // widget will be inserted above the current widget.
                index: widget.index,
              ),
            ),
            ModalBottomSheetAction(
              // FIXME: l10n
              title: 'Add widget below',
              iconData: Icons.arrow_downward,
              onTap: (context) => AddWidgetMbs.show(
                context,
                id: widget.travelItem.planOrJournalId,
                // By passing the index + 1, the new widget will be inserted
                // below the current widget. It is not a problem if the index is
                // >= the number of widgets in the list, as in such case the new
                // widget will be added at the end of the list.
                index: widget.index + 1,
              ),
            ),
            ModalBottomSheetActions.edit(context),
            ModalBottomSheetActions.divider,
            ModalBottomSheetActions.delete(context),
          ],
        ).then((_) => setState(() => _isHovering = false));
      },
      child: ColoredBox(
        color: _isHovering
            ? context.col.primary.withValues(alpha: 0.3)
            : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}
