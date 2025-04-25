import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../features.dart';

/// A widget that wraps a travel item and provides context menu on tap.
///
/// When the widget is tapped, a context menu is shown at the tap position and
/// the widget is highlighted with a semi-transparent color.
///
/// This widget is common to all [TravelItemEntity]s.
class TravelWidget extends StatefulWidget {
  /// The index of the travel item in the list of items.
  final int index;

  /// The travel item to wrap.
  final TravelItemEntity travelItem;

  /// Creates a travel widget.
  const TravelWidget({
    required this.index,
    required this.travelItem,
    super.key,
  });

  @override
  State<TravelWidget> createState() => _TravelWidgetState();
}

class _TravelWidgetState extends State<TravelWidget> {
  bool _isHovering = false;

  Widget _getTile() {
    final item = widget.travelItem;
    if (item is PhotoWidgetModel) {
      return PhotoWidgetTile(item);
    } else if (item is TextWidgetModel) {
      return TextWidgetTile(item);
    }
    return ListTile(
      title: Text('Item ${item.asWidget.type} is not supported yet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onLongPress: () {
      //   SnackBarHelper.I.showNotImplemented(context);
      // },
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
        child: _getTile(),
      ),
    );
  }
}
