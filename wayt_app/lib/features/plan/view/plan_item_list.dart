import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../widget/widget.dart';

/// A widget displaying the list of travel items of a plan.
class PlanItemList extends StatelessWidget {
  /// The plan.
  final PlanEntity plan;

  /// The list of travel items.
  final List<TravelItemEntity> travelItems;

  /// Creates a new instance of [PlanItemList].
  const PlanItemList({
    required this.plan,
    required this.travelItems,
    super.key,
  });

  /// Builds a tile for a travel item.
  Widget _buildTile(BuildContext context, TravelItemEntity item) {
    if (item is TextWidgetModel) {
      return ListTile(
        title: Text(
          item.textFeature.data,
          style: item.textFeature.textStyle?.toFlutterTextStyle(context),
        ),
      );
    }
    // TODO: Implement other widget types
    return ListTile(
      title: Text('Item ${item.asWidget.type} is not supported yet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: travelItems.length,
      itemBuilder: (context, index) {
        final item = travelItems[index];
        if (item.isFolderWidget) {
          // TODO: Implement folder widgets
          throw UnimplementedError('Folder widgets are not supported yet');
        } else {
          // TODO: wrap each item with its own cubit/bloc
          return TravelItemWidget(
            key: ValueKey(item.id),
            index: index,
            travelItem: item,
            child: _buildTile(context, item),
          );
        }
      },
    );
  }
}
