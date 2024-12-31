import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';

class PlanPageBody extends StatelessWidget {
  final PlanEntity plan;
  final List<TravelItemEntity> travelItems;
  const PlanPageBody({
    required this.plan,
    required this.travelItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: plan.itemIds.length,
      itemBuilder: (context, index) {
        final itemId = plan.itemIds[index];
        final item = travelItems.firstWhere((item) => item.id == itemId);
        if (item.isFolderWidget) {
          // TODO: Implement folder widgets
          throw UnimplementedError('Folder widgets are not supported yet');
        } else {
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
      },
    );
  }
}
