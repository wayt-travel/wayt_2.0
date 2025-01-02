import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../../widgets/modal/modal.dart';
import 'travel_item_widget_context_menu.dart';

/// A widget that wraps a travel item and provides context menu on tap.
///
/// When the widget is tapped, a context menu is shown at the tap position and
/// the widget is highlighted with a semi-transparent color.
///
/// This widget is common to all [TravelItemEntity]s.
class TravelItemWidget extends StatefulWidget {
  final TravelItemEntity travelItem;
  final Widget child;

  const TravelItemWidget({
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
