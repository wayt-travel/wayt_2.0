import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../features.dart';

/// A widget that wraps a travel item and provides context menu on tap.
///
/// When the widget is tapped, a context menu is shown at the tap position and
/// the widget is highlighted with a semi-transparent color.
///
/// This widget is common to all [TravelItemEntity]s.
class TravelWidget extends StatelessWidget {
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

  Widget _getTile() {
    final item = travelItem;
    if (item is PhotoWidgetModel) {
      return PhotoWidgetTile(
        index: index,
        photo: item,
      );
    } else if (item is TextWidgetModel) {
      return TextWidgetTile(
        index: index,
        text: item,
      );
    } else if (item is PlaceWidgetModel) {
      return PlaceWidgetTile(
        index: index,
        place: item,
      );
    } else if (item is TransferWidgetModel) {
      return TransferWidgetTile(
        index: index,
        transfer: item,
      );
    }
    return ListTile(
      title: Text('Item ${item.asWidget.type} is not supported yet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getTile();
  }
}
