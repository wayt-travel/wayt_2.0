import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import 'travel_item_widget_context_menu.dart';

/// A widget that wraps a travel item and provides context menu on tap.
///
/// When the widget is tapped, a context menu is shown at the tap position and
/// the widget is highlighted with a semi-transparent color.
///
/// This widget is common to all [TravelItemEntity]s.
class TravelWidget extends StatefulWidget {
  final int index;
  final TravelItemEntity travelItem;
  final Widget child;

  const TravelWidget({
    required this.index,
    required this.travelItem,
    required this.child,
    super.key,
  });

  @override
  State<TravelWidget> createState() => _TravelWidgetState();
}

class _TravelWidgetState extends State<TravelWidget> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        setState(() => _isHovering = true);
        TravelItemWidgetContextMenu.showForItem(
          context: context,
          position: details.globalPosition,
          travelItem: widget.travelItem,
          folderId: widget.travelItem.isWidget
              ? widget.travelItem.asWidget.folderId
              : null,
          index: widget.index,
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
